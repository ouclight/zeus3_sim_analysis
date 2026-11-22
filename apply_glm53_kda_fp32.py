#!/usr/bin/env python3
"""Apply the GLM53 FP32-state three-stage adapter patch with source checks and rollback.

Usage: python apply_glm53_kda_fp32.py --check
       python apply_glm53_kda_fp32.py --apply
       python apply_glm53_kda_fp32.py --rollback <backup directory>
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
)))
SELFCHECK = "\nimport sys\nfrom pathlib import Path\nfrom dataclasses import dataclass\nfrom types import SimpleNamespace\n\nroot = Path(sys.argv[1]).resolve()\nfor path in reversed((root / 'PS1-DevExample', root / 'PS1-sglang/zeus/src',\n                      root / 'PS1-sglang/python', root / 'torch_zeus')):\n    sys.path.insert(0, str(path))\nimport torch\nimport sgl_kernel_zeus_triton as kernels\nfrom sglang_zeus.hooks import glm53_kda as hook\nfrom sglang_zeus.attention import registry\nfrom full_model_test.glm5_3_flash import precision_audit\nfrom full_model_test.glm5_3_flash.state_adapters import glm53 as adapter\n\nfor module, filename in (\n    (hook, 'PS1-sglang/zeus/src/sglang_zeus/hooks/glm53_kda.py'),\n    (registry, 'PS1-sglang/zeus/src/sglang_zeus/attention/registry.py'),\n    (precision_audit, 'PS1-DevExample/full_model_test/glm5_3_flash/precision_audit.py'),\n):\n    assert Path(module.__file__).resolve() == (root / filename).resolve(), module.__file__\n\nfor name in ('linear_bf16_kda_in', 'fused_conv_recurrent_kda_indexed', 'rms_gated_o_proj'):\n    assert callable(getattr(kernels, name)), name\nfor name in ('linear_bf16_kda_in', 'rms_gated_o_proj'):\n    assert callable(getattr(kernels, name).pack), name + '.pack'\n\nweight = torch.arange(6144 * 4).reshape(6144, 1, 4).remainder(103).bfloat16()\nfor mode in ('bf16', 'fp8'):\n    assert torch.equal(hook.prepare_conv_weight(weight, mode), weight[:, 0])\n\n@dataclass(frozen=True)\nclass State:\n    conv: list\n    temporal: torch.Tensor\n\nconv = torch.zeros(2, 3, 6144, 3, dtype=torch.bfloat16)\ntemporal = torch.randn(2, 3, 16, 128, 128, generator=torch.Generator().manual_seed(82))\nstate = State([conv], temporal)\npool = SimpleNamespace(mamba_cache=state, conv_window_axis=-1)\naddresses = conv.data_ptr(), temporal.data_ptr()\noriginal_temporal = temporal.clone()\nhook.prepare_fused_pool(pool)\nhook.prepare_fused_pool(pool)\nassert pool._zeus_kda_layout == 'canonical_fp32'\nassert pool.mamba_cache is state and pool.conv_window_axis == -1\nassert addresses == (state.conv[0].data_ptr(), state.temporal.data_ptr())\nassert state.temporal.dtype == torch.float32 and torch.equal(state.temporal, original_temporal)\n\nsource = torch.randn(64, 128, 128, generator=torch.Generator().manual_seed(83))\nsaved_source = source.clone()\ncache = State([conv[0]], temporal[0])\nfor rank in range(4):\n    local = adapter.zeus_kda_state(source, 'recurrent', rank)\n    target = hook.canonical_cache_view(pool, cache, 'recurrent', 1)\n    assert target.dtype == local.dtype == torch.float32\n    target.copy_(local)\n    assert torch.equal(target.transpose(-1, -2), source[rank * 16:(rank + 1) * 16])\nassert torch.equal(source, saved_source)\n\nweights = {name: SimpleNamespace(weight=torch.empty(1, dtype=torch.bfloat16))\n    for name in ('qkv_proj','f_a_proj','g_a_proj','f_b_proj','g_b_proj','b_proj','o_proj')}\nattention = SimpleNamespace(**weights, _zeus_glm53_kda_mode='bf16',\n    _zeus_glm53_kda_impl='three_stage_fp32', _zeus_glm53_packed=True,\n    _zeus_glm53_pool=SimpleNamespace(mamba2_layer_cache=lambda layer_id: cache),\n    A_log=torch.empty(1), dt_bias=torch.empty(1))\nrows = {row['path_id']:row for row in precision_audit._kda_rows(0, attention)}\nassert rows['layer.0.kda.recurrent']['packed_dtype'] == 'fp32 state and decay metadata'\nassert rows['layer.0.kda.input_projection']['expected_kernels'] == ['sgl_linear_bf16_kda_in_kernel']\nassert rows['layer.0.kda.output_projection']['expected_kernels'] == ['sgl_rms_gated_o_proj_kernel']\nprint('recurrent_state_dtype: ' + str(state.temporal.dtype))\nprint('KDA path: linear_bf16_kda_in -> fused_conv_recurrent_kda_indexed -> rms_gated_o_proj')\nprint('PASS: FP32 KDA adapter checks')\n"


def sha(data):
    return hashlib.sha256(data).hexdigest()


def write_atomic(path, data):
    mode = path.stat().st_mode & 0o777
    name = None
    try:
        with tempfile.NamedTemporaryFile(dir=path.parent, prefix='.glm53-fp32-', delete=False) as stream:
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
        if actual in item['accepted_sha256']:
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
    backup = root / ('.glm53-kda-fp32-backup-' + stamp)
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
