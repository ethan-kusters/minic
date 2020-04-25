//
//  TypeCheckingManager.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/15/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

class TypeCheckingManager {
    func check(_ program: Program) throws -> Bool {
        let context = TypeContext()
        let errorBucket = ErrorBucker()
        let statementTypeChecker = StatementTypeChecker(context: context, errorHandler: errorBucket)

        try program.types.forEach(context.addStruct)
        try program.declarations.forEach(context.addGlobalSymbol)

        try program.functions.forEach { function in
            try function.parameters.forEach(context.addLocalSymbol)
            try function.locals.forEach(context.addLocalSymbol)
            context.setReturnType(function.retType)
            try context.addFunction(function)
            
            let errorCountBeforeTypeCheck = errorBucket.count
            
            if function.retType != .void
                && statementTypeChecker(function.body) == .notReturnEquivalent
                && errorCountBeforeTypeCheck == errorBucket.count {
                let error = TypeError.functionMissingReturn(lineNumber: function.lineNumber,
                                                            functionName: function.name,
                                                            returnType: function.retType)
                
                errorBucket.report(error)
            }
            
            context.popLocalContext()
        }
        
        let hasValidMainFunction = program.functions.contains { function in
            function.name == "main" && function.retType == .int
        }
        
        if !hasValidMainFunction {
            errorBucket.report(.mainFunctionMissing)
        }
        
        guard errorBucket.count > 0 else { return true }
        errorBucket.printErrors()
        
        return false
    }
}
