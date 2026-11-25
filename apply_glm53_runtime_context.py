#!/usr/bin/env python3
"""Apply the GLM-5.3 external-model runtime-context compatibility fix."""
import argparse
import base64
from datetime import datetime, timezone
import fcntl
import hashlib
import json
import os
from pathlib import Path
import stat
import subprocess
import sys
import tempfile
import zlib


PAYLOAD = {"PS1-DevExample/full_model_test/glm5_3_flash/models/dsa.py":{"after":"e357d746682ee0cacd229d749f0a9d86605f21d2f7c1289646b3cddb9d729a78","before":"4f3ead806bdb14f349f5e78d63d87d488128d743f9e4598fc4f60bbd20cd28f5","data":"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"},"PS1-DevExample/full_model_test/glm5_3_flash/models/glm53.py":{"after":"9e312b5e9055eb5d7314e8106c2463d827dabdd23fabf2e9466b2fddecaac65b","before":"9b3b3cccf526a393aa271e13aa2c7fb3a5f4f0aa54bde96f1579a2511fdd33eb","data":"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"},"PS1-DevExample/full_model_test/glm5_3_flash/models/hf_config.py":{"after":"ecd538bbffbad93c0370659b76479098a05b233d7f32f6ed79c6537bd3ec632b","before":"034b60d81290f8c2eb722907d17dc2c41a569f90f85c529bd847b970360d101e","data":"eNp9Vttu3DYQfddXEMyDtYGspklcBAUWqOtbjdhuEacFAiMgaGm0SyxFKiS19vrrOyQlWZLX0UPiJc8czn2GUvoVHt2hVnJHtgIeiK6IWwMRdd06fi+B1K10otYll+Svc1Ksodg0WiiXU0oTUTfaOKJtklRG18QZrmylTQ3Gku7yHwN4LBSUJ1pVYhWRdiW5WuXWuLwIxzbfiFowiUBuetnPeHQVTjrZKJx3Mj3MoQ2sO+KWNAYaboCNjpMkKSS3llzI+uhDJEvnmi1+Twh+aCxI5nYNkCWhKxRgCplouBSW1dpfzFXL400PinYw7px6BTxCBKHut+Q7MEyUdp/YHBMEq1ZKTwPKCa1+TvAaNglMfzRGN2DcLvwqoSI1r+/5e1ZwDDxDp/LaphZk1bnKf/F032N7hPNqBS4yDASiwgTKQW2F0Sr39we3F1fHNxfs9Oy/y5OzgwVZLsnBE7T24PnZYLlPhpI7HmILQ8ph/CUvYIK1ax4C2t2lnT7hOJsg/YdZs13epcWaKwXSZmQtrNNmtyCY3f2PjPT3RCgyJvT5uf2+n5ZZKQpg/FHY5bvFBIL52Bo1UzGLqi/Dv8/4DhsxyRAwxoQSjrHg42xcGcsbrSAjb99uHrhZ2VEEMQDjChKWKO2Ih0/dbfgDOrAUhUsjx5R/9Hc2KqLlqISm5kYSpNxTsCk+lqFbXTrLDXpxdX30gd38e82ujr+dfbmlGaEf6WLxzB1580Y3KX3WA3HepP2wrbC+HuLbL5BvyKkOPpEQe9KB9aG0zrQFJgLGAhUFg2Y4gurh7RMYfXjPLZQk1BjBGstGfPDo64xUAmRJFK8BfYlECqxDkR8tx/p84r5GEVrI1mtn84Fg3rnyWdiHIA8S/jznplgLBwVmDni/39HQDs+xetbn2pzw1nJ5dU2/T8XWwEtWiholMALYPUz3DP2xYf0lOu390W+zB307YThPHEfZX9/hl7/bg7AFx862Qoz3+xSg2ppFb9mX7ytmdIse6xFeiU+fZkrUkrPWAlM6NICvpp09gW2bGVA4tlCNp59g/FvYsQsntiE2rGpV4YeEFatai5I+1yE2+E3JY4PttO2b7eOo9LoqHq58IwnvjaZDl5V3dCC0GKEk8c8YWGEvwic6zlen8HHrdDdDB9xoBrdOSJuvKzaWxS5W15iBHQU7+fvm/PKCfTm7uLz9+uXbXqJ+mI/1jzUYVTW7ni4dnBCHxjFCrz3ytoEiGyxjL5gynwWTY4sS7H7HfH7HKosp8Gx0Pjhq1I2y8TaQYaEhgunN0kc/ErwhOInQNNTmEDuUHzEbpR9UbG/EtxWL+xImxmqN/2PnHKzkFb421qAj/AzQhBULZ20B1h5KjdkfGqnvg5XwOYCa8tLvYgak5qWvDS+iMOu2QD4eHYY06BhHG1rffR/WolgTLq322YQFb0mrkIv77nJ6e/xLw1dwaH2y6y0YI0rouss8yHcjf33HVB95LOlmx8+ikb7SYRZ+ykwnzOsBT/ckSJrM5ioqxMIasBwHdYK658UGVBlhzHfdZUpj7jK/XeTDYpR7oz+wTiAPjFGJP+MR3bO10MnWQsPWQj0vfbEHzD9cIYDQURnFMh8pFJ2S+xbQa/X59Ni7pNdoMTXWez/YaJevtvmMYF/EtdXvacxgnj3GZS1UwJTOto2v2g67D4UD+H99BAbw"},"PS1-DevExample/full_model_test/glm5_3_flash/models/kda.py":{"after":"0db5c6825bdddd350a4a4d607e2e3a6f8766f8d6eabebb8bd3f38ef250b866fa","before":"cb2b227b66f454a445157a20e3474c53bc1d3c95736d7183a8daacb46817a922","data":"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"}}


def digest(data):
    return hashlib.sha256(data).hexdigest()


def target(root, relative):
    path = root / relative
    if not path.resolve().is_relative_to(root):
        raise RuntimeError(f"Source path escapes root: {path}")
    return path


def atomic_write(path, data, mode):
    descriptor, name = tempfile.mkstemp(prefix=f".{path.name}.glm53-", dir=path.parent)
    temporary = Path(name)
    try:
        with os.fdopen(descriptor, "wb") as stream:
            stream.write(data)
            stream.flush()
            os.fsync(stream.fileno())
        temporary.chmod(mode)
        temporary.replace(path)
    finally:
        temporary.unlink(missing_ok=True)


def check(root, model_path, depth, device):
    for relative, recipe in PAYLOAD.items():
        if digest(target(root, relative).read_bytes()) != recipe["after"]:
            raise RuntimeError(f"Patched source check failed: {relative}")
    if not (model_path / "config.json").is_file():
        raise FileNotFoundError(model_path / "config.json")
    env = os.environ.copy()
    env.pop("PYTHONHOME", None)
    env.pop("SGLANG_PLATFORM", None)
    env.update(
        PYTHONPATH=os.pathsep.join((str(root / "PS1-DevExample"),
                                   str(root / "PS1-sglang/python"))),
        SGLANG_DEVICE=device,
        SGLANG_ZEUS_DISABLE="1",
        CUDA_VISIBLE_DEVICES="" if device == "cpu" else "0",
        GLM53_NUM_LAYERS=str(depth),
    )
    code = r'''
import hashlib
from pathlib import Path
import sys
from full_model_test.glm5_3_flash.config import CONFIG_SHA256
from full_model_test.glm5_3_flash.models.hf_config import Glm53Config, register
from full_model_test.glm5_3_flash.models.glm53 import EntryClass
from full_model_test.glm5_3_flash.models.kda import Glm53KDA
from full_model_test.glm5_3_flash.models.dsa import Glm53DSA
from sglang.srt.configs.model_config import is_deepseek_dsa
from sglang.srt.utils.hf_transformers import get_config
path, depth = Path(sys.argv[1]), int(sys.argv[2])
assert hashlib.sha256((path / "config.json").read_bytes()).hexdigest() == CONFIG_SHA256
register()
config = get_config(str(path), trust_remote_code=False, local_files_only=True)
assert isinstance(config, Glm53Config), type(config)
assert config.num_hidden_layers == depth, config.num_hidden_layers
assert config.architectures == [EntryClass.__name__], config.architectures
assert not is_deepseek_dsa(config), "native DSA/page-size overrides must not match"
print("Model import:", EntryClass.__name__)
print("Effective config:", type(config).__name__)
print("Effective layers:", config.num_hidden_layers)
print("Native DSA overrides:", is_deepseek_dsa(config))
print("PASS: GLM53 model imports and active-prefix configuration")
'''
    subprocess.run([sys.executable, "-u", "-c", code, str(model_path), str(depth)],
                   env=env, check=True, timeout=180)


def apply(root, model_path, depth, device):
    changes = {}
    for relative, recipe in PAYLOAD.items():
        path = target(root, relative)
        original = path.read_bytes()
        current = digest(original)
        if current == recipe["after"]:
            print("ALREADY PATCHED:", relative, flush=True)
            continue
        if current != recipe["before"]:
            raise RuntimeError(f"Unrecognized source; no changes applied: {relative} ({current})")
        updated = zlib.decompress(base64.b64decode(recipe["data"]))
        if digest(updated) != recipe["after"]:
            raise RuntimeError(f"Invalid embedded payload: {relative}")
        compile(updated, str(path), "exec")
        changes[relative] = (original, updated, stat.S_IMODE(path.stat().st_mode))
    if not changes:
        check(root, model_path, depth, device)
        print("ALREADY APPLIED; CHECK PASS", flush=True)
        return

    if not (model_path / "config.json").is_file():
        raise FileNotFoundError(model_path / "config.json")
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S%fZ")
    backup = root / f".glm53-runtime-context-backup-{stamp}"
    backup.mkdir()
    manifest = {"root": str(root), "files": {}}
    for relative, (original, updated, mode) in changes.items():
        saved = backup / relative
        saved.parent.mkdir(parents=True, exist_ok=True)
        saved.write_bytes(original)
        manifest["files"][relative] = dict(before=digest(original), after=digest(updated), mode=mode)
    (backup / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print("BACKUP:", backup, flush=True)
    written = []
    try:
        for relative, (_, updated, mode) in changes.items():
            atomic_write(target(root, relative), updated, mode)
            written.append(relative)
            print("PATCHED:", relative, flush=True)
        check(root, model_path, depth, device)
    except BaseException:
        for relative in reversed(written):
            original, _, mode = changes[relative]
            atomic_write(target(root, relative), original, mode)
        print("CHECK FAILED; changed files restored", file=sys.stderr, flush=True)
        raise
    print("PATCH APPLIED; CHECK PASS", flush=True)
    print(f"Rollback: {sys.executable} {Path(__file__).resolve()} --root {root} --rollback {backup}", flush=True)


def rollback(root, backup):
    manifest = json.loads((backup / "manifest.json").read_text())
    if manifest["root"] != str(root):
        raise RuntimeError("Backup belongs to a different workspace root")
    restored = {}
    for relative, info in manifest["files"].items():
        if relative not in PAYLOAD:
            raise RuntimeError(f"Unexpected backup path: {relative}")
        if digest(target(root, relative).read_bytes()) != info["after"]:
            raise RuntimeError(f"Source changed after patch; refusing rollback: {relative}")
        data = (backup / relative).read_bytes()
        if digest(data) != info["before"]:
            raise RuntimeError(f"Backup checksum mismatch: {relative}")
        restored[relative] = (data, info["mode"])
    for relative, (data, mode) in restored.items():
        atomic_write(target(root, relative), data, mode)
        print("RESTORED:", relative, flush=True)
    print("ROLLBACK DONE", flush=True)


def start_prefill(root, model_path, depth, port):
    runs = root / "glm53_runs"
    runs.mkdir(parents=True, exist_ok=True)
    launcher = root / "PS1-DevExample/full_model_test/glm5_3_flash/run.sh"
    if not launcher.is_file():
        raise FileNotFoundError(launcher)
    with (runs / "cuda-prefill.lock").open("a") as lock:
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            raise RuntimeError("A CUDA prefill started by this helper is still running") from None
        stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
        output = Path(tempfile.mkdtemp(prefix=f"4l_fix_{stamp}_", dir=runs))
        env = os.environ.copy()
        for key in ("PYTHONHOME", "PYTHONPATH", "SGLANG_PLATFORM"):
            env.pop(key, None)
        env.update(
            CUDA_PY=sys.executable,
            ZEUS_PY=str(root / ".venv/glm53-zeus/bin/python"),
            CUDA_VISIBLE_DEVICES="0",
            CUDA_HOME="/usr/local/cuda-13.0",
            CUDACXX="/usr/local/cuda-13.0/bin/nvcc",
            GLM53_MODEL_PATH=str(model_path),
            GLM53_LOAD_CONCURRENCY="1",
            PYTHONUNBUFFERED="1",
            SGLANG_DEVICE="cuda",
            SGLANG_ZEUS_DISABLE="1",
        )
        env["PATH"] = os.pathsep.join(("/usr/local/cuda-13.0/bin",
                                      str(Path(sys.executable).parent), env.get("PATH", "")))
        command = ["bash", "-c",
            'bash "$1" --stage prefill --model-path "$2" --num-layers "$3" '
            '--max-new-tokens 1 --cpu-offload-gb 0 --port "$4" --output-dir "$5"; '
            'glm53_status=$?; echo "PREFILL_EXIT_CODE=$glm53_status"; exit "$glm53_status"',
            "glm53-prefill", str(launcher), str(model_path), str(depth), str(port), str(output / "prefill")]
        with (output / "prefill.log").open("wb") as log:
            process = subprocess.Popen(command, cwd=root / "PS1-DevExample", env=env,
                stdin=subprocess.DEVNULL, stdout=log, stderr=subprocess.STDOUT,
                start_new_session=True, pass_fds=(lock.fileno(),))
        # The background wrapper inherits this lock; closing our descriptor
        # keeps other launches blocked until that wrapper has finished.
        (output / "prefill.pid").write_text(f"{process.pid}\n")
        (runs / "current_run.path").write_text(str(output) + "\n")
        print("Prefill PID:", process.pid, flush=True)
        print("Run directory:", output, flush=True)
        print("Log:", output / "prefill.log", flush=True)
        print("BACKGROUND PREFILL STARTED; execution result is pending", flush=True)
        return process, output


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path("/workspace"))
    parser.add_argument("--model-path", type=Path)
    parser.add_argument("--num-layers", type=int, choices=range(1, 46), default=4)
    parser.add_argument("--device", choices=("cuda", "cpu"), default="cuda")
    parser.add_argument("--start-prefill", action="store_true",
                        help="after successful checks, launch a fresh four-layer CUDA prefill in the background")
    parser.add_argument("--port", type=int, default=30053)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--apply", action="store_true")
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--rollback", type=Path)
    args = parser.parse_args()
    root = args.root.resolve()
    model = args.model_path or root / "private_model/GLM-5.3-Flash"
    if args.start_prefill:
        if args.rollback or args.device != "cuda" or args.num_layers != 4:
            parser.error("--start-prefill requires --apply/--check, --device cuda and four layers")
        if Path(sys.prefix).resolve() != (root / ".venv/glm53-cuda").resolve():
            parser.error(f"Use {root}/.venv/glm53-cuda/bin/python to start CUDA prefill")
        if not 1 <= args.port <= 65535:
            parser.error("port must be between 1 and 65535")
    if args.rollback:
        rollback(root, args.rollback.resolve())
    elif args.apply:
        apply(root, model.resolve(), args.num_layers, args.device)
    else:
        check(root, model.resolve(), args.num_layers, args.device)
    if args.start_prefill:
        start_prefill(root, model.resolve(), args.num_layers, args.port)


if __name__ == "__main__":
    try:
        main()
    except Exception as error:
        print(f"FAIL: {type(error).__name__}: {error}", file=sys.stderr, flush=True)
        raise SystemExit(1)
