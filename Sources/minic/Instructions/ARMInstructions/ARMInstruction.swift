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
    /// ADD{S}{cond} {Rd}, Rn, Operand2
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/add)
    case add(target: ARMRegister, firstOp: ARMRegister, secondOp: ARMFlexibleOperand)
    
    /// Subtract without Carry.
    ///
    /// # Syntax
    /// SUB{S}{cond} {Rd}, Rn, Operand2
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/sub)
    case subtract(target: ARMRegister, firstOp: ARMRegister, secondOp: ARMFlexibleOperand)
    
    /// Multiply with signed or unsigned 32-bit operands,
    /// giving the least significant 32 bits of the result.
    ///
    /// # Syntax
    /// MUL{S}{cond} {Rd}, Rn, Rm
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/mul)
    case multiply(target: ARMRegister, firstOp: ARMRegister, secondOp: ARMRegister)
    
    // MARK: - Booleanp
    
    /// Logical AND.
    ///
    /// # Syntax
    /// AND{S}{cond} Rd, Rn, Operand2
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/and)
    case and(target: ARMRegister, firstOp: ARMRegister, secondOp: ARMFlexibleOperand)
    
    /// Logical OR.
    ///
    /// # Syntax
    /// ORR{S}{cond} Rd, Rn, Operand2
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/orr)
    case or(target: ARMRegister, firstOp: ARMRegister, secondOp: ARMFlexibleOperand)
    
    /// Logical Exclusive OR.
    ///
    /// # Syntax
    /// EOR{S}{cond} Rd, Rn, Operand2
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
    /// CMP{cond} Rn, Operand2
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/cmp-and-cmn)
    case compare(firstOp: ARMRegister, secondOp: ARMFlexibleOperand)
    
    /// Branch.
    ///
    /// Causes a branch to `label`.
    ///
    /// # Syntax
    /// B{cond}{.W} label
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/b)
    case branch(condCode: ARMConditionCode?, label: ARMLabel)
    
    // MARK: - Moves
    
    /// Move.
    ///
    /// Copies the value of `Operand2` into `Rd`.
    ///
    /// # Syntax
    /// MOV{S}{cond} Rd, Operand2
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/mov)
    case move(condCode: ARMConditionCode?, target: ARMRegister, source: ARMFlexibleOperand)
    
    /// Move top.
    ///
    /// Writes imm16 to Rd[31:16], without affecting Rd[15:0].
    ///
    /// You can generate any 32-bit immediate with a MOV, MOVT instruction pair.
    ///
    /// # Syntax
    /// MOVT{cond} Rd, #imm16
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/movt)
    case moveTop(condCode: ARMConditionCode?, target: ARMRegister, source: Int16)
    
    // MARK: - Loads and Stores
    
    
    
}
