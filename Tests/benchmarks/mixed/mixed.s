	.arch armv7-a
	.comm globalfoo, 4, 4
	.text
	.align 2
	.global tailrecursive
tailrecursive:
_L1_FunctionEntry:
	PUSH {fp, lr}
	ADD fp, sp, #4
	MOV %_reg1, #0
	CMP %num, #0
	MOVLE %_reg1, #1
	CMP %_reg1, #1
	BEQ _L3_ThenEntry
	B _L2_CondExit
_L3_ThenEntry:
	B _L4_FunctionExit
_L2_CondExit:
	SUB %_reg2, %num, #1
	MOV r0, %_reg2
	BL tailrecursive
	B _L4_FunctionExit
_L4_FunctionExit:
	POP {fp, pc}
	POP {fp, pc}
	.size tailrecursive, .-tailrecursive
	.align 2
	.global add
add:
_L5_FunctionEntry:
	PUSH {fp, lr}
	ADD fp, sp, #4
	ADD %_reg3, %x, %y
	B _L6_FunctionExit
_L6_FunctionExit:
	MOV r0, %_reg3
	POP {fp, pc}
	POP {fp, pc}
	.size add, .-add
	.align 2
	.global domath
domath:
_L7_FunctionEntry:
	PUSH {fp, lr}
	ADD fp, sp, #4
	MOV r0, #24
	BL malloc
	MOV %_reg4, r0
	MOV r0, #8
	BL malloc
	MOV %_reg6, r0
	ADD %_reg8, %_reg5, #8
	STR %_reg7, [%_reg8]
	MOV r0, #24
	BL malloc
	MOV %_reg9, r0
	MOV r0, #8
	BL malloc
	MOV %_reg11, r0
	ADD %_reg13, %_reg10, #8
	STR %_reg12, [%_reg13]
	ADD %_reg14, %_reg5, #0
	STR %num, [%_reg14]
	ADD %_reg15, %_reg10, #0
	MOV %_reg84, #3
	STR %_reg84, [%_reg15]
	ADD %_reg16, %_reg5, #0
	LDR %_reg17, [%_reg16]
	ADD %_reg18, %_reg5, #8
	LDR %_reg19, [%_reg18]
	ADD %_reg20, %_reg19, #0
	STR %_reg17, [%_reg20]
	ADD %_reg21, %_reg10, #0
	LDR %_reg22, [%_reg21]
	ADD %_reg23, %_reg10, #8
	LDR %_reg24, [%_reg23]
	ADD %_reg25, %_reg24, #0
	STR %_reg22, [%_reg25]
	MOV %_reg26, #0
	CMP %num, #0
	MOVGT %_reg26, #1
	CMP %_reg26, #1
	BEQ _L8_WhileBodyEntrance
	B _L9_WhileExit
_L8_WhileBodyEntrance:
	MOV %_num_54, %_phi_85
	ADD %_reg28, %_reg4, #0
	LDR %_reg29, [%_reg28]
	ADD %_reg31, %_reg9, #0
	LDR %_reg32, [%_reg31]
	MUL %_reg33, %_reg29, %_reg32
	ADD %_reg34, %_reg4, #8
	LDR %_reg35, [%_reg34]
	ADD %_reg36, %_reg35, #0
	LDR %_reg37, [%_reg36]
	MUL %_reg38, %_reg33, %_reg37
	ADD %_reg39, %_reg9, #0
	LDR %_reg40, [%_reg39]
	MOV r0, %_reg38
	MOV r1, %_reg40
	BL __aeabi_idiv
	MOV %_reg41, r0
	ADD %_reg42, %_reg9, #8
	LDR %_reg43, [%_reg42]
	ADD %_reg44, %_reg43, #0
	LDR %_reg45, [%_reg44]
	ADD %_reg46, %_reg4, #0
	LDR %_reg47, [%_reg46]
	MOV r0, %_reg45
	MOV r1, %_reg47
	BL add
	MOV %_reg48, r0
	ADD %_reg49, %_reg9, #0
	LDR %_reg50, [%_reg49]
	ADD %_reg51, %_reg4, #0
	LDR %_reg52, [%_reg51]
	SUB %_reg53, %_reg50, %_reg52
	SUB %_reg55, %_num_54, #1
	MOV %_reg56, #0
	CMP %_reg55, #0
	MOVGT %_reg56, #1
	MOV %_phi_85, %_reg55
	CMP %_reg56, #1
	BEQ _L8_WhileBodyEntrance
	B _L9_WhileExit
_L9_WhileExit:
	MOV r0, %_reg58
	BL free
	MOV r0, %_reg60
	BL free
	B _L10_FunctionExit
_L10_FunctionExit:
	POP {fp, pc}
	POP {fp, pc}
	.size domath, .-domath
	.align 2
	.global objinstantiation
objinstantiation:
_L11_FunctionEntry:
	PUSH {fp, lr}
	ADD fp, sp, #4
	MOV %_reg61, #0
	CMP %num, #0
	MOVGT %_reg61, #1
	CMP %_reg61, #1
	BEQ _L12_WhileBodyEntrance
	B _L13_WhileExit
_L12_WhileBodyEntrance:
	MOV %_num_65, %_phi_86
	MOV r0, #24
	BL malloc
	MOV %_reg62, r0
	MOV r0, %_reg64
	BL free
	SUB %_reg66, %_num_65, #1
	MOV %_reg67, #0
	CMP %_reg66, #0
	MOVGT %_reg67, #1
	MOV %_phi_86, %_reg66
	CMP %_reg67, #1
	BEQ _L12_WhileBodyEntrance
	B _L13_WhileExit
_L13_WhileExit:
	B _L14_FunctionExit
_L14_FunctionExit:
	POP {fp, pc}
	POP {fp, pc}
	.size objinstantiation, .-objinstantiation
	.align 2
	.global ackermann
ackermann:
_L15_FunctionEntry:
	PUSH {fp, lr}
	ADD fp, sp, #4
	MOV %_reg68, #0
	CMP %m, #0
	MOVEQ %_reg68, #1
	CMP %_reg68, #1
	BEQ _L17_ThenEntry
	B _L16_CondExit
_L17_ThenEntry:
	ADD %_reg69, %n, #1
	B _L18_FunctionExit
_L16_CondExit:
	MOV %_reg70, #0
	CMP %n, #0
	MOVEQ %_reg70, #1
	CMP %_reg70, #1
	BEQ _L20_ThenEntry
	B _L21_ElseEntry
_L18_FunctionExit:
	MOV %__retVal_77, %_phi_87
	MOV r0, %__retVal_77
	POP {fp, pc}
_L20_ThenEntry:
	SUB %_reg71, %m, #1
	MOV r0, %_reg71
	MOV r1, #1
	BL ackermann
	MOV %_reg72, r0
	MOV %_phi_87, %_reg72
	B _L18_FunctionExit
_L21_ElseEntry:
	SUB %_reg73, %m, #1
	SUB %_reg74, %n, #1
	MOV r0, %m
	MOV r1, %_reg74
	BL ackermann
	MOV %_reg75, r0
	MOV r0, %_reg73
	MOV r1, %_reg75
	BL ackermann
	MOV %_reg76, r0
	MOV %_phi_87, %_reg76
	B _L18_FunctionExit
	POP {fp, pc}
	.size ackermann, .-ackermann
	.align 2
	.global main
main:
_L22_FunctionEntry:
	PUSH {fp, lr}
	ADD fp, sp, #4
	MOVW r1, #:lower16:read_scratch
	MOVT r1, #:upper16:read_scratch
	MOVW r0, #:lower16:READ_FMT
	MOVT r0, #:upper16:READ_FMT
	BL scanf
	MOVW %_reg78, #:lower16:read_scratch
	MOVT %_reg78, #:upper16:read_scratch
	LDR %_reg78, [%_reg78]
	MOVW r1, #:lower16:read_scratch
	MOVT r1, #:upper16:read_scratch
	MOVW r0, #:lower16:READ_FMT
	MOVT r0, #:upper16:READ_FMT
	BL scanf
	MOVW %_reg79, #:lower16:read_scratch
	MOVT %_reg79, #:upper16:read_scratch
	LDR %_reg79, [%_reg79]
	MOVW r1, #:lower16:read_scratch
	MOVT r1, #:upper16:read_scratch
	MOVW r0, #:lower16:READ_FMT
	MOVT r0, #:upper16:READ_FMT
	BL scanf
	MOVW %_reg80, #:lower16:read_scratch
	MOVT %_reg80, #:upper16:read_scratch
	LDR %_reg80, [%_reg80]
	MOVW r1, #:lower16:read_scratch
	MOVT r1, #:upper16:read_scratch
	MOVW r0, #:lower16:READ_FMT
	MOVT r0, #:upper16:READ_FMT
	BL scanf
	MOVW %_reg81, #:lower16:read_scratch
	MOVT %_reg81, #:upper16:read_scratch
	LDR %_reg81, [%_reg81]
	MOVW r1, #:lower16:read_scratch
	MOVT r1, #:upper16:read_scratch
	MOVW r0, #:lower16:READ_FMT
	MOVT r0, #:upper16:READ_FMT
	BL scanf
	MOVW %_reg82, #:lower16:read_scratch
	MOVT %_reg82, #:upper16:read_scratch
	LDR %_reg82, [%_reg82]
	MOV r0, %_reg78
	BL tailrecursive
	MOV r1, %_reg78
	MOVW r0, #:lower16:PRINTLN_FMT
	MOVT r0, #:upper16:PRINTLN_FMT
	BL printf
	MOV r0, %_reg79
	BL domath
	MOV r1, %_reg79
	MOVW r0, #:lower16:PRINTLN_FMT
	MOVT r0, #:upper16:PRINTLN_FMT
	BL printf
	MOV r0, %_reg80
	BL objinstantiation
	MOV r1, %_reg80
	MOVW r0, #:lower16:PRINTLN_FMT
	MOVT r0, #:upper16:PRINTLN_FMT
	BL printf
	MOV r0, %_reg81
	MOV r1, %_reg82
	BL ackermann
	MOV %_reg83, r0
	MOV r1, %_reg83
	MOVW r0, #:lower16:PRINTLN_FMT
	MOVT r0, #:upper16:PRINTLN_FMT
	BL printf
	B _L23_FunctionExit
_L23_FunctionExit:
	MOV r0, #0
	POP {fp, pc}
	POP {fp, pc}
	.size main, .-main
	.rodata
	.align 2
PRINTLN_FMT:
	.asciz "%ld\n"
	.align 2
PRINT_FMT:
	.asciz "%ld "
	.align 2
READ_FMT:
	.asciz "%ld"
	.comm read_scratch, 4, 4
	.global __aeabi_idiv