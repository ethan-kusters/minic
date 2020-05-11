//
//  Instruction.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/23/20.
//

import Foundation

enum LLVMInstruction: Equatable {
    
    // MARK: - Arithmetic
    
    /// The `add` instruction returns the sum of its two operands.
    ///
    /// # Example
    /// result = add i32 4, %var
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#add-instruction)
    case add(firstOp: LLVMValue, secondOp: LLVMValue, destination: LLVMVirtualRegister)
    
    /// The ‘sub’ instruction returns the difference of its two operands.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#sub-instruction)
    case subtract(firstOp: LLVMValue, secondOp: LLVMValue, destination: LLVMVirtualRegister)
    
    /// The ‘mul’ instruction returns the product of its two operands.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#mul-instruction)
    case multiply(firstOp: LLVMValue, secondOp: LLVMValue, destination: LLVMVirtualRegister)
    
    /// The ‘sdiv’ instruction returns the quotient of its two operands.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#sdiv-instruction)
    case signedDivide(firstOp: LLVMValue, secondOp: LLVMValue, destination: LLVMVirtualRegister)
    
    // MARK: - Boolean Instructions
    
    /// The ‘and’ instruction returns the bitwise logical and of its two operands.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#and-instruction)
    case and(firstOp: LLVMValue, secondOp: LLVMValue, destination: LLVMVirtualRegister)
    
    /// The ‘or’ instruction returns the bitwise logical inclusive or of its two operands.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#or-instruction)
    case or(firstOp: LLVMValue, secondOp: LLVMValue, destination: LLVMVirtualRegister)
    
    /// The ‘xor’ instruction returns the bitwise logical exclusive or of its two operands.
    ///
    /// The xor is used to implement the “one’s complement” operation, which is the “~” operator in C.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#xor-instruction)
    case exclusiveOr(firstOp: LLVMValue, secondOp: LLVMValue, destination: LLVMVirtualRegister)
    
    // MARK: - Comparison
    
    /// The ‘icmp’ instruction returns a boolean value based on comparison of its two integer or pointer operands.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#icmp-instruction)
    case comparison(condCode: LLVMConditionCode, firstOp: LLVMValue, secondOp: LLVMValue, destination: LLVMVirtualRegister)
    
    // MARK: - Branch
    
    /// The ‘br’ instruction is used to cause control flow to transfer to a different basic block in the current function.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#br-instruction)
    case conditionalBranch(conditional: LLVMValue, ifTrue: Block, ifFalse: Block)
    
    /// The ‘br’ instruction is used to cause control flow to transfer to a different basic block in the current function.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#br-instruction)
    case unconditionalBranch(_ destination: Block)
    
    // MARK: - Load & Store
    
    /// The ‘load’ instruction is used to read from memory.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#load-instruction)
    case load(source: LLVMIdentifier, destination: LLVMVirtualRegister)
    
    /// The ‘store’ instruction is used to write to memory.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#store-instruction)
    case store(source: LLVMValue, destination: LLVMIdentifier)
    
    /// The ‘getelementptr’ instruction is used to get the address of a subelement of an aggregate data structure.
    ///
    /// It performs address calculation only and does not access memory.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#getelementptr-instruction)
    case getElementPointer(structureType: LLVMIdentifier, structurePointer: LLVMIdentifier,
        elementIndex: Int, destination: LLVMVirtualRegister)
    
    // MARK: - Invocation
    
    /// The ‘call’ instruction represents a simple function call.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#call-instruction)
    case call(functionIdentifier: LLVMIdentifier, arguments: [LLVMValue], destination: LLVMVirtualRegister?)
    
    /// The ‘ret’ instruction is used to return control flow (and optionally a value) from a function back to the caller.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#ret-instruction)
    case returnValue(_ value: LLVMValue)
    
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
    case allocate(destination: LLVMVirtualRegister)
    
    /// Global variables define regions of memory allocated at compilation time instead of run-time.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#global-variables)
    case declareGlobal(source: LLVMValue, destination: LLVMIdentifier)
    
    
    /// The structure type is used to represent a collection of data members together in memory.
    ///
    /// The elements of a structure may be any type that has a size.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#structure-type)
    case declareStructureType(types: [LLVMType], destination: LLVMIdentifier)
    
    // MARK: - Conversion
    
    /// The ‘bitcast’ instruction converts value to type ty2 without changing any bits.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#bitcast-to-instruction)
    case bitcast(source: LLVMValue, destination: LLVMVirtualRegister)
    
    /// The ‘trunc’ instruction truncates its operand to the type ty2.
    ///
    /// The ‘trunc’ instruction truncates the high order bits
    /// in value and converts the remaining bits to ty2.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#trunc-to-instruction)
    case truncate(source: LLVMValue, destination: LLVMVirtualRegister)
    
    /// The ‘zext’ instruction zero extends its operand to type ty2.
    ///
    /// The zext fills the high order bits of the value with zero bits
    /// until it reaches the size of the destination type, ty2.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#zext-to-instruction)
    case zeroExtend(source: LLVMValue, destination: LLVMVirtualRegister)
    
    // MARK: - Single Static Assignment
    
    /// The ‘phi’ instruction is used to implement the φ node in the SSA graph representing the function.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#phi-instruction)
    case phi(valuePairs: [ValuePair], destination: LLVMVirtualRegister)
    
    
    struct ValuePair: Equatable {
        let value: LLVMValue
        let label: LLVMIdentifier
    }
}
