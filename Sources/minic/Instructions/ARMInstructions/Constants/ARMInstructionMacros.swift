//
//  ARMInstructionMacros.swift
//  minic
//
//  Created by Ethan Kusters on 5/25/20.
//

import Foundation

struct ARMInstructionMacros {
    static var fileHeader: [ARMInstruction] {
        [
            .architectureDirective(architecture: ARMInstructionConstants.expectedARMArchitecture)
        ]
    }
    
    static var fileFooter: [ARMInstruction] {
        [
            .sectionDirective(section: .readOnlyData),
            .alignmentDirective(exponent: ARMInstructionConstants.byteAlignmentExponent),
            .label(symbol: ARMInstructionStringConstants.printlnFormatSymbol),
            .stringDefinitionDirective(string: ARMInstructionStringConstants.printlnFormatString),
            .alignmentDirective(exponent: ARMInstructionConstants.byteAlignmentExponent),
            .label(symbol: ARMInstructionStringConstants.printFormatSymbol),
            .stringDefinitionDirective(string: ARMInstructionStringConstants.printFormatString),
            .alignmentDirective(exponent: ARMInstructionConstants.byteAlignmentExponent),
            .label(symbol: ARMInstructionStringConstants.readFormatSymbol),
            .stringDefinitionDirective(string: ARMInstructionStringConstants.readFormatString),
            .declareGlobal(label: ARMInstructionStringConstants.readScratchVariableSymbol),
            .globalSymbolDirective(symbol: ARMInstructionStringConstants.divideFunctionSymbol)
        ]
    }
    
    static func getPrintInstructions(_ context: CodeGenerationContext) -> [ARMInstruction] {
        [
            getMoveSymbol32(target: context.getRegister(fromRealRegister: 0),
                            source: ARMInstructionStringConstants.printFormatSymbol),
            [
                .branchWithLink(label: ARMInstructionStringConstants.printFunctionSymbol)
            ]
            ].flatten()
    }
    
    static func getPrintlnInstructions(_ context: CodeGenerationContext) -> [ARMInstruction] {
        [
            getMoveSymbol32(target: context.getRegister(fromRealRegister: 0),
                            source: ARMInstructionStringConstants.printlnFormatSymbol),
            [
                .branchWithLink(label: ARMInstructionStringConstants.printFunctionSymbol)
            ]
        ].flatten()
    }
    
    static func getScanInstructions(_ context: CodeGenerationContext) -> [ARMInstruction] {
        [
            getMoveSymbol32(target: context.getRegister(fromRealRegister: 1),
                            source: ARMInstructionStringConstants.readScratchVariableSymbol),
            getMoveSymbol32(target: context.getRegister(fromRealRegister: 0),
                            source: ARMInstructionStringConstants.readFormatSymbol),
            [
                .branchWithLink(label: ARMInstructionStringConstants.scanFunctionSymbol)
            ]
            ].flatten()
    }
    
    static func getMoveSymbol32(target: ARMRegister, source: ARMSymbol) -> [ARMInstruction] {
        [
            ARMInstruction.moveBottom(condCode: nil,
                                      target: target,
                                      source: .symbol(prefix: .lower16,
                                                      symbol: source)).logRegisterUses(),
            ARMInstruction.moveTop(condCode: nil,
                                   target: target,
                                   source: .symbol(prefix: .upper16,
                                                   symbol: source)).logRegisterUses(),
        ]
    }
    
    static func getMoveLiteral32(target: ARMRegister, source: ARMImmediateValue) -> [ARMInstruction] {
        return [
            ARMInstruction.moveBottom(condCode: nil,
                                      target: target,
                                      source: .literal(prefix: .lower16,
                                                       immediate: source)).logRegisterUses(),
            ARMInstruction.moveTop(condCode: nil,
                                   target: target,
                                   source: .literal(prefix: .upper16,
                                                    immediate: source)).logRegisterUses(),
        ]
    }
    
    static func getFunctionHeader(_ functionSymbol: ARMSymbol) -> [ARMInstruction] {
        [
            .alignmentDirective(exponent: 2),
            .globalSymbolDirective(symbol: functionSymbol),
            .label(symbol: functionSymbol)
        ]
    }
    
    static func getFunctionPrologue(_ context: CodeGenerationContext, registersUsed: [ARMRegister], valuesOnStack: Int) -> [ARMInstruction] {
        let sp = context.getRegister(fromRealRegister: .stackPointer)
        let fp = context.getRegister(fromRealRegister: .framePointer)
        let lr = context.getRegister(fromRealRegister: .linkRegister)
        
        let spAdjustment = (ARMInstructionConstants.bytesPerValue * valuesOnStack).immediateValue
        let setSPInstr = ARMInstruction.subtract(target: sp,
                                                 firstOp: sp,
                                                 secondOp: .constant(spAdjustment)).logRegisterUses()
        
        let pushInstr = ARMInstruction.push(registers: [fp, lr]).logRegisterUses()
        let addFPInstr = ARMInstruction.add(target: fp,
                                            firstOp: sp,
                                            secondOp: .constant(ARMInstructionConstants.bytesPerValue.immediateValue)).logRegisterUses()
        
        return [
            pushInstr,
            addFPInstr,
            registersUsed.isEmpty == false ? ARMInstruction.push(registers: registersUsed).logRegisterUses() : nil,
            valuesOnStack > 0 ? setSPInstr : nil
        ].compact()
    }
    
    static func getFunctionFooter(_ functionSymbol: ARMSymbol) -> [ARMInstruction] {
        [
            .sizeDirective(symbol: functionSymbol)
        ]
    }
    
    static func getFunctionEpilogue(_ context: CodeGenerationContext, registersUsed: [ARMRegister], valuesOnStack: Int) -> [ARMInstruction] {
        let sp = context.getRegister(fromRealRegister: .stackPointer)
        let fp = context.getRegister(fromRealRegister: .framePointer)
        let pc = context.getRegister(fromRealRegister: .programCounter)
        
        let spAdjustment = (ARMInstructionConstants.bytesPerValue * valuesOnStack).immediateValue
        let resetSPInstr = ARMInstruction.add(target: sp,
                                              firstOp: sp,
                                              secondOp: .constant(spAdjustment)).logRegisterUses()
        return [
            valuesOnStack > 0 ? resetSPInstr : nil,
            registersUsed.isEmpty == false ? ARMInstruction.pop(registers: registersUsed).logRegisterUses() : nil,
            .pop(registers: [fp, pc]),
            ].compact()
    }
}
