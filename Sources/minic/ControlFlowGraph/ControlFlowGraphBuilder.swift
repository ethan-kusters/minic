//
//  ControlFlowGraphBuilder.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/23/20.
//

import Foundation

class ControlFlowGraphBuilder {
    var blocks = [Block]()
    private let function: Function
    private let context: TypeContext
    
    private lazy var functionEntry = {
        buildEntryBlock()
    }()
    
    private lazy var functionExit = {
       buildExitBlock()
    }()
    
    init(_ function: Function, context: TypeContext) {
        self.function = function
        self.context = context
        
        blocks.append(functionEntry)
        
        if let final = build(function.body, currentBlock: functionEntry) {
            link(final, functionExit)
            final.addInstruction(.unconditionalBranch(functionExit))
        }
        
        blocks.append(functionExit)
    }
    
    private func buildEntryBlock() -> Block {
        let entryBlock = Block("FunctionEntry")
        
        if function.retType != .void {
            entryBlock.addInstruction(.allocate(.localValue(LLVMInstructionConstants.returnPointer,
                                                                    type: function.retType.llvmType)))
        }
        
        let parameterInstructions = function.parameters.flatMap { param -> [LLVMInstruction] in
            let type = param.type.llvmType
            let allocateInstruction = LLVMInstruction.allocate(.localValue(param.name, type: type))
            
            let existingParamValue = LLVMValue.existingRegister(withId: LLVMInstructionConstants.parameterPrefix + param.name,
                                                                       type: type)
            
            let storeInstruction = LLVMInstruction.store(souce: existingParamValue,
                                                         destination: .localValue(param.name, type: type))
            
            return [allocateInstruction, storeInstruction]
        }
        
        entryBlock.addInstructions(parameterInstructions)
        
        let localAllocations = function.locals.map { local -> LLVMInstruction in
            .allocate(.localValue(local.name,
                                          type: local.type.llvmType))
        }
        
        entryBlock.addInstructions(localAllocations)
        
        return entryBlock
    }
    
    private func buildExitBlock() -> Block {
        let exitBlock = Block("FunctionExit")
        
        if function.retType == .void {
            exitBlock.addInstruction(.returnVoid)
        } else {
            let retType = function.retType.llvmType
            let retRegister = LLVMValue.newRegister(forType: retType)
            
            let load = LLVMInstruction.load(source: .localValue(LLVMInstructionConstants.returnPointer, type: retType),
                                        destination: retRegister)
            
            let ret = LLVMInstruction.returnValue(retRegister)
            
            exitBlock.addInstructions([load, ret])
        }
        
        return exitBlock
    }
    
    private func link(_ predecessor: Block, _ successor: Block) {
        predecessor.addSuccesor(successor)
        successor.addPredecessor(predecessor)
    }
    
    private func build(_ statement: Statement, currentBlock: Block) -> Block? {
        switch(statement) {
        case let .assignment(_, lValue, source):
            let (sourceInstructions, sourceValue) = source.getLLVMInstructions(context)
            currentBlock.addInstructions(sourceInstructions)
            
            if let leftExpression = lValue.leftExpression {
                let (leftInstructions, leftValue) = leftExpression.getLLVMInstructions(context)
                currentBlock.addInstructions(leftInstructions)
                
                let structTypeDeclaration = leftExpression.getStructFromDotExpression(context)
                
                let fieldIndex = structTypeDeclaration.fields.firstIndex(where: {
                    $0.name == lValue.id
                })!
                
                let fieldType = structTypeDeclaration.fields[fieldIndex].type.llvmType
                
                let ptrResult = LLVMValue.newRegister(forType: fieldType)
                let getPtrInstruction = LLVMInstruction.getElementPointer(structureType: .structureType(structTypeDeclaration.name),
                                                                      structurePointer: leftValue,
                                                                      elementIndex: fieldIndex,
                                                                      result: ptrResult)
                
                let setInstr = LLVMInstruction.store(souce: sourceValue,
                                                 destination: .localValue(ptrResult.identifier, type: ptrResult.type))
                
                currentBlock.addInstructions([getPtrInstruction, setInstr])
            } else {
                let pointer = context.getllvmIdentifier(from: lValue.id)
                currentBlock.addInstruction(.store(souce: sourceValue,
                                                   destination: pointer))
            }
            
            return currentBlock
        case let .block(_, statements):
            var block = currentBlock
            
            for statement in statements {
                guard let newBlock = build(statement, currentBlock: block) else {
                    return nil
                }
                
                block = newBlock
            }
            
            return block
        case let .conditional(_, guardExp, thenStmt, elseStmt):
            let (guardInstructions, guardValue) = guardExp.getLLVMInstructions(context)
            currentBlock.addInstructions(guardInstructions)
            
            let condExit = Block("CondExit")
            let thenEntry = Block("ThenEntry")
            
            link(currentBlock, thenEntry)
            blocks.append(thenEntry)
            
            if let thenExit = build(thenStmt, currentBlock: thenEntry) {
                link(thenExit, condExit)
                thenExit.addInstruction(.unconditionalBranch(condExit))
            }
            
            let ifBranch: [LLVMInstruction]
            
            if let elseStmt = elseStmt {
                let elseEntry = Block("ElseEntry")
                
                link(currentBlock, elseEntry)
                blocks.append(elseEntry)
                
                ifBranch = getConditionalBranch(conditional: guardValue,
                                                ifTrue: thenEntry,
                                                ifFalse: elseEntry)
                
                if let elseExit = build(elseStmt, currentBlock: elseEntry) {
                    link(elseExit, condExit)
                    elseExit.addInstruction(.unconditionalBranch(condExit))
                }
            } else {
                link(currentBlock, condExit)
                ifBranch = getConditionalBranch(conditional: guardValue,
                                                ifTrue: thenEntry,
                                                ifFalse: condExit)
            }
            
            currentBlock.addInstructions(ifBranch)
            
            if condExit.predecessors.count > 0 {
                blocks.append(condExit)
                return condExit
            } else {
                return nil
            }
        case let .delete(_, expression):
            let (instructions, value) = expression.getLLVMInstructions(context)
            currentBlock.addInstructions(instructions)
            
            let destinationReg = LLVMValue.newRegister(forType: .pointer(.i8))
            let cast = LLVMInstruction.bitcast(source: value,
                                           destination: destinationReg)
            
            let free = LLVMInstruction.call(returnType: .void,
                                        functionPointer: .function(LLVMInstructionConstants.freeFunction,
                                                                   retType: .void),
                                        arguments: [destinationReg],
                                        result: nil)
            
            currentBlock.addInstructions([cast, free])
            
            return currentBlock
        case let .invocation(_, expression):
            let expressionInstructions = expression.getLLVMInstructions(context).instructions
            currentBlock.addInstructions(expressionInstructions)
            
            return currentBlock
        case let .printLn(_, expression):
            let (instructions, value) = expression.getLLVMInstructions(context)
            currentBlock.addInstructions(instructions)
            currentBlock.addInstruction(.call(returnType: .void,
                                              functionPointer: .function(LLVMInstructionConstants.printlnHelperFunction,
                                                                         retType: .void),
                                        arguments: [value],
                                        result: nil))
            
            
            return currentBlock
        case let .print(_, expression):
            let (instructions, value) = expression.getLLVMInstructions(context)
            currentBlock.addInstructions(instructions)
            currentBlock.addInstruction(.call(returnType: .void,
                                              functionPointer: .function(LLVMInstructionConstants.printHelperFunction,
                                                                         retType: .void),
                                              arguments: [value],
                                              result: nil))
            
            return currentBlock
        case let .return(_, value):
            if let (instructions, value) = value?.getLLVMInstructions(context) {
                currentBlock.addInstructions(instructions)
                
                let retType = function.retType.llvmType
                
                currentBlock.addInstruction(.store(souce: value,
                                                   destination: .localValue(LLVMInstructionConstants.returnPointer,
                                                                        type: retType)))
            }
            
            link(currentBlock, functionExit)
            currentBlock.addInstruction(.unconditionalBranch(functionExit))
            
            return nil
        case let .while(_, guardExp, body):
            let (guardInstructions, guardValue) = guardExp.getLLVMInstructions(context)
            currentBlock.addInstructions(guardInstructions)
            
            let whileBodyEntry = Block("WhileBodyEntrance")
            let whileExit = Block("WhileExit")
            
            link(currentBlock, whileBodyEntry)
            link(currentBlock, whileExit)
            currentBlock.addInstructions(getConditionalBranch(conditional: guardValue,
                                                              ifTrue: whileBodyEntry,
                                                              ifFalse: whileExit))
            
            blocks.append(whileBodyEntry)
            
            if let whileBodyExit = build(body, currentBlock: whileBodyEntry) {
                let (secondGuardInstructions, secondGuardValue) = guardExp.getLLVMInstructions(context)
                whileBodyExit.addInstructions(secondGuardInstructions)
                
                link(whileBodyExit, whileBodyEntry)
                link(whileBodyExit, whileExit)
                whileBodyExit.addInstructions(getConditionalBranch(conditional: secondGuardValue,
                                                                   ifTrue: whileBodyEntry,
                                                                   ifFalse: whileExit))
            }
            
            blocks.append(whileExit)
            return whileExit
        }
    }
    
    func getConditionalBranch(conditional: LLVMValue, ifTrue: Block, ifFalse: Block) -> [LLVMInstruction] {
        guard conditional.type != .i1 else {
            return [.conditionalBranch(conditional: conditional, ifTrue: ifTrue, ifFalse: ifFalse)]
        }
        
        let castResult = LLVMValue.newRegister(forType: .i1)
        let castInstruction = LLVMInstruction.truncate(source: conditional,
                                                   destination: castResult)
        
        let branch = LLVMInstruction.conditionalBranch(conditional: castResult, ifTrue: ifTrue, ifFalse: ifFalse)
        return [castInstruction, branch]
    }
}
