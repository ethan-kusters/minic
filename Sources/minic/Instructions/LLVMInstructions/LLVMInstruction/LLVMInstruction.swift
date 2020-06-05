//
//  Instruction.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/23/20.
//

import Foundation

/// An abstract representation of a subset of the LLVM instruction set.
///
/// # Reference
/// [LLVM Documentaiton](https://releases.llvm.org/9.0.0/docs/LangRef.html#instruction-reference)
enum LLVMInstruction: InstructionProtocol {
    
    // MARK: - Arithmetic
    
    /// The `add` instruction returns the sum of its two operands.
    ///
    /// # Example
    /// result = add i32 4, %var
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#add-instruction)
    case add(target: LLVMVirtualRegister, firstOp: LLVMValue, secondOp: LLVMValue, block: LLVMInstructionBlock)
    
    /// The ‘sub’ instruction returns the difference of its two operands.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#sub-instruction)
    case subtract(target: LLVMVirtualRegister, firstOp: LLVMValue, secondOp: LLVMValue, block: LLVMInstructionBlock)
    
    /// The ‘mul’ instruction returns the product of its two operands.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#mul-instruction)
    case multiply(target: LLVMVirtualRegister, firstOp: LLVMValue, secondOp: LLVMValue, block: LLVMInstructionBlock)
    
    /// The ‘sdiv’ instruction returns the quotient of its two operands.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#sdiv-instruction)
    case signedDivide(target: LLVMVirtualRegister, firstOp: LLVMValue, secondOp: LLVMValue, block: LLVMInstructionBlock)
    
    // MARK: - Boolean Instructions
    
    /// The ‘and’ instruction returns the bitwise logical and of its two operands.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#and-instruction)
    case and(target: LLVMVirtualRegister, firstOp: LLVMValue, secondOp: LLVMValue, block: LLVMInstructionBlock)
    
    /// The ‘or’ instruction returns the bitwise logical inclusive or of its two operands.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#or-instruction)
    case or(target: LLVMVirtualRegister, firstOp: LLVMValue, secondOp: LLVMValue, block: LLVMInstructionBlock)
    
    /// The ‘xor’ instruction returns the bitwise logical exclusive or of its two operands.
    ///
    /// The xor is used to implement the “one’s complement” operation, which is the “~” operator in C.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#xor-instruction)
    case exclusiveOr(target: LLVMVirtualRegister, firstOp: LLVMValue, secondOp: LLVMValue, block: LLVMInstructionBlock)
    
    // MARK: - Comparison
    
    /// The ‘icmp’ instruction returns a boolean value based on comparison of its two integer or pointer operands.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#icmp-instruction)
    case comparison(target: LLVMVirtualRegister, condCode: LLVMConditionCode, firstOp: LLVMValue, secondOp: LLVMValue, block: LLVMInstructionBlock)
    
    // MARK: - Branch
    
    /// The ‘br’ instruction is used to cause control flow to transfer to a different basic block in the current function.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#br-instruction)
    case conditionalBranch(conditional: LLVMValue, ifTrue: LLVMInstructionBlock, ifFalse: LLVMInstructionBlock, block: LLVMInstructionBlock)
    
    /// The ‘br’ instruction is used to cause control flow to transfer to a different basic block in the current function.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#br-instruction)
    case unconditionalBranch(_ target: LLVMInstructionBlock, block: LLVMInstructionBlock)
    
    // MARK: - Load & Store
    
    /// The ‘load’ instruction is used to read from memory.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#load-instruction)
    case load(target: LLVMVirtualRegister, srcPointer: LLVMIdentifier, block: LLVMInstructionBlock)
    
    /// The ‘store’ instruction is used to write to memory.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#store-instruction)
    case store(source: LLVMValue, destPointer: LLVMIdentifier, block: LLVMInstructionBlock)
    
    /// The ‘getelementptr’ instruction is used to get the address of a subelement of an aggregate data structure.
    ///
    /// It performs address calculation only and does not access memory.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#getelementptr-instruction)
    case getElementPointer(target: LLVMVirtualRegister, structureType: LLVMIdentifier, structurePointer: LLVMIdentifier,
        elementIndex: Int, block: LLVMInstructionBlock)
    
    // MARK: - Invocation
    
    /// The ‘call’ instruction represents a simple function call.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#call-instruction)
    case call(target: LLVMVirtualRegister?, functionIdentifier: LLVMIdentifier, arguments: [LLVMValue], block: LLVMInstructionBlock)
    
    /// The ‘ret’ instruction is used to return control flow (and optionally a value) from a function back to the caller.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#ret-instruction)
    case returnValue(_ value: LLVMValue, block: LLVMInstructionBlock)
    
    /// The ‘ret’ instruction is used to return control flow (and optionally a value) from a function back to the caller.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#ret-instruction)
    case returnVoid(block: LLVMInstructionBlock)
    
    // MARK: - Allocation
    
    /// The ‘alloca’ instruction allocates memory on the stack frame of the currently executing function,
    /// to be automatically released when this function returns to its caller.
    ///
    /// The object is always allocated in the address space for allocas indicated in the datalayout.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#alloca-instruction)
    case allocate(target: LLVMVirtualRegister, block: LLVMInstructionBlock)
    
    // MARK: - Declaration
    
    /// Global variables define regions of memory allocated at compilation time instead of run-time.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#global-variables)
    case declareGlobal(target: LLVMIdentifier, source: LLVMValue)
    
    /// The structure type is used to represent a collection of data members together in memory.
    ///
    /// The elements of a structure may be any type that has a size.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#structure-type)
    case declareStructureType(target: LLVMIdentifier, types: [LLVMType])
    
    // MARK: - Conversion
    
    /// The ‘bitcast’ instruction converts value to type ty2 without changing any bits.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#bitcast-to-instruction)
    case bitcast(target: LLVMVirtualRegister, source: LLVMValue, block: LLVMInstructionBlock)
    
    /// The ‘trunc’ instruction truncates its operand to the type ty2.
    ///
    /// The ‘trunc’ instruction truncates the high order bits
    /// in value and converts the remaining bits to ty2.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#trunc-to-instruction)
    case truncate(target: LLVMVirtualRegister, source: LLVMValue, block: LLVMInstructionBlock)
    
    /// The ‘zext’ instruction zero extends its operand to type ty2.
    ///
    /// The zext fills the high order bits of the value with zero bits
    /// until it reaches the size of the destination type, ty2.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#zext-to-instruction)
    case zeroExtend(target: LLVMVirtualRegister, source: LLVMValue, block: LLVMInstructionBlock)
    
    // MARK: - Macro Instructions
    
    /// Generates a call to printf with the passed value.
    case print(source: LLVMValue, block: LLVMInstructionBlock)
    
    /// Generates a call to printf with an appended newline with the passed value.
    case println(source: LLVMValue, block: LLVMInstructionBlock)
    
    /// Generates a call to scanf and places the read value into the target
    case read(target: LLVMVirtualRegister, block: LLVMInstructionBlock)
    
    // MARK: - Other
    
    /// The ‘phi’ instruction is used to implement the φ node in the SSA graph representing the function.
    ///
    /// # Reference
    /// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#phi-instruction)
    case phi(LLVMPhiInstruction)
    
    // MARK: - Temporary ARM Instructions
    
    /// This is a fake instruction used when coming out of SSA and
    /// converting to ARM instructions. There is no `move` instruction in LLVM.
    ///
    /// # Reference
    /// [ARM Documentation](https://developer.arm.com/docs/100076/0200/a32t32-instruction-set-reference/a32-and-t32-instructions/mov)
    case move(target: LLVMVirtualRegister, source: LLVMValue, block: LLVMInstructionBlock)
    
}
