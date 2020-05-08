//
//  Instruction+expressedAsLLVM.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/27/20.
//

import Foundation

extension Instruction: ExpressibleAsLLVM {
    var llvmString: String {
        switch(self) {
            
        case let .add(firstOp, secondOp, destination):
            return "\(destination.llvmString) = add \(firstOp.type.llvmString) \(firstOp.llvmString), \(secondOp.llvmString)"
            
        case let .subtract(firstOp, secondOp, destination):
            return "\(destination.llvmString) = sub \(firstOp.type.llvmString) \(firstOp.llvmString), \(secondOp.llvmString)"
            
        case let .multiply(firstOp, secondOp, destination):
            return "\(destination.llvmString) = mul \(firstOp.type.llvmString) \(firstOp.llvmString), \(secondOp.llvmString)"
            
        case let .signedDivide(firstOp, secondOp, destination):
            return "\(destination.llvmString) = sdiv \(firstOp.type.llvmString) \(firstOp.llvmString), \(secondOp.llvmString)"
            
        case let .and(firstOp, secondOp, destination):
            return "\(destination.llvmString) = and \(firstOp.type.llvmString) \(firstOp.llvmString), \(secondOp.llvmString)"
            
        case let .or(firstOp, secondOp, destination):
            return "\(destination.llvmString) = or \(firstOp.type.llvmString) \(firstOp.llvmString), \(secondOp.llvmString)"
            
        case let .exclusiveOr(firstOp, secondOp, destination):
            return "\(destination.llvmString) = xor \(firstOp.type.llvmString) \(firstOp.llvmString), \(secondOp.llvmString)"
            
        case let .comparison(condCode, firstOp, secondOp, destination):
            return "\(destination.llvmString) = icmp \(condCode.llvmString) \(firstOp.type.llvmString) \(firstOp.llvmString), \(secondOp.llvmString)"
            
        case let .conditionalBranch(conditional, ifTrue, ifFalse):
            return "br i1 \(conditional.llvmString), label \(ifTrue.llvmString), label \(ifFalse.llvmString)"
            
        case let .unconditionalBranch(destination):
            return "br label \(destination.llvmString)"
            
        case let .load(source, destination):
            return "\(destination.llvmString) = load \(destination.type.llvmString), \(source.type.llvmString)* \(source.llvmString)"
            
        case let .store(source, destination):
            return "store \(source.type.llvmString) \(source.llvmString), \(destination.type.llvmString)* \(destination.llvmString)"
            
        case let .getElementPointer(structureType, structurePointer, elementIndex, destination):
            return "\(destination.llvmString) = getelementptr \(structureType.llvmString), \(structureType.llvmString)* \(structurePointer.llvmString), i1 0, i32 \(elementIndex)"
            
        case let .call(returnType, functionPointer, arguments, destination):
            let argumentString = arguments.map { arg in
                guard arg.type != .null else { return "null" }
                return "\(arg.type.llvmString) \(arg.llvmString)"
            }.joined(separator: ", ")
            
            let call = "call \(returnType.llvmString) \(functionPointer.llvmString)(\(argumentString))"
            
            if let destination = destination?.llvmString {
                return "\(destination) = \(call)"
            } else {
                return call
            }
            
        case let .returnValue(value):
            return "ret \(value.type.llvmString) \(value.llvmString)"
            
        case .returnVoid:
            return "ret void"
            
        case let .allocate(destination):
            return "\(destination.llvmString) = alloca \(destination.type.llvmString)"
            
        case let .declareGlobal(source, destination):
            return "\(destination.llvmString) = common global \(source.type.llvmString) \(source.llvmString), align 4"
            
        case let .declareStructureType(types, destination):
            let typeList = types.map(\.llvmString).joined(separator: ", ")
            return "\(destination.llvmString) = type { \(typeList) }"
            
        case let .bitcast(source, destination):
            return "\(destination.llvmString) = bitcast \(source.type.llvmString) \(source.llvmString) to \(destination.type.llvmString)"
            
        case let .truncate(source, destination):
            return "\(destination.llvmString) = trunc \(source.type.llvmString) \(source.llvmString) to \(destination.type.llvmString)"
            
        case let .zeroExtend(source, destination):
            return "\(destination.llvmString) = zext \(source.type.llvmString) \(source.llvmString) to \(destination.type.llvmString)"
        
        }
    }
}
