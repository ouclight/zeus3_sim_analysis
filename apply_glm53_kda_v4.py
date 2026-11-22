#!/usr/bin/env python3
"""Apply the GLM53 KDA v4 adapter patch with source checks and rollback.

Usage: python apply_glm53_kda_v4.py --check
       python apply_glm53_kda_v4.py --apply
       python apply_glm53_kda_v4.py --rollback <backup directory>
"""
import argparse
import ast
import base64
import datetime
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import zlib

PAYLOAD = json.loads(zlib.decompress(base64.b64decode(
    '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'
    'MI/9Ln3y8PD/AILDsNE='
)))
SELFCHECK = "\nimport inspect\nimport sys\nfrom pathlib import Path\nfrom dataclasses import dataclass\nfrom types import SimpleNamespace\n\nroot = Path(sys.argv[1]).resolve()\nfor path in reversed((root / 'PS1-DevExample', root / 'PS1-sglang/zeus/src',\n                      root / 'PS1-sglang/python', root / 'torch_zeus')):\n    sys.path.insert(0, str(path))\nimport torch\nimport sgl_kernel_zeus_triton as kernels\nfrom sglang_zeus.hooks import glm53_kda as hook\nfrom full_model_test.glm5_3_flash import inject, precision_audit\nfrom full_model_test.glm5_3_flash.state_adapters import glm53 as adapter\n\nfor module, filename in (\n    (hook, 'PS1-sglang/zeus/src/sglang_zeus/hooks/glm53_kda.py'),\n    (inject, 'PS1-DevExample/full_model_test/glm5_3_flash/inject.py'),\n    (adapter, 'PS1-DevExample/full_model_test/glm5_3_flash/state_adapters/glm53.py'),\n    (precision_audit, 'PS1-DevExample/full_model_test/glm5_3_flash/precision_audit.py'),\n):\n    assert Path(module.__file__).resolve() == (root / filename).resolve(), module.__file__\n\nprofile = inspect.getmodule(kernels.fused_kda_decode).fused_kda_compile_profile\nprofile(state_dtype=torch.bfloat16, version='v4_gdg')\ntry:\n    profile(state_dtype=torch.float32, version='v4_gdg')\nexcept ValueError:\n    pass\nelse:\n    raise AssertionError('Expected the v4 BF16 state ABI')\n\nweight = torch.arange(6144 * 4).reshape(6144, 1, 4).remainder(103).bfloat16()\nassert torch.equal(hook.prepare_conv_weight(weight, 'bf16'), weight[:, 0].T.contiguous())\nassert torch.equal(hook.prepare_conv_weight(weight, 'fp8'), weight[:, 0])\n\n@dataclass(frozen=True)\nclass State:\n    conv: list\n    temporal: torch.Tensor\n\nconv = torch.zeros(2, 3, 6144, 3, dtype=torch.bfloat16)\ntemporal = torch.randn(2, 3, 16, 128, 128, generator=torch.Generator().manual_seed(82))\npool = SimpleNamespace(mamba_cache=State([conv], temporal))\nhook.prepare_fused_pool(pool)\nassert pool._zeus_kda_layout == 'fused_v4_gdg'\nassert pool.mamba_cache.temporal.dtype == torch.bfloat16\nassert torch.equal(pool.mamba_cache.temporal, temporal.transpose(-1, -2).bfloat16())\nassert pool.mamba_cache.conv[0].shape == (2, 3, 3, 6144)\naddresses = pool.mamba_cache.conv[0].data_ptr(), pool.mamba_cache.temporal.data_ptr()\nhook.prepare_fused_pool(pool)\nassert addresses == (pool.mamba_cache.conv[0].data_ptr(), pool.mamba_cache.temporal.data_ptr())\n\nsource = torch.randn(64, 128, 128, generator=torch.Generator().manual_seed(83))\nsaved_source = source.clone()\nfor rank in range(4):\n    owner = torch.full((2, 16, 128, 128), -7, dtype=torch.bfloat16)\n    local = adapter.zeus_kda_state(source, 'recurrent', rank)\n    target, prepared = inject.prepare_kda_write(local, owner[1].transpose(-1, -2),\n        'recurrent', 'fused_v4_gdg', 'layers.0.recurrent')\n    assert torch.all(owner == -7)\n    assert target.is_contiguous() and prepared.is_contiguous()\n    target.copy_(prepared)\n    assert torch.equal(owner[1], source[rank * 16:(rank + 1) * 16].bfloat16())\n    assert torch.all(owner[0] == -7)\nassert torch.equal(source, saved_source) and source.dtype == torch.float32\n\nfor name in ('torch', 'triton', 'transformers', 'tokenizers'):\n    from importlib.metadata import version\n    print(name + ': ' + version(name))\nprint('PASS: KDA v4 layout and four-rank cache restore checks')\n"


def sha(data):
    return hashlib.sha256(data).hexdigest()


def write_atomic(path, data):
    mode = path.stat().st_mode & 0o777
    name = None
    try:
        with tempfile.NamedTemporaryFile(dir=path.parent, prefix='.glm53-v4-', delete=False) as stream:
            name = stream.name
            stream.write(data)
            stream.flush()
            os.fsync(stream.fileno())
        os.chmod(name, mode)
        os.replace(name, path)
    finally:
        if name and os.path.exists(name):
            os.unlink(name)


def selfcheck(root):
    env = dict(os.environ, CUDA_VISIBLE_DEVICES='', SGLANG_PLATFORM='zeus',
               SGLANG_DEVICE='zeus', SGLANG_ZEUS_DISABLE='0', PYTHONDONTWRITEBYTECODE='1')
    subprocess.run([sys.executable, '-c', SELFCHECK, str(root)],
                   env=env, check=True, timeout=60)


def check(root):
    pending = []
    errors = []
    for name, item in PAYLOAD.items():
        path = root / name
        if not path.is_file():
            errors.append('Missing source file: ' + str(path))
            continue
        data = path.read_bytes()
        actual = sha(data)
        if actual == item['old_sha256']:
            pending.append(name)
            print('READY: ' + name, flush=True)
        elif actual == item['new_sha256']:
            print('ALREADY PATCHED: ' + name, flush=True)
        else:
            errors.append('Source differs: ' + str(path) + '\n  found=' + actual
                          + '\n  expected=' + item['old_sha256'])
        source = item['source'].encode()
        if sha(source) != item['new_sha256']:
            errors.append('Invalid embedded payload: ' + name)
        ast.parse(source, filename=name)
    if errors:
        raise SystemExit('\n'.join(errors) + '\nNo source files were changed.')
    return pending


def rollback(root, backup):
    manifest = json.loads((backup / 'manifest.json').read_text())
    for name in manifest['changed']:
        if name not in PAYLOAD:
            raise SystemExit('Unexpected backup entry: ' + name)
        if sha((root / name).read_bytes()) != PAYLOAD[name]['new_sha256']:
            raise SystemExit('Refusing to overwrite a file changed after patching: ' + name)
        if sha((backup / name).read_bytes()) != manifest['before'][name]:
            raise SystemExit('Backup checksum mismatch: ' + name)
    for name in manifest['changed']:
        write_atomic(root / name, (backup / name).read_bytes())
    print('ROLLBACK COMPLETE', flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--root', type=Path, default=Path('/workspace'))
    action = parser.add_mutually_exclusive_group()
    action.add_argument('--check', action='store_true')
    action.add_argument('--apply', action='store_true')
    action.add_argument('--rollback', type=Path)
    args = parser.parse_args()
    root = args.root.resolve()
    if args.rollback:
        rollback(root, args.rollback.resolve())
        return
    pending = check(root)
    if not args.apply:
        print('CHECK PASS: ' + str(len(pending)) + ' files ready to update', flush=True)
        return
    if not pending:
        selfcheck(root)
        print('PATCH ALREADY APPLIED; CHECK PASS', flush=True)
        return
    stamp = datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ')
    backup = root / ('.glm53-kda-v4-backup-' + stamp)
    backup.mkdir()
    manifest = dict(changed=pending, before={})
    for name in pending:
        target = backup / name
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(root / name, target)
        manifest['before'][name] = sha(target.read_bytes())
    (backup / 'manifest.json').write_text(json.dumps(manifest, indent=2) + '\n')
    print('BACKUP: ' + str(backup), flush=True)
    written = []
    try:
        for name in pending:
            # Recheck after the backup to avoid overwriting concurrent edits.
            if sha((root / name).read_bytes()) != manifest['before'][name]:
                raise RuntimeError('Source changed during patching: ' + name)
            write_atomic(root / name, PAYLOAD[name]['source'].encode())
            written.append(name)
        selfcheck(root)
    except BaseException:
        for name in reversed(written):
            write_atomic(root / name, (backup / name).read_bytes())
        print('CHECK FAILED: restored files changed by this attempt. Backup: ' + str(backup), flush=True)
        raise
    print('PATCH APPLIED; CHECK PASS', flush=True)
    print('Rollback: ' + sys.executable + ' ' + str(Path(__file__).resolve())
          + ' --root ' + str(root) + ' --rollback ' + str(backup), flush=True)


if __name__ == '__main__':
    main()
