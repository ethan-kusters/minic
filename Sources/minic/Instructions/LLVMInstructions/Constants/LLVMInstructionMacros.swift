//
//  LLVMInstructionMacros.swift
//  minic
//
//  Created by Ethan Kusters on 5/25/20.
//

import Foundation

struct LLVMInstructionMacros {
    static func getPrintlnInstructions(source: LLVMValue,
                                       block: InstructionBlock<LLVMInstruction>) -> [LLVMInstruction] {
        let printlnFuncId = LLVMIdentifier.function(LLVMInstructionConstants.printlnHelperFunction,
                                                    retType: .void)
        
        let printlnCallInstr = LLVMInstruction.call(target: nil,
                                                    functionIdentifier: printlnFuncId,
                                                    arguments: [source],
                                                    block: block)
        
        return [printlnCallInstr]
    }
    
    static func getPrintInstructions(source: LLVMValue,
                                     block: InstructionBlock<LLVMInstruction>) -> [LLVMInstruction] {
        let printFuncId = LLVMIdentifier.function(LLVMInstructionConstants.printHelperFunction,
                                                    retType: .void)
        
        let printlnCallInstr = LLVMInstruction.call(target: nil,
                                                    functionIdentifier: printFuncId,
                                                    arguments: [source],
                                                    block: block)
        
        return [printlnCallInstr]
    }
    
    static func getReadInstructions(target: LLVMVirtualRegister, block: InstructionBlock<LLVMInstruction>) -> [LLVMInstruction] {
        let readFuncId = LLVMIdentifier.function(LLVMInstructionConstants.readHelperFunction,
                                                 retType: target.type)
        
        let readInstruction = LLVMInstruction.call(target: target,
                                                   functionIdentifier: readFuncId,
                                                   arguments: [],
                                                   block: block)
        
        return [readInstruction]
    }
}
