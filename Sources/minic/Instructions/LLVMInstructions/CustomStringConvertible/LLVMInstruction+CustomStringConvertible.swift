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
            
        case let .add(target, firstOp, secondOp, _):
            return "\(target) = add \(firstOp.type) \(firstOp), \(secondOp)"
            
        case let .subtract(target, firstOp, secondOp, _):
            return "\(target) = sub \(firstOp.type) \(firstOp), \(secondOp)"
            
        case let .multiply(target, firstOp, secondOp, _):
            return "\(target) = mul \(firstOp.type) \(firstOp), \(secondOp)"
            
        case let .signedDivide(target, firstOp, secondOp, _):
            return "\(target) = sdiv \(firstOp.type) \(firstOp), \(secondOp)"
            
        case let .and(target, firstOp, secondOp, _):
            return "\(target) = and \(firstOp.type) \(firstOp), \(secondOp)"
            
        case let .or(target, firstOp, secondOp, _):
            return "\(target) = or \(firstOp.type) \(firstOp), \(secondOp)"
            
        case let .exclusiveOr(target, firstOp, secondOp, _):
            return "\(target) = xor \(firstOp.type) \(firstOp), \(secondOp)"
            
        case let .comparison(target, condCode, firstOp, secondOp, _):
            return "\(target) = icmp \(condCode) \(firstOp.type) \(firstOp), \(secondOp)"
            
        case let .conditionalBranch(conditional, ifTrue, ifFalse, _):
            return "br i1 \(conditional), \(ifTrue.llvmIdentifier), \(ifFalse.llvmIdentifier)"
            
        case let .unconditionalBranch(destination, _):
            return "br \(destination.llvmIdentifier)"
            
        case let .load(target, srcPointer, _):
            return "\(target) = load \(target.type), \(srcPointer.type)* \(srcPointer)"
            
        case let .store(source, destPointer, _):
            return "store \(source.type) \(source), \(destPointer.type)* \(destPointer)"
            
        case let .getElementPointer(target, structureType, structurePointer, elementIndex, _):
            return "\(target) = getelementptr \(structureType), \(structureType)* \(structurePointer), i1 0, i32 \(elementIndex)"
            
        case let .call(target, functionIdentifier, arguments, _):
            let argumentString = arguments.map { arg -> String in
                guard arg.type != .null else { return "null" }
                return "\(arg.type) \(arg)"
            }.joined(separator: ", ")
            
            let callString = "call \(target?.type ?? .void) \(functionIdentifier)(\(argumentString))"
            
            if let target = target {
                return "\(target) = \(callString)"
            } else {
                return callString
            }
            
        case let .returnValue(value, _):
            return "ret \(value.type) \(value)"
            
        case .returnVoid:
            return "ret void"
            
        case let .allocate(target, _):
            return "\(target) = alloca \(target.type)"
            
        case let .declareGlobal(target, source):
            return "\(target) = common global \(source.type) \(source), align 4"
            
        case let .declareStructureType(target, types):
            let typeList = types.map(\.description).joined(separator: ", ")
            return "\(target) = type { \(typeList) }"
            
        case let .bitcast(target, source, _):
            return "\(target) = bitcast \(source.type) \(source) to \(target.type)"
            
        case let .truncate(target, source, _):
            return "\(target) = trunc \(source.type) \(source) to \(target.type)"
            
        case let .zeroExtend(target, source, _):
            return "\(target) = zext \(source.type) \(source) to \(target.type)"
            
        case let .phi(phiInstruction):
            return phiInstruction.description
            
        case .move:
            fatalError("Cannot print out an LLVM `move` instruction as it does not exist.")
            
        case let .print(source, block):
            return LLVMInstructionMacros.getPrintInstructions(source: source, block: block)
                .map(\.description)
                .joined(separator: "\n")
        
        case let .println(source, block):
            return LLVMInstructionMacros.getPrintlnInstructions(source: source, block: block)
                .map(\.description)
                .joined(separator: "\n")
            
        case let .read(target, block):
            return LLVMInstructionMacros.getReadInstructions(target: target, block: block)
                .map(\.description)
                .joined(separator: "\n")
        }
        
        
        
    }
}
