; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32I %s

declare i32 @external_function(i32)

define i32 @test_call_external(i32 %a) nounwind {
; RV32I-LABEL: test_call_external:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    call external_function
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %1 = call i32 @external_function(i32 %a)
  ret i32 %1
}

define i32 @defined_function(i32 %a) nounwind {
; RV32I-LABEL: defined_function:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a0, a0, 1
; RV32I-NEXT:    ret
  %1 = add i32 %a, 1
  ret i32 %1
}

define i32 @test_call_defined(i32 %a) nounwind {
; RV32I-LABEL: test_call_defined:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    call defined_function
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %1 = call i32 @defined_function(i32 %a)
  ret i32 %1
}

define i32 @test_call_indirect(i32 (i32)* %a, i32 %b) nounwind {
; RV32I-LABEL: test_call_indirect:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    mv a2, a0
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:    jalr a2
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %1 = call i32 %a(i32 %b)
  ret i32 %1
}

; Ensure that calls to fastcc functions aren't rejected. Such calls may be
; introduced when compiling with optimisation.

define fastcc i32 @fastcc_function(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: fastcc_function:
; RV32I:       # %bb.0:
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
 %1 = add i32 %a, %b
 ret i32 %1
}

define i32 @test_call_fastcc(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: test_call_fastcc:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    sw s0, 8(sp)
; RV32I-NEXT:    mv s0, a0
; RV32I-NEXT:    call fastcc_function
; RV32I-NEXT:    mv a0, s0
; RV32I-NEXT:    lw s0, 8(sp)
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %1 = call fastcc i32 @fastcc_function(i32 %a, i32 %b)
  ret i32 %a
}

declare i32 @external_many_args(i32, i32, i32, i32, i32, i32, i32, i32, i32, i32) nounwind

define i32 @test_call_external_many_args(i32 %a) nounwind {
; RV32I-LABEL: test_call_external_many_args:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    sw s0, 8(sp)
; RV32I-NEXT:    mv s0, a0
; RV32I-NEXT:    sw a0, 4(sp)
; RV32I-NEXT:    sw a0, 0(sp)
; RV32I-NEXT:    mv a1, a0
; RV32I-NEXT:    mv a2, a0
; RV32I-NEXT:    mv a3, a0
; RV32I-NEXT:    mv a4, a0
; RV32I-NEXT:    mv a5, a0
; RV32I-NEXT:    mv a6, a0
; RV32I-NEXT:    mv a7, a0
; RV32I-NEXT:    call external_many_args
; RV32I-NEXT:    mv a0, s0
; RV32I-NEXT:    lw s0, 8(sp)
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %1 = call i32 @external_many_args(i32 %a, i32 %a, i32 %a, i32 %a, i32 %a,
                                    i32 %a, i32 %a, i32 %a, i32 %a, i32 %a)
  ret i32 %a
}

define i32 @defined_many_args(i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 %j) nounwind {
; RV32I-LABEL: defined_many_args:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lw a0, 4(sp)
; RV32I-NEXT:    addi a0, a0, 1
; RV32I-NEXT:    ret
  %added = add i32 %j, 1
  ret i32 %added
}

define i32 @test_call_defined_many_args(i32 %a) nounwind {
; RV32I-LABEL: test_call_defined_many_args:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    sw a0, 4(sp)
; RV32I-NEXT:    sw a0, 0(sp)
; RV32I-NEXT:    mv a1, a0
; RV32I-NEXT:    mv a2, a0
; RV32I-NEXT:    mv a3, a0
; RV32I-NEXT:    mv a4, a0
; RV32I-NEXT:    mv a5, a0
; RV32I-NEXT:    mv a6, a0
; RV32I-NEXT:    mv a7, a0
; RV32I-NEXT:    call defined_many_args
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %1 = call i32 @defined_many_args(i32 %a, i32 %a, i32 %a, i32 %a, i32 %a,
                                   i32 %a, i32 %a, i32 %a, i32 %a, i32 %a)
  ret i32 %1
}
