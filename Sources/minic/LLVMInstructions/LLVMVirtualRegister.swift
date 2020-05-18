//
//  LLVMVirtualRegister.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

class LLVMVirtualRegister: Hashable {
    private static var currentIndex = 0
    
    var rawIdentifier: String
    let type: LLVMType
    
    private(set) var definingInstruction: LLVMInstruction?
    
    /// Instructions that uses this register as a source
    private(set) var uses = Set<LLVMInstruction>()
    
    var identifier: LLVMIdentifier {
        .virtualRegister(self)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawIdentifier)
        hasher.combine(type)
    }
    
    init(ofType type: LLVMType) {
        LLVMVirtualRegister.currentIndex += 1
        rawIdentifier = "_reg\(LLVMVirtualRegister.currentIndex)"
        self.type = type
    }
    
    init(withPrefix prefix: String, type: LLVMType) {
        LLVMVirtualRegister.currentIndex += 1
        rawIdentifier = "_\(prefix)_\(LLVMVirtualRegister.currentIndex)"
        self.type = type
    }
    
    init(withId id: String, type: LLVMType) {
        self.rawIdentifier = id
        self.type = type
    }
    
    func setDefiningInstruction(_ instruction: LLVMInstruction) {
        definingInstruction = instruction
    }
    
    func addUse(by instruction: LLVMInstruction) {
        uses.insert(instruction)
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
    
    static func == (lhs: LLVMVirtualRegister, rhs: LLVMVirtualRegister) -> Bool {
        lhs.rawIdentifier == rhs.rawIdentifier
    }
}
