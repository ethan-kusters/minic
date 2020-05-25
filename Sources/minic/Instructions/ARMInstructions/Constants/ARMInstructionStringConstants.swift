//
//  ARMInstructionStringConstants.swift
//  minic
//
//  Created by Ethan Kusters on 5/25/20.
//

import Foundation

struct ARMInstructionStringConstants {
    static let printFunctionSymbol: ARMSymbol = "printf"
    static let scanFunctionSymbol: ARMSymbol = "scanf"
    static let divideFunctionSymbol: ARMSymbol = "__aeabi_idiv"
    
    static let printlnFormatSymbol: ARMSymbol = "PRINTLN_FMT"
    static let printlnFormatString = "%ld\n"
    
    static let printFormatSymbol: ARMSymbol = "PRINT_FMT"
    static let printFormatString = "%ld "
    
    static let readFormatSymbol: ARMSymbol = "READ_FMT"
    static let readFormatString = "%ld"
    static let readScratchVariableSymbol = "read_scratch"
}
