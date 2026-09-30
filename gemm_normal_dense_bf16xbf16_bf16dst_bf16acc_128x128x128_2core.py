# SIM_PARAMS: act:ptr:in:[1,1,"M","K"]:bf16  weight_c0:wgt_ptr:in:[1,"N_per_core","K"]:bf16  weight_c1:wgt_ptr:in:[1,"N_per_core","K"]:bf16  output:ptr:out:[1,1,"M","N"]:bf16  M:i32  K:i32  N:i32
# SIM_DERIVED_PARAMS: N_per_core
# SIM_GOLDEN: matmul
"""
GEMM kernel with M, K, N loops: C[M, N] = A[M, K] × B[K, N]

Dual-core, loops over all three dimensions including K (accumulation in bf16).
Weight 沿 N 维度切分, 每核处理 N_per_core = N / 2 列。
M, K, N are runtime values; BLOCK_M, BLOCK_K, BLOCK_N, CORE_NUM are compile-time constants.

注: 使用 bf16 累加器, 避免中端生成 linalg.generic(truncf)。
输出使用完整 N 形状 + per-core 偏移在 advance() 中, 保证 stride 和偏移正确。
"""

import triton
import triton.language as tl


@triton.jit
def gemm_mkn_loop_2core_kernel(
    a_ptr,          # input A base pointer [M, K]
    w_ptr_list,     # weight pointer list (per-core weight base address)
    c_ptr,          # output C base pointer [M, N]
    M, K, N,        # matrix dimensions (runtime)
    CORE_NUM: tl.constexpr,
    BLOCK_M: tl.constexpr,
    BLOCK_K: tl.constexpr,
    BLOCK_N: tl.constexpr,
):
    """
    Dual-core GEMM with M, K, N triple loops.
    K loop uses bf16 dot accumulation.
    """
    core_id = tl.program_id(0)
    N_per_core = N // CORE_NUM

    # Load this core's weight base address
    w_addr_value = tl.load(w_ptr_list + core_id)
    current_w_ptr = w_addr_value.to(tl.pointer_type(tl.bfloat16))

    total_m_blocks = tl.cdiv(M, BLOCK_M)
    total_n_blocks = tl.cdiv(N_per_core, BLOCK_N)
    total_k_blocks = tl.cdiv(K, BLOCK_K)

    # Pointer templates
    a_ptr_template = tl.make_block_ptr(
        base=a_ptr, shape=(M, K), strides=(K, 1),
        offsets=(0, 0), block_shape=(BLOCK_M, BLOCK_K), order=(1, 0),
    )

    b_ptr_template = tl.make_block_ptr(
        base=current_w_ptr, shape=(N_per_core, K), strides=(K, 1),
        offsets=(0, 0), block_shape=(BLOCK_N, BLOCK_K), order=(1, 0),
    )

    # CONTRACT: The host partitions N evenly across CORE_NUM weight buffers.
    # Keep the core axis explicit so each core has an independent tail bound.
    c_ptr_template = tl.make_block_ptr(
        base=c_ptr,
        shape=(M, CORE_NUM, N_per_core),
        strides=(N, N_per_core, 1),
        offsets=(0, core_id, 0),
        block_shape=(BLOCK_M, 1, BLOCK_N),
        order=(2, 1, 0),
    )

    # M × N × K triple loop
    for m_block in range(total_m_blocks):
        m_start = m_block * BLOCK_M

        for n_block in range(total_n_blocks):
            n_start = n_block * BLOCK_N

            # K accumulation loop (bf16 accumulator)
            acc = tl.zeros((BLOCK_M, BLOCK_N), dtype=tl.bfloat16)
            for k_block in range(total_k_blocks):
                k_start = k_block * BLOCK_K

                # Load A tile [BLOCK_M, BLOCK_K]
                a_tile_ptr = tl.advance(a_ptr_template, (m_start, k_start))
                a_tile = tl.load(a_tile_ptr,
                                 boundary_check=(0, 1),
                                 padding_option="zero")

                # Load B tile [BLOCK_N, BLOCK_K]
                b_tile_ptr = tl.advance(b_ptr_template, (n_start, k_start))
                b_tile_nk = tl.load(b_tile_ptr,
                                    memory_type='weight',
                                    boundary_check=(0, 1),
                                    padding_option="zero")

                # dot outputs f32, truncate to bf16 then accumulate
                c_tile = tl.dot(a_tile, tl.trans(b_tile_nk)).to(tl.bfloat16)
                acc += c_tile

            c_tile_ptr = tl.advance(c_ptr_template, (m_start, 0, n_start))
            tl.store(c_tile_ptr, tl.expand_dims(acc, 1), boundary_check=(0, 2))


signature = {
    'a_ptr': '*bf16',
    'w_ptr_list': '*i64',
    'c_ptr': '*bf16',
    'M': 'i32',
    'K': 'i32',
    'N': 'i32',
}

constants = {
    'CORE_NUM': 2,
    'BLOCK_M': 128,
    'BLOCK_K': 128,
    'BLOCK_N': 128,
}


if __name__ == "__main__":
    from kernel_to_linalg import kernel_to_linalg
    kernel_to_linalg(gemm_mkn_loop_2core_kernel, signature, constants, True)
