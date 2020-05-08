//
//  Expression+getStructFromDotExp.swift
//  minic
//
//  Created by Ethan Kusters on 5/6/20.
//

import Foundation

extension Expression {
    func getStructFromDotExpression(_ context: TypeContext) -> TypeDeclaration {
        if case let .identifier(_, id) = self {
            let structPointer = context.getllvmIdentifier(from: id)
            
            guard case let .structure(name: name) = structPointer.type else {
                fatalError("Type checker should have caught this. Dot access on not-struct value.")
            }
            
            return context.getStruct(name)!
        } else if case let .dot(_, left, id) = self {
            var idChain = [id]
            var currentLeft: Expression = left
            while case let .dot(_, left, id) = currentLeft {
                currentLeft = left
                idChain.append(id)
            }
            
            guard case let .identifier(_, baseID) = currentLeft else { fatalError() }
            
            let structPointer = context.getllvmIdentifier(from: baseID)
            
            guard case let .structure(name: baseStructTypeName) = structPointer.type else {
                fatalError("Type checker should have caught this. Dot access on not-struct value.")
            }
            
            var currentStruct = context.getStruct(baseStructTypeName)!
            
            idChain.reversed().forEach { id in
                let currentStructPointer = currentStruct.fields[id]!.type.llvmType
                
                guard case let .structure(name: currentStructName) = currentStructPointer else {
                    fatalError("Type checker should have caught this. Dot access on not-struct value.")
                }
                
                currentStruct = context.getStruct(currentStructName)!
            }
            
            return currentStruct
        } else if case let .invocation(_, functionName, _) = self {
            let functionRetType = context.getFunction(functionName)!.retType.llvmType
            
            guard case let .structure(name: name) = functionRetType else {
                fatalError("Type checker should have caught this. Dot access on not-struct value.")
            }
            
            return context.getStruct(name)!
        } else {
            fatalError("Type checker should have caught this. Dot access on non-identifier value.")
        }
    }
}
