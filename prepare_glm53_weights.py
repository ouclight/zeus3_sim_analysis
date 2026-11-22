#!/usr/bin/env python3
"""Prepare the locked GLM53 checkpoint files needed by a four-layer smoke run.

With --download, download the selected original shards after identity and disk
checks. Without it, fetch only config/index metadata and print the plan.
"""
from __future__ import annotations

import argparse
import fnmatch
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import shutil
from types import SimpleNamespace

REPO_ID = "zai-org/GLM-5.3-Flash"
MODELSCOPE_REPO_ID = "ZhipuAI/GLM-5.3-Flash"
DEPTH = 4
GIB = 2 ** 30
RESERVE_BYTES = 25 * GIB
CONFIG_NAME = "config.json"
INDEX_NAME = "model.safetensors.index.json"
AUXILIARY_PATTERNS = (
    "tokenizer*", "tokenization_*.py", "configuration_*.py", "modeling_*.py",
    "special_tokens_map.json", "added_tokens.json", "vocab*", "merges*",
    "chat_template*", "additional_chat_templates/*.jinja", "generation_config.json",
)


def sha256_file(path):
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(8 * 1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def load_suite_config(path):
    spec = importlib.util.spec_from_file_location("glm53_checkpoint_config", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"Cannot load suite config: {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def select_files(index, siblings, active_weight):
    by_name = {item.rfilename: item for item in siblings}
    shards = sorted({filename for name, filename in index["weight_map"].items()
                     if active_weight(name, DEPTH)})
    if not shards:
        raise RuntimeError("The index selected no weights for the first four layers")
    auxiliary = sorted(name for name in by_name
                       if any(fnmatch.fnmatchcase(name, pattern) for pattern in AUXILIARY_PATTERNS))
    files = sorted(set(shards + auxiliary + [CONFIG_NAME, INDEX_NAME]))
    for name in files:
        path = Path(name)
        if path.is_absolute() or ".." in path.parts:
            raise RuntimeError(f"Invalid repository path: {name}")
        if name not in by_name or by_name[name].size is None:
            raise RuntimeError(f"Remote size metadata is missing for {name}")
        if not isinstance(by_name[name].size, int) or by_name[name].size < 0:
            raise RuntimeError(f"Invalid remote size for {name}")
    return shards, files, by_name


def budget(model_dir, files, by_name):
    total = sum(by_name[name].size for name in files)
    missing = 0
    for name in files:
        path = model_dir / name
        if not path.is_file() or path.stat().st_size != by_name[name].size:
            missing += by_name[name].size
    free = shutil.disk_usage(model_dir).free
    return dict(total_bytes=total, additional_bytes=missing, free_bytes=free,
                reserve_bytes=RESERVE_BYTES, fits=missing + RESERVE_BYTES <= free)


def lfs_sha256(item):
    direct = getattr(item, "sha256", None)
    if direct:
        return direct
    value = getattr(item, "lfs", None)
    if isinstance(value, dict):
        return value.get("sha256")
    return getattr(value, "sha256", None)


def modelscope_siblings(files):
    """Normalize ModelScope file metadata without inventing an HF revision."""
    result = []
    for item in files:
        if item.get("Type") == "tree":
            continue
        result.append(SimpleNamespace(
            rfilename=item["Path"], size=item.get("Size"),
            sha256=item.get("Sha256"), revision=item.get("Revision")))
    return result


def remote_info(args, suite, api):
    source = getattr(args, "source", "huggingface")
    if source == "huggingface":
        info = api.model_info(REPO_ID, revision=suite.REVISION, files_metadata=True, timeout=30)
        if info.sha != suite.REVISION:
            raise RuntimeError(f"Resolved revision mismatch: {info.sha}")
        return REPO_ID, suite.REVISION, info.siblings
    repo_id = getattr(args, "modelscope_repo", MODELSCOPE_REPO_ID)
    revision = getattr(args, "modelscope_revision", "master")
    files = api.get_model_files(model_id=repo_id, revision=revision, recursive=True)
    return repo_id, revision, modelscope_siblings(files)


def prepare(args, suite, api, download):
    model_dir = args.model_dir.resolve()
    model_dir.mkdir(parents=True, exist_ok=True)
    expected = {CONFIG_NAME: suite.CONFIG_SHA256, INDEX_NAME: suite.INDEX_SHA256}
    for name, digest in expected.items():
        path = model_dir / name
        if path.exists() and sha256_file(path) != digest:
            raise RuntimeError(f"Existing {path} belongs to a different snapshot; choose a new --model-dir")
    source = getattr(args, "source", "huggingface")
    print(f"下载源：{source}\n套件兼容版本：{suite.REVISION}\n目录：{model_dir}", flush=True)
    repo_id, revision, siblings = remote_info(args, suite, api)
    print(f"仓库：{repo_id}\n下载源版本：{revision}", flush=True)
    for name, digest in expected.items():
        print(f"获取并校验元数据：{name}", flush=True)
        path = Path(download(repo_id, filename=name, revision=revision,
                             local_dir=model_dir, etag_timeout=30))
        actual = sha256_file(path)
        if actual != digest:
            raise RuntimeError(f"Locked snapshot mismatch: {name}; expected={digest}, actual={actual}")
    raw = json.loads((model_dir / CONFIG_NAME).read_text())
    suite.text_config(raw, DEPTH)
    index = json.loads((model_dir / INDEX_NAME).read_text())
    shards, files, by_name = select_files(index, siblings, suite.active_weight)
    if source == "modelscope":
        for name in files:
            digest = lfs_sha256(by_name[name])
            if not digest or len(digest) != 64 or any(c not in "0123456789abcdef" for c in digest.lower()):
                raise RuntimeError(f"ModelScope SHA256 metadata is missing or invalid: {name}")
    plan = budget(model_dir, files, by_name)
    print(f"前 {DEPTH} 层所需原始权重分片：{len(shards)} 个", flush=True)
    for name in shards:
        print(f"  {name}: {by_name[name].size / GIB:.2f} GiB", flush=True)
    print(f"所选文件合计：{plan['total_bytes'] / GIB:.2f} GiB", flush=True)
    print(f"仍需下载：{plan['additional_bytes'] / GIB:.2f} GiB", flush=True)
    print(f"磁盘可用：{plan['free_bytes'] / GIB:.2f} GiB；额外保留：{RESERVE_BYTES / GIB:.0f} GiB", flush=True)
    if not plan["fits"]:
        raise RuntimeError("Disk budget insufficient; no weight shards were downloaded. Use a larger --model-dir")
    if not args.download:
        print("PLAN PASS: metadata only; add --download to fetch the selected shards", flush=True)
        return
    for number, name in enumerate(files, 1):
        # Recheck immediately before each transfer. Completed files may have
        # consumed space since the plan, as may other processes on the node.
        remaining = budget(model_dir, files, by_name)
        if not remaining["fits"]:
            raise RuntimeError("Disk budget changed during download; stopping before the next file")
        print(f"[{number}/{len(files)}] 下载/复用：{name}", flush=True)
        path = Path(download(repo_id, filename=name, revision=revision,
                             local_dir=model_dir, etag_timeout=30))
        if path.stat().st_size != by_name[name].size:
            raise RuntimeError(f"Downloaded size mismatch: {name}")
        digest = lfs_sha256(by_name[name])
        if digest:
            print(f"  校验 SHA256：{name}", flush=True)
            if sha256_file(path) != digest:
                raise RuntimeError(f"Downloaded SHA256 mismatch: {name}; do not use this shard")
    identity = suite.identity(model_dir, DEPTH)
    inventory = suite.weight_inventory(model_dir, DEPTH)
    active_bytes = sum(item["bytes"] for item in inventory.values())
    provenance = dict(source=source, repo_id=repo_id, requested_revision=revision,
        compatible_suite_revision=suite.REVISION,
        config_sha256=suite.CONFIG_SHA256, index_sha256=suite.INDEX_SHA256,
        model_num_layers=DEPTH, files={name: dict(size=by_name[name].size,
            sha256=lfs_sha256(by_name[name]),
            source_revision=getattr(by_name[name], "revision", None)) for name in files})
    (model_dir / "glm53_download_manifest.json").write_text(json.dumps(provenance, indent=2) + "\n")
    print(f"实际启用权重：{active_bytes / GIB:.2f} GiB，{len(inventory)} 个张量", flush=True)
    print(f"模型原始层数：{identity['original_num_layers']}；本次启用：{identity['model_num_layers']}", flush=True)
    print(f"GLM53_MODEL_PATH={model_dir}", flush=True)
    print("MODEL READY: GLM-5.3-Flash, first 4 layers", flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--download", action="store_true")
    parser.add_argument("--source", choices=("huggingface", "modelscope"), default="huggingface")
    parser.add_argument("--modelscope-repo", default=MODELSCOPE_REPO_ID)
    parser.add_argument("--modelscope-revision", default="master")
    parser.add_argument("--model-dir", type=Path,
                        default=Path("/workspace/private_model/GLM-5.3-Flash"))
    parser.add_argument("--suite-config", type=Path,
                        default=Path("/workspace/PS1-DevExample/full_model_test/glm5_3_flash/config.py"))
    args = parser.parse_args()
    suite = load_suite_config(args.suite_config)
    if args.source == "modelscope":
        from modelscope.hub.api import HubApi
        from modelscope.hub.file_download import model_file_download

        def download(repo_id, *, filename, revision, local_dir, etag_timeout):
            return model_file_download(model_id=repo_id, file_path=filename,
                                       revision=revision, local_dir=str(local_dir))

        prepare(args, suite, HubApi(endpoint="https://modelscope.cn"), download)
    else:
        # Download straight to local_dir via HTTP, avoiding a second weight cache.
        os.environ.setdefault("HF_HUB_DISABLE_XET", "1")
        os.environ.setdefault("HF_HUB_DOWNLOAD_TIMEOUT", "60")
        from huggingface_hub import HfApi, hf_hub_download
        prepare(args, suite, HfApi(), hf_hub_download)


if __name__ == "__main__":
    main()
