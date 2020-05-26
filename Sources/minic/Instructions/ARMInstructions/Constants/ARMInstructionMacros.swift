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
    
    static var printInstructions: [ARMInstruction] {
        [
            getMoveSymbol32(target: .real(0), source: ARMInstructionStringConstants.printFormatSymbol),
            [
                .branchWithLink(label: ARMInstructionStringConstants.printFunctionSymbol)
            ]
        ].flatten()
    }
    
    static var printlnInstructions: [ARMInstruction] {
        [
            getMoveSymbol32(target: .real(0), source: ARMInstructionStringConstants.printlnFormatSymbol),
            [
                .branchWithLink(label: ARMInstructionStringConstants.printFunctionSymbol)
            ]
        ].flatten()
    }
    
    static var scanInstructions: [ARMInstruction] {
        [
            getMoveSymbol32(target: .real(1), source: ARMInstructionStringConstants.readScratchVariableSymbol),
            getMoveSymbol32(target: .real(0), source: ARMInstructionStringConstants.readFormatSymbol),
            [
                .branchWithLink(label: ARMInstructionStringConstants.scanFunctionSymbol)
            ]
        ].flatten()
    }
    
    static func getMoveSymbol32(target: ARMRegister, source: ARMSymbol) -> [ARMInstruction] {
        [
            .moveBottom(condCode: nil,
                        target: target,
                        source: .symbol(prefix: .lower16,
                                        symbol: source)),
            .moveTop(condCode: nil,
                     target: target,
                     source: .symbol(prefix: .upper16,
                                        symbol: source)),
        ]
    }
    
    static func getMoveLiteral32(target: ARMRegister, source: ARMImmediateValue) -> [ARMInstruction] {
        return [
            .moveBottom(condCode: nil,
                        target: target,
                        source: .literal(prefix: .lower16,
                                         immediate: source)),
            .moveTop(condCode: nil,
                     target: target,
                     source: .literal(prefix: .upper16,
                                      immediate: source)),
        ]
    }
 
    static func getFunctionHeader(_ functionSymbol: ARMSymbol) -> [ARMInstruction] {
        [
            .alignmentDirective(exponent: 2),
            .globalSymbolDirective(symbol: functionSymbol),
            .label(symbol: functionSymbol)
        ]
    }
    
    static func getFunctionPrologue(registersUsed: [ARMRegister], valuesOnStack: Int) -> [ARMInstruction] {
        let spAdjustment = (ARMInstructionConstants.bytesPerValue * valuesOnStack).immediateValue
        let setSPInstr = ARMInstruction.subtract(target: .real(.stackPointer),
                                                 firstOp: .real(.stackPointer),
                                                 secondOp: .constant(spAdjustment))
        
        return [
            .push(registers: [.real(.framePointer), .real(.linkRegister)]),
            .add(target: .real(.framePointer),
                 firstOp: .real(.stackPointer),
                 secondOp: .constant(ARMInstructionConstants.bytesPerValue.immediateValue)),
            registersUsed.isEmpty == false ? .push(registers: registersUsed) : nil,
            valuesOnStack > 0 ? setSPInstr : nil
        ].compact()
    }
    
    static func getFunctionFooter(_ functionSymbol: ARMSymbol) -> [ARMInstruction] {
        [
            .sizeDirective(symbol: functionSymbol)
        ]
    }
    
    static func getFunctionEpilogue(registersUsed: [ARMRegister], valuesOnStack: Int) -> [ARMInstruction] {
        let spAdjustment = (ARMInstructionConstants.bytesPerValue * valuesOnStack).immediateValue
        let resetSPInstr = ARMInstruction.add(target: .real(.stackPointer),
                                              firstOp: .real(.stackPointer),
                                              secondOp: .constant(spAdjustment))
        return [
            valuesOnStack > 0 ? resetSPInstr : nil,
            registersUsed.isEmpty == false ? .pop(registers: registersUsed) : nil,
            .pop(registers: [.real(.framePointer), .real(.programCounter)]),
        ].compact()
    }
}
