#!/usr/bin/env python3
"""Install the checkout's SGLang dependencies in the dedicated CUDA venv."""

import argparse
import fcntl
import hashlib
import importlib.metadata as metadata
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import tomllib


CORE_VERSIONS = {
    "torch": "2.14.1",
    "triton": "3.8.0",
    "sglang-kernel": "0.4.10",
    "nvidia-nvjitlink": "13.0.88",
}


def canonical_name(name):
    return re.sub(r"[-_.]+", "-", name).lower()


def installed_versions():
    result = {}
    for distribution in metadata.distributions():
        name = distribution.metadata.get("Name")
        if name:
            result.setdefault(canonical_name(name), distribution.version)
    return result


def make_plan(pyproject, versions):
    for name, expected in CORE_VERSIONS.items():
        actual = versions.get(name)
        if actual is None or actual.split("+", 1)[0] != expected:
            raise RuntimeError(f"Expected {name}=={expected}; found {actual}")

    with pyproject.open("rb") as stream:
        project = tomllib.load(stream)
    requirements = sorted(set(
        project["project"]["dependencies"] + project["build-system"]["requires"]
    ))
    protected = {
        name: version for name, version in versions.items()
        if name in CORE_VERSIONS or name.startswith(("nvidia-", "cuda-"))
    }
    constraints = [f"{name}=={version}" for name, version in sorted(protected.items())]
    return requirements, constraints, protected


def child_environment():
    env = os.environ.copy()
    for name in (
        "PYTHONPATH", "PYTHONHOME", "SGLANG_PLATFORM", "PIP_EXTRA_INDEX_URL",
        "PIP_FIND_LINKS", "PIP_NO_INDEX", "PIP_NO_CACHE_DIR", "UV_NO_CACHE",
    ):
        env.pop(name, None)
    env.update(
        PIP_CONFIG_FILE=os.devnull,
        PIP_INDEX_URL="https://pypi.org/simple",
        PIP_DISABLE_PIP_VERSION_CHECK="1",
        SGLANG_BUILD_RUST_EXTS="none",
        SGLANG_ZEUS_DISABLE="1",
        SGLANG_DEVICE="cuda",
        CUDA_VISIBLE_DEVICES="0",
        SGLANG_JIT_DEEPGEMM_PRECOMPILE="0",
    )
    env["PATH"] = str(Path(sys.executable).parent) + os.pathsep + env.get("PATH", "")
    env["VIRTUAL_ENV"] = sys.prefix
    return env


def run(command, env, cwd):
    print("RUN:", " ".join(map(str, command)), flush=True)
    subprocess.run(list(map(str, command)), env=env, cwd=cwd, check=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path("/workspace"))
    parser.add_argument("--plan-only", action="store_true")
    args = parser.parse_args()
    root = args.root.resolve()
    expected_prefix = root / ".venv" / "glm53-cuda"
    if Path(sys.prefix).resolve() != expected_prefix.resolve():
        raise RuntimeError(f"Run with {expected_prefix}/bin/python; current prefix: {sys.prefix}")
    if sys.prefix == sys.base_prefix:
        raise RuntimeError("A dedicated CUDA virtual environment is required")

    source = root / "PS1-sglang" / "python"
    project = source / "pyproject.toml"
    if not project.is_file():
        raise FileNotFoundError(project)
    log_dir = root / "install_logs" / "glm53-cuda-runtime"
    log_dir.mkdir(parents=True, exist_ok=True)
    with (log_dir / "install.lock").open("a") as lock:
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            raise RuntimeError("Another CUDA runtime installer is already running") from None

        requirements, constraints, protected = make_plan(project, installed_versions())
        requirements_path = log_dir / "requirements.txt"
        constraints_path = log_dir / "constraints.txt"
        requirements_path.write_text("\n".join(requirements) + "\n", encoding="utf-8")
        constraints_path.write_text("\n".join(constraints) + "\n", encoding="utf-8")
        (log_dir / "install-plan.json").write_text(json.dumps({
            "python": sys.executable,
            "source": str(source),
            "pyproject_sha256": hashlib.sha256(project.read_bytes()).hexdigest(),
            "protected_versions": protected,
            "requirements": requirements,
        }, indent=2) + "\n", encoding="utf-8")
        print(f"Requirements: {len(requirements)}; protected packages: {len(protected)}", flush=True)
        print(f"Plan: {log_dir / 'install-plan.json'}", flush=True)
        if args.plan_only:
            print("PLAN ONLY: no packages installed", flush=True)
            return

        env = child_environment()
        pip = [sys.executable, "-u", "-m", "pip", "install",
               "--index-url", "https://pypi.org/simple",
               "--cache-dir", str(root / "install_logs" / "pip-cache-glm53-cuda"),
               "--timeout", "120", "--retries", "10", "--progress-bar", "on",
               "--constraint", str(constraints_path)]
        run(pip + ["--requirement", requirements_path,
                   "--report", log_dir / "pip-install-report.json"], env, root)
        run(pip + ["--no-deps", "--no-build-isolation", "--editable", source], env, root)

        verification = r'''
import importlib.metadata as metadata
from pathlib import Path
import sys
import numpy
import torch
import sgl_kernel
import sglang
from sglang.srt.entrypoints.engine import Engine
expected = Path(sys.argv[1]).resolve()
actual = Path(sglang.__file__).resolve()
assert actual.is_relative_to(expected), (actual, expected)
print("Python:", sys.executable)
print("Torch:", torch.__version__)
print("NumPy:", numpy.__version__)
print("sglang-kernel:", metadata.version("sglang-kernel"))
print("sglang:", sglang.__file__)
print("sgl_kernel:", sgl_kernel.__file__)
for name, expected_version in __import__("json").loads(sys.argv[2]).items():
    actual_version = metadata.version(name)
    assert actual_version == expected_version, (name, actual_version, expected_version)
print("PASS: SGLang CUDA Engine import and protected version checks")
'''
        run([sys.executable, "-u", "-c", verification, source, json.dumps(protected)], env, root)


if __name__ == "__main__":
    try:
        main()
    except Exception as error:
        print(f"ERROR: {type(error).__name__}: {error}", file=sys.stderr, flush=True)
        print("INSTALL_EXIT_CODE=1", flush=True)
        raise SystemExit(1)
    print("INSTALL_EXIT_CODE=0", flush=True)
