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
            final.addInstruction(.unconditionalBranch(destination: functionExit))
        }
        
        blocks.append(functionExit)
    }
    
    private func buildEntryBlock() -> Block {
        let entryBlock = Block("FunctionEntry")
        
        if function.retType != .void {
            entryBlock.addInstruction(.allocate(type: function.retType.equivalentInstructionType,
                                                result: .localValue(InstructionConstants.returnPointer,
                                                                    type: function.retType.equivalentInstructionType)))
        }
        
        let parameterInstructions = function.parameters.flatMap { param -> [Instruction] in
            let type = param.type.equivalentInstructionType
            let allocateInstruction = Instruction.allocate(type: type,
                                                           result: .localValue(param.name, type: type))
            
            let existingParamValue = InstructionValue.existingRegister(withId: InstructionConstants.parameterPrefix + param.name,
                                                                       type: type)
            
            let storeInstruction = Instruction.store(valueType: type,
                                                     value: existingParamValue,
                                                     pointerType: type,
                                                     pointer: .localValue(param.name, type: type))
            
            return [allocateInstruction, storeInstruction]
        }
        
        entryBlock.addInstructions(parameterInstructions)
        
        let localAllocations = function.locals.map { local -> Instruction in
            .allocate(type: local.type.equivalentInstructionType,
                      result: .localValue(local.name,
                                          type: local.type.equivalentInstructionType))
        }
        
        entryBlock.addInstructions(localAllocations)
        
        return entryBlock
    }
    
    private func buildExitBlock() -> Block {
        let exitBlock = Block("FunctionExit")
        
        if function.retType == .void {
            exitBlock.addInstruction(.returnVoid)
        } else {
            let retType = function.retType.equivalentInstructionType
            let retRegister = InstructionValue.newRegister(forType: retType)
            
            let load = Instruction.load(valueType: retType,
                                        pointerType: retType,
                                        pointer: .localValue(InstructionConstants.returnPointer, type: retType),
                                        result: retRegister)
            
            let ret = Instruction.returnValue(type: retType, value: retRegister)
            
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
            let (sourceInstructions, sourceValue) = source.getEquivalentInstructions(context)
            currentBlock.addInstructions(sourceInstructions)
            
            if let leftExpression = lValue.leftExpression {
                let (leftInstructions, leftValue) = leftExpression.getEquivalentInstructions(context)
                currentBlock.addInstructions(leftInstructions)
                
                let structTypeDeclaration: TypeDeclaration
                
                if case let .identifier(_, id) = leftExpression {
                    let structPointer = context.getInstructionPointer(from: id)
                    
                    guard case let .structure(name: name) = structPointer.type else {
                        fatalError("Type checker should have caught this. Dot access on not-struct value.")
                    }
                    
                    structTypeDeclaration = context.getStruct(name)!
                } else if case let .dot(_, left, id) = leftExpression {
                    var idChain = [id]
                    var currentLeft: Expression = left
                    while case let .dot(_, left, id) = currentLeft {
                        currentLeft = left
                        idChain.append(id)
                    }
                    
                    guard case let .identifier(_, baseID) = currentLeft else { fatalError() }
                    
                    let structPointer = context.getInstructionPointer(from: baseID)
                    
                    guard case let .structure(name: baseStructTypeName) = structPointer.type else {
                        fatalError("Type checker should have caught this. Dot access on not-struct value.")
                    }
                    
                    var currentStruct = context.getStruct(baseStructTypeName)!
                    
                    idChain.reversed().forEach { id in
                        let currentStructPointer = currentStruct.fields[id]!.type.equivalentInstructionType
                        
                        guard case let .structure(name: currentStructName) = currentStructPointer else {
                            fatalError("Type checker should have caught this. Dot access on not-struct value.")
                        }
                        
                        currentStruct = context.getStruct(currentStructName)!
                    }
                    
                    structTypeDeclaration = currentStruct
                } else {
                    fatalError("Type checker should have caught this. Dot access on non-identifier value.")
                }
                
                let fieldIndex = structTypeDeclaration.fields.firstIndex(where: {
                    $0.name == lValue.id
                })!
                
                let fieldType = structTypeDeclaration.fields[fieldIndex].type.equivalentInstructionType
                
                let ptrResult = InstructionValue.newRegister(forType: fieldType)
                let getPtrInstruction = Instruction.getElementPointer(structureType: .structureType(structTypeDeclaration.name),
                                                                      structurePointer: leftValue,
                                                                      elementIndex: fieldIndex,
                                                                      result: ptrResult)
                
                let setInstr = Instruction.store(valueType: fieldType,
                                                 value: sourceValue,
                                                 pointerType: ptrResult.type,
                                                 pointer: .localValue(ptrResult.identifier, type: ptrResult.type))
                
                currentBlock.addInstructions([getPtrInstruction, setInstr])
            } else {
                let pointer = context.getInstructionPointer(from: lValue.id)
                currentBlock.addInstruction(.store(valueType: sourceValue.type,
                                                   value: sourceValue,
                                                   pointerType: pointer.type,
                                                   pointer: pointer))
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
            let (guardInstructions, guardValue) = guardExp.getEquivalentInstructions(context)
            currentBlock.addInstructions(guardInstructions)
            
            let condExit = Block("CondExit")
            let thenEntry = Block("ThenEntry")
            
            link(currentBlock, thenEntry)
            blocks.append(thenEntry)
            
            if let thenExit = build(thenStmt, currentBlock: thenEntry) {
                link(thenExit, condExit)
                thenExit.addInstruction(.unconditionalBranch(destination: condExit))
            }
            
            let ifBranch: [Instruction]
            
            if let elseStmt = elseStmt {
                let elseEntry = Block("ElseEntry")
                
                link(currentBlock, elseEntry)
                blocks.append(elseEntry)
                
                ifBranch = getConditionalBranch(conditional: guardValue,
                                                ifTrue: thenEntry,
                                                ifFalse: elseEntry)
                
                if let elseExit = build(elseStmt, currentBlock: elseEntry) {
                    link(elseExit, condExit)
                    elseExit.addInstruction(.unconditionalBranch(destination: condExit))
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
            let (instructions, value) = expression.getEquivalentInstructions(context)
            currentBlock.addInstructions(instructions)
            
            let destinationReg = InstructionValue.newRegister(forType: .pointer(.i8))
            let cast = Instruction.bitcast(currentType: value.type,
                                           value: value,
                                           destinationType: destinationReg.type,
                                           result: destinationReg)
            
            let free = Instruction.call(returnType: .void,
                                        functionPointer: .function(InstructionConstants.freeFunction,
                                                                   retType: .void),
                                        arguments: [destinationReg],
                                        result: nil)
            
            currentBlock.addInstructions([cast, free])
            
            return currentBlock
        case let .invocation(_, expression):
            let expressionInstructions = expression.getEquivalentInstructions(context).instructions
            currentBlock.addInstructions(expressionInstructions)
            
            return currentBlock
        case let .printLn(_, expression):
            let (instructions, value) = expression.getEquivalentInstructions(context)
            currentBlock.addInstructions(instructions)
            currentBlock.addInstruction(.call(returnType: .void,
                                              functionPointer: .function(InstructionConstants.printlnHelperFunction,
                                                                         retType: .void),
                                        arguments: [value],
                                        result: nil))
            
            
            return currentBlock
        case let .print(_, expression):
            let (instructions, value) = expression.getEquivalentInstructions(context)
            currentBlock.addInstructions(instructions)
            currentBlock.addInstruction(.call(returnType: .void,
                                              functionPointer: .function(InstructionConstants.printHelperFunction,
                                                                         retType: .void),
                                              arguments: [value],
                                              result: nil))
            
            return currentBlock
        case let .return(_, value):
            if let (instructions, value) = value?.getEquivalentInstructions(context) {
                currentBlock.addInstructions(instructions)
                
                let retType = function.retType.equivalentInstructionType
                
                currentBlock.addInstruction(.store(valueType: value.type,
                                                   value: value,
                                                   pointerType: retType,
                                                   pointer: .localValue(InstructionConstants.returnPointer,
                                                                        type: retType)))
            }
            
            link(currentBlock, functionExit)
            currentBlock.addInstruction(.unconditionalBranch(destination: functionExit))
            
            return nil
        case let .while(_, guardExp, body):
            let (guardInstructions, guardValue) = guardExp.getEquivalentInstructions(context)
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
                let (secondGuardInstructions, secondGuardValue) = guardExp.getEquivalentInstructions(context)
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
    
    func getConditionalBranch(conditional: InstructionValue, ifTrue: Block, ifFalse: Block) -> [Instruction] {
        guard conditional.type != .i1 else {
            return [.conditionalBranch(conditional: conditional, ifTrue: ifTrue, ifFalse: ifFalse)]
        }
        
        let castResult = InstructionValue.newRegister(forType: .i1)
        let castInstruction = Instruction.truncate(currentType: conditional.type,
                                                   value: conditional,
                                                   destinationType: castResult.type,
                                                   result: castResult)
        
        let branch = Instruction.conditionalBranch(conditional: castResult, ifTrue: ifTrue, ifFalse: ifFalse)
        return [castInstruction, branch]
    }
}