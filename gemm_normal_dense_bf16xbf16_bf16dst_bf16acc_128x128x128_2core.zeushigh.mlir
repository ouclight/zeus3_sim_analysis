// SIM_PARAMS: act:ptr:in:[1,1,"M","K"]:bf16  weight_c0:wgt_ptr:in:[1,"N_per_core","K"]:bf16  weight_c1:wgt_ptr:in:[1,"N_per_core","K"]:bf16  output:ptr:out:[1,1,"M","N"]:bf16  M:i32  K:i32  N:i32
// SIM_GOLDEN: matmul
module attributes {zeus.conversion_mode = "normal", zeus.br_spill_mode = "compiler-stack", zeus.required_num_vp = 1 : i64, zeus.siso_protocol = "zeus518"} {
  func.func @gemm_mkn_loop_2core_kernel(%arg0: memref<*xbf16>, %arg1: memref<*xi64>, %arg2: memref<*xbf16>, %arg3: i32, %arg4: i32, %arg5: i32, %arg6: i32 {zeus.program_id}) attributes {zeus.br_stack_window_available = true, zeus.num_cores = 2 : i32} {
    %c63_i32 = arith.constant 63 : i32
    %c64_i32 = arith.constant 64 : i32
    %c1 = arith.constant 1 : index
    %c128 = arith.constant 128 : index
    %c2_i32 = arith.constant 2 : i32
    %c128_i32 = arith.constant 128 : i32
    %c1_i32 = arith.constant 1 : i32
    %c127_i32 = arith.constant 127 : i32
    %c0_i32 = arith.constant 0 : i32
    %c2 = arith.constant 2 : index
    %0 = arith.divsi %arg5, %c2_i32 : i32
    %1 = arith.index_cast %arg6 : i32 to index
    %2 = zeus_high.load_weight_addr %arg1, %arg6 : memref<*xi64>, i32 -> memref<1xbf16>
    %3 = arith.addi %arg3, %c127_i32 : i32
    %4 = arith.divsi %3, %c128_i32 : i32
    %5 = arith.addi %0, %c127_i32 : i32
    %6 = arith.divsi %5, %c128_i32 : i32
    %7 = arith.addi %arg4, %c127_i32 : i32
    %8 = arith.divsi %7, %c128_i32 : i32
    %9 = arith.index_cast %arg4 : i32 to index
    %10 = arith.index_cast %arg3 : i32 to index
    %11 = arith.index_cast %0 : i32 to index
    %12 = arith.addi %arg4, %c63_i32 : i32
    %13 = arith.divui %12, %c64_i32 : i32
    %14 = arith.muli %13, %c64_i32 : i32
    scf.for %arg7 = %c0_i32 to %4 step %c1_i32  : i32 {
      %15 = arith.muli %arg7, %c128_i32 : i32
      %16 = arith.index_cast %15 : i32 to index
      %17 = arith.subi %10, %16 : index
      %18 = arith.maxsi %17, %c1 : index
      %19 = arith.minsi %18, %c128 : index
      %20 = arith.muli %16, %9 : index
      %21 = arith.minsi %19, %c128 : index
      %22 = arith.muli %16, %c2 : index
      %23 = arith.addi %22, %1 : index
      %24 = arith.muli %23, %11 : index
      scf.for %arg8 = %c0_i32 to %6 step %c1_i32  : i32 {
        %25 = arith.muli %arg8, %c128_i32 : i32
        %alloc = memref.alloc() {alignment = 16 : i64, zeus_high.in_place_iter_arg} : memref<1x1x128x128xbf16>
        %26 = zeus_high.create_fmap_desc %alloc {offset = 0, tensor_shape = [1, 1, 128, 128], tile_shape = [1, 1, 128, 128], addr = 0, memory_space = "SRAM", alignment = 16, size_bytes = 32768} : memref<1x1x128x128xbf16> -> !zeus_high.fmap_desc
        zeus_high.vp %alloc, %alloc desc(%26, %26) {op_type = "fill", modules = [{name = "mul", mode = "mul_x_c", scalar_val = 0.000000e+00 : f32}, {name = "sum1", mode = "sum_1_x_add_c", scalar_val = 0.000000e+00 : bf16}], nan_safe_fill = unit, tensor_mode = 0 : i64} : memref<1x1x128x128xbf16>, memref<1x1x128x128xbf16>
        %27 = arith.index_cast %25 : i32 to index
        %28 = arith.muli %25, %14 : i32
        %29 = arith.muli %28, %c2_i32 : i32
        %30 = zeus_high.create_weight_desc %2 {offset = 0, tensor_shape = [1, 128, %9], tile_shape = [1, 128, 128], blocked_offset = %29, memory_space = "LDG"} : memref<1xbf16> -> !zeus_high.weight_desc
        %31 = zeus_high.update_tile %26 [1, 1, %21, 128] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
        scf.for %arg9 = %c0_i32 to %8 step %c1_i32  : i32 {
          %42 = arith.muli %arg9, %c128_i32 : i32
          %43 = arith.index_cast %42 : i32 to index
          %alloc_0 = memref.alloc() {alignment = 16 : i64} : memref<1x1x128x128xbf16>
          %44 = zeus_high.create_fmap_desc %alloc_0 {offset = 0, tensor_shape = [1, 1, 128, 128], tile_shape = [1, 1, 128, 128], addr = 32768, memory_space = "SRAM", alignment = 16, size_bytes = 32768} : memref<1x1x128x128xbf16> -> !zeus_high.fmap_desc
          %45 = arith.subi %9, %43 : index
          %46 = arith.maxsi %45, %c1 : index
          %47 = arith.minsi %46, %c128 : index
          %48 = zeus_high.update_tile %44 [1, 1, %19, %47] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
          %49 = zeus_high.set_pos %48 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
          %50 = arith.addi %20, %43 : index
          %51 = zeus_high.create_fmap_desc %arg0 {offset = 0, tensor_shape = [1, 1, 128, %9], tile_shape = [1, 1, 128, 128], boundary_dims = [2, 3], dynamic_byte_offset = %50} : memref<*xbf16> -> !zeus_high.fmap_desc
          %52 = zeus_high.update_tile %51 [1, 1, %19, %47] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
          %53 = zeus_high.set_pos %52 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
          zeus_high.load %arg0, %alloc_0 desc(%53, %49) : memref<*xbf16>, memref<1x1x128x128xbf16>
          %alloc_1 = memref.alloc() {alignment = 16 : i64} : memref<1x1x128x128xbf16>
          %54 = zeus_high.create_fmap_desc %alloc_1 {offset = 0, tensor_shape = [1, 1, 128, 128], tile_shape = [1, 1, 128, 128], addr = 65536, memory_space = "SRAM", alignment = 16, size_bytes = 32768} : memref<1x1x128x128xbf16> -> !zeus_high.fmap_desc
          %55 = arith.minsi %45, %c128 : index
          %56 = zeus_high.update_tile %30 [1, 128, %55] : !zeus_high.weight_desc -> !zeus_high.weight_desc
          %57 = zeus_high.set_pos %56 [0, 0, %43] : !zeus_high.weight_desc -> !zeus_high.weight_desc
          %58 = zeus_high.update_tile %44 [1, 1, %19, %55] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
          %59 = zeus_high.set_pos %58 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
          %60 = zeus_high.update_tile %54 [1, 1, %19, 128] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
          %61 = zeus_high.set_pos %60 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
          zeus_high.pe %alloc_0, %2, %alloc_1 desc(%59, %57, %61) {mtc = 2 : i64, mtk = 1 : i64, mtw = 4 : i64, op_type = "matmul", transpose_lhs = false, transpose_rhs = false, wbs = 128 : i64} : memref<1x1x128x128xbf16>, memref<1xbf16>, memref<1x1x128x128xbf16>
          memref.dealloc %alloc_0 : memref<1x1x128x128xbf16>
          %62 = zeus_high.update_tile %54 [1, 1, %21, 128] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
          %63 = zeus_high.set_pos %62 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
          zeus_high.vp %alloc, %alloc_1, %alloc desc(%31, %63, %31) {op_type = "add", modules = [{name = "sum0", mode = "sum_0_x_add_y"}], tensor_mode = 0 : i64} : memref<1x1x128x128xbf16>, memref<1x1x128x128xbf16>, memref<1x1x128x128xbf16>
          memref.dealloc %alloc_1 : memref<1x1x128x128xbf16>
        }
        %reinterpret_cast = memref.reinterpret_cast %alloc to offset: [0], sizes: [1, 128, 1, 128], strides: [16384, 128, 128, 1] : memref<1x1x128x128xbf16> to memref<1x128x1x128xbf16>
        %32 = arith.subi %11, %27 : index
        %33 = arith.maxsi %32, %c1 : index
        %34 = arith.minsi %33, %c128 : index
        %35 = zeus_high.create_fmap_desc %reinterpret_cast {offset = 0, tensor_shape = [1, 128, 1, 128], tile_shape = [1, 128, 1, 128], addr = 0, memory_space = "SRAM", alignment = 16, size_bytes = 32768} : memref<1x128x1x128xbf16> -> !zeus_high.fmap_desc
        %36 = zeus_high.update_tile %35 [1, %19, 1, %34] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
        %37 = zeus_high.set_pos %36 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
        %38 = arith.addi %24, %27 : index
        %39 = zeus_high.create_fmap_desc %arg2 {offset = 0, tensor_shape = [1, 128, 2, %11], tile_shape = [1, 128, 1, 128], boundary_dims = [1, 3], dynamic_byte_offset = %38} : memref<*xbf16> -> !zeus_high.fmap_desc
        %40 = zeus_high.update_tile %39 [1, %19, 1, %34] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
        %41 = zeus_high.set_pos %40 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
        zeus_high.store %reinterpret_cast, %arg2 desc(%37, %41) : memref<1x128x1x128xbf16>, memref<*xbf16>
        memref.dealloc %alloc : memref<1x1x128x128xbf16>
      }
    }
    return
  }
}

