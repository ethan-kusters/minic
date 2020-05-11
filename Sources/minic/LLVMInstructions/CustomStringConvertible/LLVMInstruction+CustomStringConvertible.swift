//
//  LLVMInstruction+CustomStringConvertible.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/27/20.
//

import Foundation

extension LLVMInstruction: CustomStringConvertible {
    var description: String {
        switch(self) {
            
        case let .add(firstOp, secondOp, destination):
            return "\(destination) = add \(firstOp.type) \(firstOp), \(secondOp)"
            
        case let .subtract(firstOp, secondOp, destination):
            return "\(destination) = sub \(firstOp.type) \(firstOp), \(secondOp)"
            
        case let .multiply(firstOp, secondOp, destination):
            return "\(destination) = mul \(firstOp.type) \(firstOp), \(secondOp)"
            
        case let .signedDivide(firstOp, secondOp, destination):
            return "\(destination) = sdiv \(firstOp.type) \(firstOp), \(secondOp)"
            
        case let .and(firstOp, secondOp, destination):
            return "\(destination) = and \(firstOp.type) \(firstOp), \(secondOp)"
            
        case let .or(firstOp, secondOp, destination):
            return "\(destination) = or \(firstOp.type) \(firstOp), \(secondOp)"
            
        case let .exclusiveOr(firstOp, secondOp, destination):
            return "\(destination) = xor \(firstOp.type) \(firstOp), \(secondOp)"
            
        case let .comparison(condCode, firstOp, secondOp, destination):
            return "\(destination) = icmp \(condCode) \(firstOp.type) \(firstOp), \(secondOp)"
            
        case let .conditionalBranch(conditional, ifTrue, ifFalse):
            return "br i1 \(conditional), \(ifTrue.llvmIdentifier), \(ifFalse.llvmIdentifier)"
            
        case let .unconditionalBranch(destination):
            return "br \(destination.llvmIdentifier)"
            
        case let .load(source, destination):
            return "\(destination) = load \(destination.type), \(source.type)* \(source)"
            
        case let .store(source, destination):
            return "store \(source.type) \(source), \(destination.type)* \(destination)"
            
        case let .getElementPointer(structureType, structurePointer, elementIndex, destination):
            return "\(destination) = getelementptr \(structureType), \(structureType)* \(structurePointer), i1 0, i32 \(elementIndex)"
            
        case let .call(functionIdentifier, arguments, destination):
            let argumentString = arguments.map { arg -> String in
                guard arg.type != .null else { return "null" }
                return "\(arg.type) \(arg)"
            }.joined(separator: ", ")
            
            let call = "call \(destination?.type ?? .void) \(functionIdentifier)(\(argumentString))"
            
            if let destination = destination {
                return "\(destination) = \(call)"
            } else {
                return call
            }
            
        case let .returnValue(value):
            return "ret \(value.type) \(value)"
            
        case .returnVoid:
            return "ret void"
            
        case let .allocate(destination):
            return "\(destination) = alloca \(destination.type)"
            
        case let .declareGlobal(source, destination):
            return "\(destination) = common global \(source.type) \(source), align 4"
            
        case let .declareStructureType(types, destination):
            let typeList = types.map(\.description).joined(separator: ", ")
            return "\(destination) = type { \(typeList) }"
            
        case let .bitcast(source, destination):
            return "\(destination) = bitcast \(source.type) \(source) to \(destination.type)"
            
        case let .truncate(source, destination):
            return "\(destination) = trunc \(source.type) \(source) to \(destination.type)"
            
        case let .zeroExtend(source, destination):
            return "\(destination) = zext \(source.type) \(source) to \(destination.type)"
            
        case let .phi(valuePairs, destination):
            let valuePairString = valuePairs.map { valuePair in
                "[ \(valuePair.value), \(valuePair.label) ]"
            }.joined(separator: ", ")
            
            return "\(destination) = phi \(destination.type) \(valuePairString)"
        
        }
    }
}
