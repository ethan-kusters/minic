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
class LLVMPhiInstruction: Hashable {
    var operands = [PhiOperand]()
    let block: Block
    let target: LLVMVirtualRegister
    let associatedIdentifier: LLVMIdentifier
    var incomplete: Bool
    
    var trivial: Bool {
        operands.map(\.value).allElementsAreEqual()
    }
    
    init(inBlock block: Block, forID id: LLVMIdentifier, incomplete: Bool = false) {
        self.block = block
        self.target = LLVMVirtualRegister(withPrefix: id.descriptiveString, type: id.type)
        self.incomplete = incomplete
        self.associatedIdentifier = id
        target.setDefiningInstruction(.phi(self))
    }
    
    private init(operands: [PhiOperand], block: Block, target: LLVMVirtualRegister, associatedIdentifier: LLVMIdentifier, incomplete: Bool) {
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
    
    static func == (lhs: LLVMPhiInstruction, rhs: LLVMPhiInstruction) -> Bool {
        lhs.operands == rhs.operands
            && lhs.block == rhs.block
            && lhs.target == rhs.target
            && lhs.associatedIdentifier == rhs.associatedIdentifier
            && lhs.incomplete == rhs.incomplete
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(block)
        hasher.combine(target)
        hasher.combine(associatedIdentifier)
        hasher.combine(incomplete)
    }
}

extension LLVMPhiInstruction {
    struct PhiOperand: Equatable {
        let value: LLVMValue
        let block: Block
    }
}
