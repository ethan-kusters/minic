//
//  Instruction.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/23/20.
//

import Foundation

enum Instruction: Equatable {
    
    // MARK: - Arithmetic
    
    /// The `add` instruction returns the sum of its two operands.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#add-instruction)
    case add(type: InstructionType, firstOp: InstructionValue, secondOp: InstructionValue)
    
    /// The ‘sub’ instruction returns the difference of its two operands.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#sub-instruction)
    case subtract(type: InstructionType, firstOp: InstructionValue, secondOp: InstructionValue)
    
    /// The ‘mul’ instruction returns the product of its two operands.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#mul-instruction)
    case multiply(type: InstructionType, firstOp: InstructionValue, secondOp: InstructionValue)
    
    /// The ‘sdiv’ instruction returns the quotient of its two operands.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#sdiv-instruction)
    case signedDivide(type: InstructionType, firstOp: InstructionValue, secondOp: InstructionValue)
    
    // MARK: - Boolean Instructions
    
    /// The ‘and’ instruction returns the bitwise logical and of its two operands.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#and-instruction)
    case and(type: InstructionType, firstOp: InstructionValue, secondOp: InstructionValue)
    
    /// The ‘or’ instruction returns the bitwise logical inclusive or of its two operands.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#or-instruction)
    case or(type: InstructionType, firstOp: InstructionValue, secondOp: InstructionValue)
    
    /// The ‘xor’ instruction returns the bitwise logical exclusive or of its two operands.
    ///
    /// The xor is used to implement the “one’s complement” operation, which is the “~” operator in C.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#xor-instruction)
    case xor(type: InstructionType, firstOp: InstructionValue, secondOp: InstructionValue)
    
    // MARK: - Comparison
    
    /// The ‘icmp’ instruction returns a boolean value based on comparison of its two integer or pointer operands.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#icmp-instruction)
    case comparison(condCode: InstructionConditionCode,
        type: InstructionType, firstOp: InstructionValue, secondOp: InstructionValue)
    
    // MARK: - Branch
    
    /// The ‘br’ instruction is used to cause control flow to transfer to a different basic block in the current function.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#br-instruction)
    indirect case conditionalBranch(conditional: Instruction, ifTrue: InstructionPointer, ifFalse: InstructionPointer)
    
    /// The ‘br’ instruction is used to cause control flow to transfer to a different basic block in the current function.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#br-instruction)
    case unconditionalBranch(destination: InstructionPointer)
    
    // MARK: - Load & Store
    
    /// The ‘load’ instruction is used to read from memory.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#load-instruction)
    case load(valueType: InstructionType, pointerType: InstructionPointer, pointer: InstructionPointer)
    
    /// The ‘store’ instruction is used to write to memory.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#store-instruction)
    case store(valueType: InstructionType, value: InstructionValue, pointerType: InstructionType, pointer: InstructionPointer)
    
    // MARK: - Invocation
    
    /// The ‘call’ instruction represents a simple function call.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#call-instruction)
    case call(returnType: InstructionType, functionPointer: InstructionPointer, arguments: [InstructionArgument])
    
    /// The ‘ret’ instruction is used to return control flow (and optionally a value) from a function back to the caller.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#ret-instruction)
    case returnValue(type: InstructionType, value: InstructionValue)
    
    /// The ‘ret’ instruction is used to return control flow (and optionally a value) from a function back to the caller.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#ret-instruction)
    case returnVoid
    
    // MARK: - Allocation
    
    /// The ‘alloca’ instruction allocates memory on the stack frame of the currently executing function,
    /// to be automatically released when this function returns to its caller.
    ///
    /// The object is always allocated in the address space for allocas indicated in the datalayout.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#alloca-instruction)
    case allocate(type: InstructionType)
    
    // MARK: - Conversino
    
    /// The ‘bitcast’ instruction converts value to type ty2 without changing any bits.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#bitcast-to-instruction)
    case bitcast(currentType: InstructionType, value: InstructionValue, destinationType: InstructionType)
    
    /// The ‘trunc’ instruction truncates its operand to the type ty2.
    ///
    /// The ‘trunc’ instruction truncates the high order bits
    /// in value and converts the remaining bits to ty2.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#trunc-to-instruction)
    case truncate(currentType: InstructionType, value: InstructionValue, destinationType: InstructionType)
    
    /// The ‘zext’ instruction zero extends its operand to type ty2.
    ///
    /// The zext fills the high order bits of the value with zero bits
    /// until it reaches the size of the destination type, ty2.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#zext-to-instruction)
    case zeroExtend(currentType: InstructionType, value: InstructionValue, destinationType: InstructionType)
}
