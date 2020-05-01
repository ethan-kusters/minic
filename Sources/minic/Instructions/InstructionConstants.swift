//
//  InstructionConstants.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/26/20.
//

import Foundation

struct InstructionConstants {
    static let defaultIntType = InstructionType.i32
    static let defaultBoolType = InstructionType.i32
    static let falseValue = 0
    static let trueValue = 1
    static let parameterPrefix = "_param_"
    static let returnPointer = "_retVal"
    static let printHelperFunction = ".printHelper"
    static let printlnHelperFunction = ".printlnHelper"
    static let readHelperFunction = ".readHelper"
    static let mallocFunction = "malloc"
    static let freeFunction = "free"
}
