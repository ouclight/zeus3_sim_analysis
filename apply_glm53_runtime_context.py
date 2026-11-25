#!/usr/bin/env python3
"""Apply GLM-5.3 model and decode-restore runtime-context compatibility fixes."""
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


PAYLOAD = {"PS1-DevExample/full_model_test/glm5_3_flash/fake_manager.py":{"after":"0222c52a59f78f488ab094e9f9fda1ba0fed6e62bd787027c9cd81c9d63f7320","before":"b8df6e0a8b97f98cec3009b3f0185a144761b9d573f4298fd19487abe730a52f","data":"eNqVVm1v2zYQ/q5fwemTAzjqsK7F0CHA0iXdgDRdtwb5sCKgafEkc6FIjaTSeL9+D6kXK463ef5k3R3v5bnjc8zz/IM9DU4YX5Fja2uDx1fLGgpCiiBYZR0LG2I/vb8+fVW8ZLJr2lNl/qAyKGuY71SgIstWK0+ha7kPIhC/f+DC1X61YqUwxgYmyZdOrQmulGeNlaTfMBU8k8q3IpQbBrEwcKOqF6RVhaNhIwJzVCsfyHlGCmk4tlp9iiFuti0V1+fXb89huVitft6unZLvlSHhrm4/WqtXq5PMPrW/+DRY48+NvSdzYyfbJTP0kCAImyVSkanq36nzDNashVUmLXkWy1FNq6khE+C+pjBUve4qrkxlY91IXWhdsBs4qcQ9sbUoEVCi9ofkJFtvA/kl85ZZo7cpmjKSHmHeKK1g1IiAyr8HeKUWLmJHDQBzgF5vl4weRfzDhAdstW5e8W941X73IobjjTCiJle0WyST8o6NjIh7ZWpNqajSNq01KAMNvEhBoEsIIPY9zgApKtGsj45QjS1/7agjOFx3SsvesBVbbYVMlaQpMJKPwwNLJEvqIbnqQUKNqsT3GfvciGYtuNc2LJn0grfImCvp71arIsvzPMuAs3WBVZ0pAxrgR4EyvgUKWZZJqlKuPFW9SVMwFr/4M6Z78iZj+FXONszXWpi68C4UGDxR1xgvEee4WAtPRWmNYUOIq9tzTPCSTdNzjJeYxBMv7yC4ur3u8znGQxeU9uPpiye6azTioAvXmaAa4ggc6DGMp+NgtsKhcaSzdDAOMYBPsBQhXgAebLysabqjharYIv2Jv95OOlEFvm8d72u8CR8wP9MBTFh/hoxYa4rXosZEzfXxzEZ4TLZbRD9Llled1qPb/GRuHCVFmgqv/iL21Rl7/W3SDz2NPyeUJ/ZbD8Glc9Yt8s74ro0YkJx4K13CHW8Bq0rVnUvIDlEjZQGevvOLnQzloAziYMl76L/eKdp2FPZ1D987A78FeTVcTnbzpixOCrl/YFftVGySA59SlBviMmAWgaybgnqIZadx2UPLv1h3j3+JYTkGw+Dj+dl+jIBwpQgXWZlZ13OYx8vL2+B8vnwu12T25SoWeUCuxZZcvNJzuegeDweYFPueomI/xGwEsHnSPIl0YVNJS/b5btbAnnpi9Yl49jbI7JLHFXH3r+j0rg7mP1PtVzBw3yGYhlOq4S2wCtBa91zvNViT2w4LAfcc037Ax0G0exXG/YH7jXCS18527dEofr5LSPCIwj6Uc4SVn8hXCz4uuzMQoPY9QTi8D5x5yog7XFPU6es58RUXlz/+cnG53COn3ex7cljf/Kmf3gi5zZIaCh92BzZJwGU8uD6O2xwybciJsp/vy/9N+zfDc+xtn3DP3dYpkJCI/H0gRoG9qkJk0Wa2a8Dm9dDV8Tj4lse3wst5xfmy79OcVlO3Ri942WlaDFu38Ko2AmqavJ4UkdOw9vFQO4k8vcg96Spf/gdRH1MJm8KxcgP4SIKuk9cfpndB8QVvVr9LJ6lje6O8JbmI2cxyQUlRUowP32lgkfoe+sW786vL3cnZJI/Reud7yP3zo6S3TuZDdsXzjrCYxzA6R4F0NjrL/gb4Zeu3"},"PS1-DevExample/full_model_test/glm5_3_flash/models/dsa.py":{"accepted":["e357d746682ee0cacd229d749f0a9d86605f21d2f7c1289646b3cddb9d729a78"],"after":"cfabec70e3b33e30850e655ede533a34b10f77424c5bf1d1014fb46ce500853b","before":"4f3ead806bdb14f349f5e78d63d87d488128d743f9e4598fc4f60bbd20cd28f5","data":"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"},"PS1-DevExample/full_model_test/glm5_3_flash/models/glm53.py":{"after":"9e312b5e9055eb5d7314e8106c2463d827dabdd23fabf2e9466b2fddecaac65b","before":"9b3b3cccf526a393aa271e13aa2c7fb3a5f4f0aa54bde96f1579a2511fdd33eb","data":"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"},"PS1-DevExample/full_model_test/glm5_3_flash/models/hf_config.py":{"after":"ecd538bbffbad93c0370659b76479098a05b233d7f32f6ed79c6537bd3ec632b","before":"034b60d81290f8c2eb722907d17dc2c41a569f90f85c529bd847b970360d101e","data":"eNp9Vttu3DYQfddXEMyDtYGspklcBAUWqOtbjdhuEacFAiMgaGm0SyxFKiS19vrrOyQlWZLX0UPiJc8czn2GUvoVHt2hVnJHtgIeiK6IWwMRdd06fi+B1K10otYll+Svc1Ksodg0WiiXU0oTUTfaOKJtklRG18QZrmylTQ3Gku7yHwN4LBSUJ1pVYhWRdiW5WuXWuLwIxzbfiFowiUBuetnPeHQVTjrZKJx3Mj3MoQ2sO+KWNAYaboCNjpMkKSS3llzI+uhDJEvnmi1+Twh+aCxI5nYNkCWhKxRgCplouBSW1dpfzFXL400PinYw7px6BTxCBKHut+Q7MEyUdp/YHBMEq1ZKTwPKCa1+TvAaNglMfzRGN2DcLvwqoSI1r+/5e1ZwDDxDp/LaphZk1bnKf/F032N7hPNqBS4yDASiwgTKQW2F0Sr39we3F1fHNxfs9Oy/y5OzgwVZLsnBE7T24PnZYLlPhpI7HmILQ8ph/CUvYIK1ax4C2t2lnT7hOJsg/YdZs13epcWaKwXSZmQtrNNmtyCY3f2PjPT3RCgyJvT5uf2+n5ZZKQpg/FHY5bvFBIL52Bo1UzGLqi/Dv8/4DhsxyRAwxoQSjrHg42xcGcsbrSAjb99uHrhZ2VEEMQDjChKWKO2Ih0/dbfgDOrAUhUsjx5R/9Hc2KqLlqISm5kYSpNxTsCk+lqFbXTrLDXpxdX30gd38e82ujr+dfbmlGaEf6WLxzB1580Y3KX3WA3HepP2wrbC+HuLbL5BvyKkOPpEQe9KB9aG0zrQFJgLGAhUFg2Y4gurh7RMYfXjPLZQk1BjBGstGfPDo64xUAmRJFK8BfYlECqxDkR8tx/p84r5GEVrI1mtn84Fg3rnyWdiHIA8S/jznplgLBwVmDni/39HQDs+xetbn2pzw1nJ5dU2/T8XWwEtWiholMALYPUz3DP2xYf0lOu390W+zB307YThPHEfZX9/hl7/bg7AFx862Qoz3+xSg2ppFb9mX7ytmdIse6xFeiU+fZkrUkrPWAlM6NICvpp09gW2bGVA4tlCNp59g/FvYsQsntiE2rGpV4YeEFatai5I+1yE2+E3JY4PttO2b7eOo9LoqHq58IwnvjaZDl5V3dCC0GKEk8c8YWGEvwic6zlen8HHrdDdDB9xoBrdOSJuvKzaWxS5W15iBHQU7+fvm/PKCfTm7uLz9+uXbXqJ+mI/1jzUYVTW7ni4dnBCHxjFCrz3ytoEiGyxjL5gynwWTY4sS7H7HfH7HKosp8Gx0Pjhq1I2y8TaQYaEhgunN0kc/ErwhOInQNNTmEDuUHzEbpR9UbG/EtxWL+xImxmqN/2PnHKzkFb421qAj/AzQhBULZ20B1h5KjdkfGqnvg5XwOYCa8tLvYgak5qWvDS+iMOu2QD4eHYY06BhHG1rffR/WolgTLq322YQFb0mrkIv77nJ6e/xLw1dwaH2y6y0YI0rouss8yHcjf33HVB95LOlmx8+ikb7SYRZ+ykwnzOsBT/ckSJrM5ioqxMIasBwHdYK658UGVBlhzHfdZUpj7jK/XeTDYpR7oz+wTiAPjFGJP+MR3bO10MnWQsPWQj0vfbEHzD9cIYDQURnFMh8pFJ2S+xbQa/X59Ni7pNdoMTXWez/YaJevtvmMYF/EtdXvacxgnj3GZS1UwJTOto2v2g67D4UD+H99BAbw"},"PS1-DevExample/full_model_test/glm5_3_flash/models/kda.py":{"accepted":["0db5c6825bdddd350a4a4d607e2e3a6f8766f8d6eabebb8bd3f38ef250b866fa"],"after":"0cbc7102212a8980545d1ea5fa8179defa519ee0ddf96298ac66a4e4e786a23b","before":"cb2b227b66f454a445157a20e3474c53bc1d3c95736d7183a8daacb46817a922","data":"eNq1WEtz2zYQvutXoOyhVMowdTK9pMNDJmlySJymaZuLx4OBxCWFigRoAJRsd/rfuwCfICnFaVMdHGmx+PaBfSYIgjfvLsnbVy9IpeSfsDVcCk2O3OwI3FYF33JDmDEg7MHj3z8QeRSg9I5XcRAEK15WUhlipNruVpmSZfOVtHQhVg1V5wUTeayViUuZQqHjPS85LbgApjrut0h6BYVhLzqBs8sFu0PpsX8v/PXtpw9MsaKA4p07ichLWdSlmFBXBD+XoHJIF8/JR7AmMwNpT5FHn2l9SifFUn7bWkR7l3U6frSnDcJp60675nWtIf14+dt7qco3Vr/ZXVUjZgl0K4WBW9NdzMHQFA58C5H7XrXGzO7Xhhe6u6WR8wg83xlridKr1SqFzAaCoHrHVAppd15IloIK2S3X6+fOwZbTUkMrq4zIgRU1tGf2o5jYk8TTJlzHDttU1J72rJrfA7I6oBgFV3BlBV33DHhikMGJiAVTSh6dKlEj5ZFDiNzfdX+JZ+5eA0i+8fAHNRtVuQbyyaL/jNgqDGymePng3EEaqJLrkpntLliPFUTolBkWb2V1R61TTHOswNRKOFehf7cF05q8Kcofn6GMcJ4LI+9SygU3lIYaiiwiLgApT28jsuNpCvhGzmoMhYznEbmpmTC0+6VKTQWGEYUK3VQpyPjt6HWEiC9lWhcQe1JGFs3erj8y9qzqn9JqMTwlgsQtEbnczzEj0kzlc4/scr894xylsQmvnneBD7sDltKUl50W7vd+Rjm0lAYiHhJbtK68Cjqk4NqXIOqS2jPdAVrCfk469KQzQnqwqZRCbllBF2U1hCdPZi5NJc2wlNCb/WGTWce9ZoWePBIKPnRPckYvvcNKQR3zHpSAwt0ZKTk0lLlqj/yn8BVA5ai9jNdmlT2cB0EHEk2ERF4qG2lab+1btycTdrLhTCfOIX7OJF4CeahN+iTNP+R7EvTKBxHpMoTmStZVErThPqoOToNNZ+xST1qw92trvHm4vplURLASCBckDDK8E+TB2q+Z2Dtsz2hrk+NGKZR1UqY99uyLjgz0hNjPaYMXjAzw71SX9fohivfuWXyeib5DzP9fun/+tdbzbLJZepFiiJ0efkI/9yNyNdhyjfn6zDdiHHmux2mamrsKEjf/xRl2NfPsaXQiQRp9Hp4iw524GTtcR+3KyvJpXAt9UwPcQ3gxgUsNtfrjfex21g0lGJxhGtWhrMxdOCperoxGZMG8qatf4DSUn0O9iMhFtFi93cHnRPhDWTi2JSJ/Bd5EFjw/N679sP77c8DOmC+EferDIop0s4ZtNNMJdpo6OI4k/mzC0P8HZt8gCTTPS8nTYAbf1s7ZnB6OU9ErMV+laMovLPKWbNVcWAPCbnhJRlOMDYybcZ+axoun32i+WOYmo3HjAXjuVW7suySTVxqGpcWTw8KJh+wKTBM0rSLz7B3Stn2s91JMaqgLzmQcp20eJOOkGN7g28bzw+huFdF1CZqwAjlB/4TzeM41ZiwXOQGGS2yfw8QccYEagW0UsL0mZgdYmDFIgbz88AeRWdbkwXeaZLVwsYc+Rj8XJEwRmyONxEai8IqDHgHaxmo4pGQPd3odk19Ecefgcd22+ti1o3Rjea+mJjmmUVN8rZI6PtGmnYNsq269Mm3YuA51zH2oxnTAfT7rXrilLrNeWaDrk13V8Tet1W2jk3a7jlOkbXfheiF5MGCPmBwbWYv0/GBq3UJH3KORFE0dFuLQyrNfSJKQ4B5qHfimjlZkao/jnZR7Hed2R6P7lHXbMq5uoxHWRbmltHtTv7XhqxyxaLYGdyUJnQB2D5Oau/97iTo+urGrZETuQUmKIYT5ip1h9HZojAfSWhPbJvJfTWp18JfhZl89a4an+zj93s/SBPGqgm0xA4f4IRUmW4sR46SYKdA7mwcjJIF7d3+DHDgciZauruBU41JbwAFPlFs0UDHMGSzcj51MjS5kOcQL8TWuTKcni1MjhYPo+v9Ql/qIXuAeppBxzZrfaP2ua3QOxmzn/38bQKt/AJqlobA="}}


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
import ast
import hashlib
import inspect
from pathlib import Path
import sys
from types import SimpleNamespace
from full_model_test.glm5_3_flash.config import CONFIG_SHA256
from full_model_test.glm5_3_flash.models.hf_config import Glm53Config, register
from full_model_test.glm5_3_flash.models.glm53 import EntryClass
from full_model_test.glm5_3_flash.models.kda import Glm53KDA
from full_model_test.glm5_3_flash.models.dsa import Glm53DSA
from full_model_test.glm5_3_flash.models import kda, dsa
from full_model_test.glm5_3_flash.fake_manager import make_fake_hybrid_manager
from sglang.srt.disaggregation.base.conn import StateType
from sglang.srt.disaggregation.fake.conn import FakeKVManager
from sglang.srt.runtime_context import get_parallel
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
projection_names = {"QKVParallelLinear", "ColumnParallelLinear", "MergedColumnParallelLinear",
                    "ReplicatedLinear", "RowParallelLinear"}
contracts = 0
for adapter in (kda, dsa):
    for call in ast.walk(ast.parse(inspect.getsource(adapter))):
        if not isinstance(call, ast.Call) or not isinstance(call.func, ast.Name):
            continue
        if call.func.id not in projection_names:
            continue
        assert not any(isinstance(arg, ast.Starred) for arg in call.args), "unresolved projection args"
        assert all(keyword.arg is not None for keyword in call.keywords), "unresolved projection kwargs"
        signature = inspect.signature(getattr(adapter, call.func.id))
        signature.bind(*[object() for arg in call.args],
                       **{keyword.arg: object() for keyword in call.keywords})
        if call.func.id != "ReplicatedLinear":
            assert any(keyword.arg == "parallel_group" for keyword in call.keywords)
        contracts += 1
assert contracts == 11, contracts
parallel = SimpleNamespace(attn_tp_rank=2, attn_tp_size=4)
assert dsa.projection_parallel_group(parallel, dict(tp_rank=2, tp_size=4)) == "attn_tp"
assert dsa.projection_parallel_group(parallel, dict(tp_rank=0, tp_size=1)) == "replicated"
queue = SimpleNamespace(
    token_to_kv_pool=SimpleNamespace(full_kv_pool=object(), page_size=64),
    draft_token_to_kv_pool=None, enable_staging=False, pp_rank=0,
    is_mla_backend=False, scheduler=SimpleNamespace(
        server_args=SimpleNamespace(device="cuda"),
        tp_worker=SimpleNamespace(model_runner=SimpleNamespace(kv_cache_dtype_str="bfloat16"))))
for dp_rank in (None, 0, 2):
    with get_parallel().override(dp_rank=dp_rank, attn_dp_rank=3):
        manager = make_fake_hybrid_manager(queue)
    assert isinstance(manager, FakeKVManager)
    assert manager.kv_args.system_dp_rank == dp_rank
    assert manager.kv_args.state_types == [StateType.MAMBA, StateType.DSA]
print("Model import:", EntryClass.__name__)
print("Effective config:", type(config).__name__)
print("Effective layers:", config.num_hidden_layers)
print("Native DSA overrides:", is_deepseek_dsa(config))
print("Linear constructor contracts:", contracts)
print("Fake restore metadata: scoped system DP rank; MAMBA + DSA")
print("PASS: GLM53 model, configuration, linear APIs and fake-restore manager")
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
        if current not in (recipe["before"], *recipe.get("accepted", [])):
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


def start_cuda_decode(root, model_path, depth, port, dump):
    if not dump.is_file():
        raise FileNotFoundError(dump)
    launcher = root / "PS1-DevExample/full_model_test/glm5_3_flash/run.sh"
    if not launcher.is_file():
        raise FileNotFoundError(launcher)
    runs = root / "glm53_runs"
    runs.mkdir(parents=True, exist_ok=True)
    # Share the prefill lock: both use GPU 0 and the same default port.
    with (runs / "cuda-prefill.lock").open("a") as lock:
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            raise RuntimeError("A CUDA stage started by this helper is still running") from None
        stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
        output = Path(tempfile.mkdtemp(prefix=f"4l_cuda_decode_{stamp}_", dir=runs))
        env = os.environ.copy()
        for key in ("PYTHONHOME", "PYTHONPATH", "SGLANG_PLATFORM"):
            env.pop(key, None)
        env.update(
            CUDA_PY=sys.executable,
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
        command = ["bash", "-c", '''
bash "$1" --stage cuda-decode --model-path "$2" --num-layers "$3" \\
  --max-new-tokens 3 --cpu-offload-gb 0 --port "$4" --output-dir "$5" --dump "$6"
glm53_status=$?
echo "CUDA_DECODE_EXIT_CODE=$glm53_status"
exit "$glm53_status"
''', "glm53-cuda-decode", str(launcher), str(model_path), str(depth), str(port), str(output), str(dump)]
        with (output / "run.log").open("wb") as log:
            process = subprocess.Popen(command, cwd=root / "PS1-DevExample", env=env,
                stdin=subprocess.DEVNULL, stdout=log, stderr=subprocess.STDOUT,
                start_new_session=True, pass_fds=(lock.fileno(),))
        (output / "run.pid").write_text(f"{process.pid}\n")
        (output / "source_dump.path").write_text(str(dump) + "\n")
        (runs / "current_cuda_decode.path").write_text(str(output) + "\n")
        print("CUDA decode PID:", process.pid, flush=True)
        print("Source dump:", dump, flush=True)
        print("Run directory:", output, flush=True)
        print("Log:", output / "run.log", flush=True)
        print("BACKGROUND CUDA DECODE STARTED; execution result is pending", flush=True)
        return process, output


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path("/workspace"))
    parser.add_argument("--model-path", type=Path)
    parser.add_argument("--num-layers", type=int, choices=range(1, 46), default=4)
    parser.add_argument("--device", choices=("cuda", "cpu"), default="cuda")
    start = parser.add_mutually_exclusive_group()
    start.add_argument("--start-prefill", action="store_true",
                       help="after successful checks, launch a fresh four-layer CUDA prefill in the background")
    start.add_argument("--start-cuda-decode", action="store_true",
                       help="after successful checks, restore --dump for two real CUDA decode steps in the background")
    parser.add_argument("--dump", type=Path)
    parser.add_argument("--port", type=int, default=30053)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--apply", action="store_true")
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--rollback", type=Path)
    args = parser.parse_args()
    print("Compatibility patch: runtime-context + linear-groups + fake-restore (v3)", flush=True)
    root = args.root.resolve()
    model = args.model_path or root / "private_model/GLM-5.3-Flash"
    if args.start_prefill or args.start_cuda_decode:
        if args.rollback or args.device != "cuda" or args.num_layers != 4:
            parser.error("starting a CUDA stage requires --apply/--check, --device cuda and four layers")
        if Path(sys.prefix).resolve() != (root / ".venv/glm53-cuda").resolve():
            parser.error(f"Use {root}/.venv/glm53-cuda/bin/python to start a CUDA stage")
        if not 1 <= args.port <= 65535:
            parser.error("port must be between 1 and 65535")
    if args.start_cuda_decode:
        if not args.dump or not args.dump.is_file():
            parser.error("--start-cuda-decode requires --dump pointing to an existing merged.pt")
    elif args.dump:
        parser.error("--dump is only used with --start-cuda-decode")
    if args.rollback:
        rollback(root, args.rollback.resolve())
    elif args.apply:
        apply(root, model.resolve(), args.num_layers, args.device)
    else:
        check(root, model.resolve(), args.num_layers, args.device)
    if args.start_prefill:
        start_prefill(root, model.resolve(), args.num_layers, args.port)
    elif args.start_cuda_decode:
        start_cuda_decode(root, model.resolve(), args.num_layers, args.port, args.dump.resolve())


if __name__ == "__main__":
    try:
        main()
    except Exception as error:
        print(f"FAIL: {type(error).__name__}: {error}", file=sys.stderr, flush=True)
        raise SystemExit(1)
