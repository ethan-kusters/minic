//
//  LLVMVirtualRegister.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

class LLVMVirtualRegister: Equatable {
    private static var currentIndex = 0
    
    private let id: String
    let type: LLVMType
    
    private(set) var definingInstruction: LLVMInstruction?
    
    /// Instructions that uses this register as a source
    private(set) var uses = [LLVMInstruction]()
    
    var identifier: LLVMIdentifier {
        .localValue(id, type: type)
    }
    
    init(ofType type: LLVMType) {
        LLVMVirtualRegister.currentIndex += 1
        id = "_reg\(LLVMVirtualRegister.currentIndex)"
        self.type = type
    }
    
    init(withId id: String, type: LLVMType) {
        self.id = id
        self.type = type
    }
    
    func setDefiningInstruction(_ instruction: LLVMInstruction) {
        guard definingInstruction == nil else {
            fatalError("\(#function): Virtual Register's defining instruction can only be set once.")
        }
        
        definingInstruction = instruction
    }
    
    func addUse(by instruction: LLVMInstruction) {
        uses.append(instruction)
    }
    
    static func newIntRegister() -> LLVMVirtualRegister {
        LLVMVirtualRegister(ofType: LLVMInstructionConstants.defaultIntType)
    }
    
    static func newBoolRegister() -> LLVMVirtualRegister {
        LLVMVirtualRegister(ofType: LLVMInstructionConstants.defaultBoolType)
    }
    
    static func == (lhs: LLVMVirtualRegister, rhs: LLVMVirtualRegister) -> Bool {
        lhs.id == rhs.id
    }
}
