//
//  TypeContext.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/12/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

class TypeContext {
    enum TypeContextError: Error {
        case invalidRedeclarationOfStruct(_ structName: String)
        case invalidRedeclrationOfFunction(_ functionName: String)
        case invalidRedeclarationOfGlobalSymbol(_ symbolName: String)
        case invalidRedeclarationOfLocalSymbol(_ symbolName: String)
    }
    
    private var structTable = [String: TypeDeclaration]()
    private var functionTable = [String: Function]()
    
    private var globalSymbolTable = [String: Type]()
    private var localSymbolTable: [String: Type]?
    
    private var returnType: Type?
    
    func addStruct(_ declaration: TypeDeclaration) throws {
        guard structTable[declaration.name] == nil else {
            throw TypeContextError.invalidRedeclarationOfStruct(declaration.name)
        }
        
        structTable[declaration.name] = declaration
    }
    
    func getStruct(_ structName: String) -> TypeDeclaration? {
        return structTable[structName]
    }
    
    func addFunction(_ function: Function) throws {
        guard functionTable[function.name] == nil else {
            throw TypeContextError.invalidRedeclrationOfFunction(function.name)
        }
        
        functionTable[function.name] = function
    }
    
    func getFunction(_ functionName: String) -> Function? {
        return functionTable[functionName]
    }
    
    func addGlobalSymbol(_ declaration: Declaration) throws {
        guard globalSymbolTable[declaration.name] == nil else {
            throw TypeContextError.invalidRedeclarationOfGlobalSymbol(declaration.name)
        }
        
        globalSymbolTable[declaration.name] = declaration.type
    }
    
    func addLocalSymbol(_ declaration: Declaration) throws {
        if localSymbolTable == nil {
            localSymbolTable = [String : Type] ()
        }
        
        guard localSymbolTable?[declaration.name] == nil else {
            throw TypeContextError.invalidRedeclarationOfLocalSymbol(declaration.name)
        }
        
        localSymbolTable?[declaration.name] = declaration.type
    }
    
    func setReturnType(_ type: Type) {
        returnType = type
    }
    
    func getReturnType() -> Type? {
        return returnType
    }
    
    func popLocalContext() {
        localSymbolTable = nil
        returnType = nil
    }
    
    func getSymbolType(_ symbolName: String) -> Type? {
        return (localSymbolTable?[symbolName]) ?? globalSymbolTable[symbolName]
    }
}
