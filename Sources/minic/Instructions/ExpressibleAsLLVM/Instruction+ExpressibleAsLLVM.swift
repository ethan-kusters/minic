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
            
        case let .add(type, firstOp, secondOp, result):
            return "\(result.llvmString) = add \(type.llvmString) \(firstOp.llvmString), \(secondOp.llvmString)"
            
        case let .subtract(type, firstOp, secondOp, result):
            return "\(result.llvmString) = sub \(type.llvmString) \(firstOp.llvmString), \(secondOp.llvmString)"
            
        case let .multiply(type, firstOp, secondOp, result):
            return "\(result.llvmString) = mul \(type.llvmString) \(firstOp.llvmString), \(secondOp.llvmString)"
            
        case let .signedDivide(type, firstOp, secondOp, result):
            return "\(result.llvmString) = sdiv \(type.llvmString) \(firstOp.llvmString), \(secondOp.llvmString)"
            
        case let .and(type, firstOp, secondOp, result):
            return "\(result.llvmString) = and \(type.llvmString) \(firstOp.llvmString), \(secondOp.llvmString)"
            
        case let .or(type, firstOp, secondOp, result):
            return "\(result.llvmString) = or \(type.llvmString) \(firstOp.llvmString), \(secondOp.llvmString)"
            
        case let .exclusiveOr(type, firstOp, secondOp, result):
            return "\(result.llvmString) = xor \(type.llvmString) \(firstOp.llvmString), \(secondOp.llvmString)"
            
        case let .comparison(condCode, type, firstOp, secondOp, result):
            return "\(result.llvmString) = icmp \(condCode.llvmString) \(type.llvmString) \(firstOp.llvmString), \(secondOp.llvmString)"
            
        case let .conditionalBranch(conditional, ifTrue, ifFalse):
            return "br i1 \(conditional.llvmString), label \(ifTrue.llvmString), label \(ifFalse.llvmString)"
            
        case let .unconditionalBranch(destination):
            return "br label \(destination.llvmString)"
            
        case let .load(pointer, result):
            return "\(result.llvmString) = load \(result.type.llvmString), \(pointer.type.llvmString)* \(pointer.llvmString)"
            
        case let .store(value, pointer):
            return "store \(value.type.llvmString) \(value.llvmString), \(pointer.type.llvmString)* \(pointer.llvmString)"
            
        case let .getElementPointer(structureType, structurePointer, elementIndex, result):
            return "\(result.llvmString) = getelementptr \(structureType.llvmString), \(structureType.llvmString)* \(structurePointer.llvmString), i1 0, i32 \(elementIndex)"
            
        case let .call(returnType, functionPointer, arguments, result):
            let argumentString = arguments.map { arg in
                guard arg.type != .null else { return "null" }
                return "\(arg.type.llvmString) \(arg.llvmString)"
            }.joined(separator: ", ")
            
            let call = "call \(returnType.llvmString) \(functionPointer.llvmString)(\(argumentString))"
            
            if let result = result?.llvmString {
                return "\(result) = \(call)"
            } else {
                return call
            }
            
        case let .returnValue(value):
            return "ret \(value.type.llvmString) \(value.llvmString)"
            
        case .returnVoid:
            return "ret void"
            
        case let .allocate(type, result):
            return "\(result.llvmString) = alloca \(type.llvmString)"
            
        case let .declareGlobal(type, value, result):
            return "\(result.llvmString) = common global \(type.llvmString) \(value.llvmString), align 4"
            
        case let .declareStructureType(types, result):
            let typeList = types.map(\.llvmString).joined(separator: ", ")
            return "\(result.llvmString) = type { \(typeList) }"
            
        case let .bitcast(value, result):
            return "\(result.llvmString) = bitcast \(value.type.llvmString) \(value.llvmString) to \(result.type.llvmString)"
            
        case let .truncate(currentType, value, destinationType, result):
            return "\(result.llvmString) = trunc \(currentType.llvmString) \(value.llvmString) to \(destinationType.llvmString)"
            
        case let .zeroExtend(currentType, value, destinationType, result):
            return "\(result.llvmString) = zext \(currentType.llvmString) \(value.llvmString) to \(destinationType.llvmString)"
        
        }
    }
}
