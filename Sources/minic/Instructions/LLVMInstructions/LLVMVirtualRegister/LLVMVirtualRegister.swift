//
//  LLVMVirtualRegister.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

class LLVMVirtualRegister {
    private static var currentIndex = 0
    
    var rawIdentifier: String
    let type: LLVMType
    let parmeterIndex: Int?
    
    private(set) var definingInstruction: LLVMInstruction?
    
    /// Instructions that uses this register as a source
    private(set) var uses = Set<LLVMInstruction>()
    
    var identifier: LLVMIdentifier {
        .virtualRegister(self)
    }
    
    init(ofType type: LLVMType, parameterIndex: Int? = nil) {
        LLVMVirtualRegister.currentIndex += 1
        rawIdentifier = "_reg\(LLVMVirtualRegister.currentIndex)"
        self.type = type
        self.parmeterIndex = parameterIndex
    }
    
    init(withPrefix prefix: String, type: LLVMType, parameterIndex: Int? = nil) {
        LLVMVirtualRegister.currentIndex += 1
        rawIdentifier = "_\(prefix)_\(LLVMVirtualRegister.currentIndex)"
        self.type = type
        self.parmeterIndex = parameterIndex
    }
    
    init(withId id: String, type: LLVMType, parameterIndex: Int? = nil) {
        self.rawIdentifier = id
        self.type = type
        self.parmeterIndex = parameterIndex
    }
    
    func setDefiningInstruction(_ instruction: LLVMInstruction) {
        definingInstruction = instruction
    }
    
    func removeDefiningInstruction(_ instruction: LLVMInstruction) {
        guard instruction == definingInstruction else { return }
        definingInstruction = nil
    }
    
    func addUse(by instruction: LLVMInstruction) {
        uses.insert(instruction)
    }
    
    func removeUse(by instruction: LLVMInstruction) {
        uses.remove(instruction)
    }
    
    func removeAllUses() {
        definingInstruction = nil
        uses.removeAll()
    }
    
    static func newIntRegister() -> LLVMVirtualRegister {
        LLVMVirtualRegister(ofType: LLVMInstructionConstants.defaultIntType)
    }
    
    static func newBoolRegister() -> LLVMVirtualRegister {
        LLVMVirtualRegister(ofType: LLVMInstructionConstants.defaultBoolType)
    }
}
