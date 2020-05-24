//
//  LLVMPhiInstruction.swift
//  minic
//
//  Created by Ethan Kusters on 5/10/20.
//

import Foundation

/// The ‘phi’ instruction is used to implement the φ node in the SSA graph representing the function.
///
/// # Reference
/// [LLVM Documentation](https://releases.llvm.org/9.0.0/docs/LangRef.html#phi-instruction)
class LLVMPhiInstruction {
    var operands = [PhiOperand]()
    let block: InstructionBlock<LLVMInstruction>
    let target: LLVMVirtualRegister
    let associatedIdentifier: LLVMIdentifier
    var incomplete: Bool
    
    var trivial: Bool {
        operands.map(\.value).filter({$0 != target}).allElementsAreEqual()
    }
    
    var representativeOperand: PhiOperand? {
        return operands.first(where: { $0.value != target })
    }
    
    init(inBlock block: InstructionBlock<LLVMInstruction>, forID id: LLVMIdentifier, incomplete: Bool = false) {
        self.block = block
        self.target = LLVMVirtualRegister(withPrefix: id.descriptiveString, type: id.type)
        self.incomplete = incomplete
        self.associatedIdentifier = id
        target.setDefiningInstruction(.phi(self))
    }
    
    private init(operands: [PhiOperand],
                 block: InstructionBlock<LLVMInstruction>,
                 target: LLVMVirtualRegister,
                 associatedIdentifier: LLVMIdentifier,
                 incomplete: Bool) {
        self.operands = operands
        self.block = block
        self.target = target
        self.associatedIdentifier = associatedIdentifier
        self.incomplete = incomplete
    }
    
    func addOperands() {
        block.predecessors.forEach { predecessor in
            let value = predecessor.readVariable(associatedIdentifier)
            value.addUse(by: .phi(self))
            operands.append(PhiOperand(value: value, block: predecessor))
        }
    }
    
    func replacingRegister(_ oldRegister: LLVMVirtualRegister, with newValue: LLVMValue) -> LLVMPhiInstruction {
        let containsRegister = operands.contains(where: { phiOperand in
            guard case let .register(register) = phiOperand.value else { return false }
            return register == oldRegister
        })
        
        guard containsRegister else { return self }
        let newOperands = operands.map { operand -> PhiOperand in
            guard case let .register(register) = operand.value else { return operand }
            guard register == oldRegister else { return operand }
            
            return PhiOperand(value: newValue, block: operand.block)
        }
        
        return LLVMPhiInstruction(operands: newOperands,
                                  block: self.block,
                                  target: self.target,
                                  associatedIdentifier: self.associatedIdentifier,
                                  incomplete: self.incomplete)
    }
}
