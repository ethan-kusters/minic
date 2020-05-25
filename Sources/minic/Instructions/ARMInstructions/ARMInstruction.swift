//
//  ARMInstruction.swift
//  minic
//
//  Created by Ethan Kusters on 5/18/20.
//

import Foundation

/// An abstract representation of a subset of the ARM instruction set.
///
/// # Reference
/// [ARM Documentaiton](https://static.docs.arm.com/ddi0406/c/DDI0406C_C_arm_architecture_reference_manual.pdf)
enum ARMInstruction: InstructionProtocol {
    
    // MARK: - Arithmetic
    
    /// Add without Carry.
    ///
    /// # Syntax
    /// `ADD{S}{cond} {Rd}, Rn, Operand2`
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/add)
    case add(target: ARMRegister, firstOp: ARMRegister, secondOp: ARMFlexibleOperand)
    
    /// Subtract without Carry.
    ///
    /// # Syntax
    /// `SUB{S}{cond} {Rd}, Rn, Operand2`
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/sub)
    case subtract(target: ARMRegister, firstOp: ARMRegister, secondOp: ARMFlexibleOperand)
    
    /// Multiply with signed or unsigned 32-bit operands,
    /// giving the least significant 32 bits of the result.
    ///
    /// # Syntax
    /// `MUL{S}{cond} {Rd}, Rn, Rm`
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/mul)
    case multiply(target: ARMRegister, firstOp: ARMRegister, secondOp: ARMRegister)
    
    /// Signed divide.
    ///
    /// # Syntax
    /// `SDIV{cond} {Rd}, Rn, Rm`
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/sdiv)
    case signedDivide(target: ARMRegister, firstOp: ARMRegister, secondOp: ARMRegister)
    
    // MARK: - Booleanp
    
    /// Logical AND.
    ///
    /// # Syntax
    /// `AND{S}{cond} Rd, Rn, Operand2`
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/and)
    case and(target: ARMRegister, firstOp: ARMRegister, secondOp: ARMFlexibleOperand)
    
    /// Logical OR.
    ///
    /// # Syntax
    /// `ORR{S}{cond} Rd, Rn, Operand2`
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/orr)
    case or(target: ARMRegister, firstOp: ARMRegister, secondOp: ARMFlexibleOperand)
    
    /// Logical Exclusive OR.
    ///
    /// # Syntax
    /// `EOR{S}{cond} Rd, Rn, Operand2`
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/eor)
    case exclusiveOr(target: ARMRegister, firstOp: ARMRegister, secondOp: ARMFlexibleOperand)
    
    // MARK: - Comparison and Branching
    
    /// Compare.
    ///
    /// Compares the value in a register with Operand2.
    /// Updates the condition flags on the result, but does not place the result in any register.
    ///
    /// # Syntax
    /// `CMP{cond} Rn, Operand2`
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/cmp-and-cmn)
    case compare(firstOp: ARMRegister, secondOp: ARMFlexibleOperand)
    
    /// Branch.
    ///
    /// Causes a branch to `label`.
    ///
    /// # Syntax
    /// `B{cond}{.W} label`
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/b)
    case branch(condCode: ARMConditionCode?, label: ARMSymbol)
    
    // MARK: - Moves
    
    /// Move.
    ///
    /// Copies the value of `Operand2` into `Rd`.
    ///
    /// # Syntax
    /// `MOV{S}{cond} Rd, Operand2`
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/mov)
    case move(condCode: ARMConditionCode?, target: ARMRegister, source: ARMFlexibleOperand)
    
    /// Move top.
    ///
    /// Writes imm16 to Rd[31:16], without affecting Rd[15:0].
    ///
    /// You can generate any 32-bit immediate with a MOVW, MOVT instruction pair.
    ///
    /// # Syntax
    /// `MOVT{cond} Rd, #imm16`
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/movt)
    case moveTop(condCode: ARMConditionCode?, target: ARMRegister, source: ARMExpression)
    
    /// Move bottom.
    ///
    /// Writes imm16 to Rd[15:0], without affecting Rd[31:16].
    ///
    /// You can generate any 32-bit immediate with a MOVW, MOVT instruction pair.
    ///
    /// # Syntax
    /// `MOVW{cond} Rd, #imm16`
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/movt)
    case moveBottom(condCode: ARMConditionCode?, target: ARMRegister, source: ARMExpression)
    
    // MARK: - Loads and Stores
    
    /// Load with register offset.
    ///
    /// # Syntax
    /// `LDR{type}{cond} Rt, [Rn, ±Rm {, shift}] ; register offset`
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/ldr-register-offset)
    case load(target: ARMRegister, sourceAddress: ARMRegister)
    
    /// Store with register offset.
    ///
    /// # Syntax
    /// `STR{type}{cond} Rt, [Rn, ±Rm {, shift}] ; register offset`
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/str-register-offset)
    case store(source: ARMRegister, targetAddress: ARMRegister)
    
    // MARK: - Invocation
    
    /// Branch with Link.
    ///
    /// # Syntax
    /// `BL{cond}{.W} label`
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/bl)
    case branchWithLink(label: ARMSymbol)
    
    /// Push registers onto a full descending stack.
    ///
    /// # Syntax
    /// `PUSH{cond} reglist`
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/push)
    case push(registers: [ARMRegister])
    
    /// Pop registers off a full descending stack.
    ///
    /// # Syntax
    /// `POP{cond} reglist`
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/pop)
    case pop(registers: [ARMRegister])
    
    /// Declares a named common area in the bss section.
    ///
    /// # Syntax
    /// `.comm symbol, length`
    ///
    /// # Reference
    ///[GNU Documentation](http://web.mit.edu/gnu/doc/html/as_7.html#SEC74)
    case declareGlobal(label: ARMSymbol)
    
    /// MARK: - Assembler Directives
    
    /// Aligns the current location in the file to a specified boundary.
    ///
    /// # Syntax
    /// `.align exponent [, fill_value]`
    ///
    /// # Note
    /// Specifies the alignment boundary as an exponent.
    /// The actual alignment boundary is 2^{exponent}.
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100067/0610/armclang-integrated-assembler-directives/alignment-directives)
    case alignmentDirective(exponent: Int)
    
    /// Instructs the assembler to change the ELF section that code and data
    /// is being emitted into.
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/dui0774/i/armclang-integrated-assembler-directives/section-directives)
    case sectionDirective(section: ARMExecutableSection)
    
    /// Tells the assembler how much space the data that a symbol points to is using.
    ///
    /// # Syntax
    /// `.size symbol, .-symbol`
    ///
    /// # Reference
    /// [GNU Documentation](http://web.mit.edu/gnu/doc/html/as_7.html#SEC117)
    ///
    /// [ARM Blog](https://community.arm.com/developer/ip-products/processors/b/processors-ip-blog/posts/useful-assembler-directives-and-macros-for-the-gnu-assembler)
    case sizeDirective(symbol: ARMSymbol)
    
    /// Allocates one or more bytes of memory in the current section,
    /// and defines the initial contents of the memory from a string literal.
    ///
    /// Appends a null byte to the end of the string.
    ///
    /// # Syntax
    /// `.asciz "string"`
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100067/0611/armclang-integrated-assembler/string-definition-directives)
    case stringDefinitionDirective(string: String)
    
    /// Makes the symbol visible to ld.
    ///
    /// # Syntax
    /// `.global symbol`
    ///
    /// # Reference
    /// [GNU Documentation](http://web.mit.edu/gnu/doc/html/as_7.html#SEC89)
    case globalSymbolDirective(symbol: ARMSymbol)
    
    /// Changes the architecture that the assembler is generating instructions for.
    ///
    /// # Syntax
    /// `.arch arch_name`
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/dui0774/i/armclang-integrated-assembler-directives/aarch32-target-selection-directives)
    case architectureDirective(architecture: ARMArchitecture)
    
    /// Symbolic representation of an address.
    ///
    /// Use labels to mark specific addresses that
    /// you want to refer to from other parts of the code.
    ///
    /// # Syntax
    /// Written as a symbol beginning in the first column.
    /// `symbol`
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100068/0614/migrating-from-armasm-to-the-armclang-integrated-assembler/labels)
    case label(symbol: ARMSymbol)
}
