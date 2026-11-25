#!/usr/bin/env python3
"""Check server A's Zeus stack, run four-layer decode, and compare all ranks."""
import argparse
from datetime import datetime, timezone
import fcntl
import hashlib
import json
import os
from pathlib import Path
import shlex
import subprocess
import sys
import tempfile
import traceback


def write_json(path, value):
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n")


def sha256(path):
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def require_file(path, executable=False):
    if not path.is_file() or (executable and not os.access(path, os.X_OK)):
        raise RuntimeError(f"Required {'executable' if executable else 'file'} missing: {path}")


def configure(root, output, simulator):
    repo = root / "PS1-DevExample"
    paths = (repo, root / "PS1-sglang/zeus/src", root / "PS1-sglang/python", root / "torch_zeus")
    for path in paths:
        if not path.is_dir():
            raise FileNotFoundError(path)
    for key in ("PYTHONHOME", "SGLANG_PLATFORM", "ZEUS_SIM_DAEMON_SOCKET",
                "ZEUS_SIM_DEVICE_INDEX", "GLM53_FORCED_TOKEN_FILE", "GLM53_DIAGNOSTIC_STEPS"):
        os.environ.pop(key, None)
    settings = dict(
        CUDA_PY=str(root / ".venv/glm53-cuda/bin/python"),
        ZEUS_PY=sys.executable, CUDA_VISIBLE_DEVICES="",
        PYTHONPATH=os.pathsep.join(map(str, paths)),
        SGLANG_PLATFORM="zeus", SGLANG_DEVICE="zeus", SGLANG_ZEUS_DISABLE="0",
        SGLANG_AUTO_NUMA_BIND="0", PYTHONUNBUFFERED="1",
        ZEUS3_CPP_SIMULATOR=str(simulator), ZEUS_SIMULATOR_ALLOW_OVERRIDE="1",
        ZEUSV3_SIMULATOR_DIR=str(root / "Zeus3FunctionalSimulator"),
        ZEUS_SIM_TOPOLOGY=str(root / "torch_zeus/zeus_sim_run/topologies/zeus3_ps1_topology.json"),
        ZEUS_SIM_DEVICE_COUNT="16", ZEUS_SIM_WEIGHT_DDR_SIZE_B="15435038720",
        ZECC_PYTHON_EXECUTABLE=sys.executable, ZECC_KERNEL_MODE="jit",
        ZECC_JIT_CACHE_DIR=str(output / "zecc-cache"), TRITON_CACHE_DIR=str(output / "triton-cache"),
        ZEUS_COMPILER_EXTRA_FLAGS="--num-vp=1 --num-dt=1 --gather-unroll-limit=32 --br-spill-mode=compiler-stack",
        SGLANG_ZEUS_GLM53_DSA_IMPL="legacy", SGLANG_ZEUS_FLAT_COMM="0",
        GLM53_LOAD_CONCURRENCY="1", GLM53_HOST_ESTIMATE_POLICY="enforce",
        GLM53_DIAGNOSTICS="0", GLM53_CACHE_CHECK="0", GLM53_DECODE_TIMING="0",
        GLM53_DECODE_WALL_TIMING="0", ENABLE_ZEUS_FALLBACK_TO_CPU="0", ZEUS_DUMP_FALLBACK="1",
        OMP_NUM_THREADS="1", MKL_NUM_THREADS="1",
    )
    os.environ.update(settings)
    os.environ.setdefault("GLM53_HOST_MIN_AVAILABLE_GIB", "192")
    sys.path[:0] = list(map(str, paths))
    require_file(simulator, executable=True)
    require_file(Path(settings["ZEUS_SIM_TOPOLOGY"]))
    require_file(root / "Zeus3FunctionalSimulator/npu_core_simulator/instruction_arch/inst.json")
    import triton
    try:
        from triton.tools.zeus_paths import tool_path
    except ImportError:
        def tool_path(name):
            return str(Path(triton.__file__).parent / "tools/zeus_bin" / name)
    tools = {name: Path(tool_path(name)).resolve() for name in ("zecc", "zeus-compiler", "triton-shared-opt")}
    for path in tools.values():
        require_file(path, executable=True)
    settings.update(ZECC=str(tools["zecc"]), ZEUS_COMPILER=str(tools["zeus-compiler"]),
                    TRITON_SHARED_OPT_PATH=str(tools["triton-shared-opt"]))
    settings["GLM53_HOST_MIN_AVAILABLE_GIB"] = os.environ["GLM53_HOST_MIN_AVAILABLE_GIB"]
    os.environ.update(settings)
    runtime = output / "zeus_runtime.env.sh"
    runtime.write_text("#!/usr/bin/env bash\n" + "\n".join(
        f"export {key}={shlex.quote(value)}" for key, value in settings.items()) + "\n")
    os.environ["ZEUS_RUNTIME_ENV"] = str(runtime)
    write_json(output / "toolchain.json", dict(simulator=dict(path=str(simulator), sha256=sha256(simulator)),
        tools={name: dict(path=str(path), sha256=sha256(path)) for name, path in tools.items()},
        triton=triton.__version__, triton_path=triton.__file__, environment=settings))


def check_inputs(root, reference, output):
    from full_model_test.glm5_3_flash.precision_audit import execution_report
    from full_model_test.glm5_3_flash.config import identity, weight_inventory
    from full_model_test.glm5_3_flash.dump_contract import CONTRACT
    from full_model_test.glm5_3_flash.preflight import preflight

    reference_report = execution_report(reference, expected_tokens=3)
    if not reference_report["passed"]:
        raise RuntimeError("CUDA reference is not qualified: " + "; ".join(reference_report["failures"]))
    dump = Path((reference / "source_dump.path").read_text().strip()).resolve()
    payload = CONTRACT.load(dump, expected_kind="merged").payload
    model = Path(payload["model"]["source_path"]).resolve()
    if payload["model"] != identity(model, 4):
        raise RuntimeError("Saved dump does not match the active four-layer checkpoint")
    obs = json.loads((reference / "runtime_observation.json").read_text())
    if obs["records"][0]["argmax"] != [payload["request"]["first_sampled_token"]]:
        raise RuntimeError("CUDA reference first token differs from the source dump")
    capacity = preflight(weight_inventory(model, 4), zeus=True)
    write_json(output / "zeus_capacity.json", capacity)
    print("Host memory estimate (GiB):", round(capacity["budget"]["host_increment_bound"] / 1024**3, 2), flush=True)
    print("Zeus capacity:", capacity["status"], flush=True)
    if capacity["status"] != "PASS":
        raise RuntimeError("BLOCKED: " + "; ".join(capacity["failures"]))
    os.environ["GLM53_MODEL_PATH"] = str(model)
    (output / "source_dump.path").write_text(str(dump) + "\n")
    (output / "cuda_reference.path").write_text(str(reference) + "\n")
    import torch
    import torch_zeus
    import sgl_kernel_zeus_triton as kernels
    from sglang_zeus.hooks import glm53_kda
    from sglang.srt.entrypoints.engine import Engine

    if torch.__version__.split("+")[0] != "2.10.0":
        raise RuntimeError(f"Expected the existing Zeus Torch 2.10.0 stack, found {torch.__version__}")
    if torch_zeus.preload_cpp_extension() is None:
        raise RuntimeError("torch_zeus native extension did not load")
    if getattr(glm53_kda, "KDA_STATE_LAYOUT", None) != "canonical_fp32":
        raise RuntimeError("FP32 KDA adapter missing; apply apply_glm53_kda_fp32.py first")
    required = ("linear_bf16_kda_in", "linear_fp8_uscale_kda_in", "fused_conv_recurrent_kda_indexed",
                "rms_gated_o_proj", "rms_gated_o_proj_fp8_uscale", "FusedKDAWorkspace")
    for name in required:
        if not callable(getattr(kernels, name, None)):
            raise RuntimeError(f"Missing FP32 KDA kernel API: {name}")
    write_json(output / "environment_check.json", dict(status="PASS", python=sys.executable,
        torch=torch.__version__, torch_zeus=torch_zeus.__file__, native=torch_zeus._C.__file__,
        kernels=kernels.__file__, engine=Engine.__module__, kda_state_layout=glm53_kda.KDA_STATE_LAYOUT,
        scope="first 4 layers, 3 output tokens, 16 Zeus ranks, eager functional simulation"))
    print("PASS: CUDA reference, Zeus environment and FP32 KDA checks", flush=True)
    return model, dump


def qualify(reference, output):
    from full_model_test.glm5_3_flash.precision_audit import compare

    ranks = {}
    for rank in range(16):
        try:
            log = output / f"scheduler.rank{rank}.log"
            require_file(log)
            if not log.stat().st_size:
                raise RuntimeError(f"Empty scheduler log: {log}")
            ranks[str(rank)] = compare(reference, output / f"rank{rank}", expected_dsa_layers={"3"})
        except Exception as error:
            ranks[str(rank)] = dict(status="FAIL", passed=False, failures=[f"{type(error).__name__}: {error}"])
    passed = all(report["passed"] for report in ranks.values())
    report = dict(status="PASS" if passed else "FAIL", passed=passed, ranks=ranks,
        scope="first 4 layers; restored first token plus two real decode steps; logits, tokens and DSA cache",
        cuda_reference=str(reference), zeus_output=str(output))
    write_json(output / "comparison.json", report)
    print("CUDA/Zeus comparison:", report["status"], flush=True)
    print("Comparison report:", output / "comparison.json", flush=True)
    return passed


def worker(args):
    output, reference = args.output_dir.resolve(), args.cuda_reference.resolve()
    try:
        configure(args.root.resolve(), output, args.simulator.resolve())
        model, dump = check_inputs(args.root.resolve(), reference, output)
        if args.check_only:
            print("ZEUS_CHECK_EXIT_CODE=0", flush=True)
            return 0
        command = ["bash", str(args.root.resolve() / "PS1-DevExample/full_model_test/glm5_3_flash/run.sh"),
            "--stage", "zeus-decode", "--model-path", str(model), "--dump", str(dump),
            "--num-layers", "4", "--max-new-tokens", "3", "--cpu-offload-gb", "0",
            "--port", str(args.port), "--output-dir", str(output)]
        print("Starting Zeus decode:", shlex.join(command), flush=True)
        completed = subprocess.run(command, cwd=args.root.resolve() / "PS1-DevExample")
        print("ZEUS_DECODE_EXIT_CODE=" + str(completed.returncode), flush=True)
        if completed.returncode:
            return 1
        status = 0 if qualify(reference, output) else 1
        print("ZEUS_QUALIFICATION_EXIT_CODE=" + str(status), flush=True)
        return status
    except Exception as error:
        write_json(output / "launcher_error.json", dict(error=type(error).__name__, message=str(error)))
        traceback.print_exc()
        return 1


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path("/workspace"))
    parser.add_argument("--cuda-reference", type=Path, required=True)
    parser.add_argument("--simulator", type=Path)
    parser.add_argument("--port", type=int, default=30053)
    parser.add_argument("--check-only", action="store_true")
    parser.add_argument("--worker", action="store_true", help=argparse.SUPPRESS)
    parser.add_argument("--output-dir", type=Path, help=argparse.SUPPRESS)
    args = parser.parse_args()
    root = args.root.resolve()
    if Path(sys.prefix).resolve() != (root / ".venv/glm53-zeus").resolve():
        parser.error(f"Use {root}/.venv/glm53-zeus/bin/python")
    if not 1 <= args.port <= 65535:
        parser.error("port must be in 1..65535")
    args.simulator = args.simulator or root / "GLIBC2.35/zeus3sim-func/zeus3sim"
    if args.worker:
        if not args.output_dir or not args.output_dir.is_dir():
            parser.error("worker requires an existing output directory")
        return worker(args)
    reference = args.cuda_reference.resolve()
    for name in ("source_dump.path", "runtime_observation.json", "result.json"):
        require_file(reference / name)
    runs = root / "glm53_runs"
    runs.mkdir(parents=True, exist_ok=True)
    with (runs / "zeus-decode.lock").open("a") as lock:
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            raise RuntimeError("A Zeus decode started by this helper is still running") from None
        stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
        output = Path(tempfile.mkdtemp(prefix=f"4l_zeus_decode_{stamp}_", dir=runs))
        command = [sys.executable, "-u", str(Path(__file__).resolve()), "--worker",
            "--root", str(root), "--cuda-reference", str(reference), "--simulator", str(args.simulator.resolve()),
            "--port", str(args.port), "--output-dir", str(output)]
        if args.check_only:
            command.append("--check-only")
        env = {key: value for key, value in os.environ.items() if key not in ("PYTHONHOME", "PYTHONPATH")}
        env["PYTHONUNBUFFERED"] = "1"
        with (output / "run.log").open("wb") as log:
            process = subprocess.Popen(command, env=env, cwd=root, stdin=subprocess.DEVNULL,
                stdout=log, stderr=subprocess.STDOUT, start_new_session=True, pass_fds=(lock.fileno(),))
        (output / "run.pid").write_text(str(process.pid) + "\n")
        (runs / "current_zeus_decode.path").write_text(str(output) + "\n")
        print("Zeus background PID:", process.pid, flush=True)
        print("Run directory:", output, flush=True)
        print("Log:", output / "run.log", flush=True)
        print("BACKGROUND STARTED; environment/capacity checks and execution are pending", flush=True)
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as error:
        print(f"FAIL: {type(error).__name__}: {error}", file=sys.stderr, flush=True)
        raise SystemExit(1)
