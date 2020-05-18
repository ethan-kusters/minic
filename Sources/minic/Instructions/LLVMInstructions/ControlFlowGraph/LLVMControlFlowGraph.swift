//
//  LLVMControlFlowGraph.swift
//  minic
//
//  Created by Ethan Kusters on 5/18/20.
//

import Foundation

class LLVMControlFlowGraph: ControlFlowGraph {
    typealias instructionType = LLVMInstruction
    
    var blocks = [InstructionBlock<instructionType>]()
    let function: Function
    let context: TypeContext
    let ssaEnabled: Bool
    
    init(_ function: Function, context: TypeContext, useSSA: Bool) {
        self.function = function
        self.context = context
        self.ssaEnabled = useSSA
        
        blocks.append(functionEntry)
        
        if let final = build(function.body, currentBlock: functionEntry) {
            link(final, functionExit)
            final.addInstruction(.unconditionalBranch(functionExit.llvmIdentifier, block: final))
        }
        
        functionExit.seal()
        buildExitBlock(functionExit)
        blocks.append(functionExit)
        
        if useSSA {
            blocks.removeTrivialPhis()
        }
    }
    
    private lazy var functionEntry = {
        buildEntryBlock()
    }()
    
    private lazy var functionExit = {
       InstructionBlock("FunctionExit", sealed: false)
    }()
    
    private func buildEntryBlock() -> InstructionBlock<LLVMInstruction> {
        let entryBlock = InstructionBlock("FunctionEntry")
        
        if ssaEnabled {
            buildEntryBlockWithSSA(entryBlock)
        } else {
            buildEntryBlockWithoutSSA(entryBlock)
        }
        
        return entryBlock
    }
    
    private func buildEntryBlockWithoutSSA(_ entryBlock: InstructionBlock<LLVMInstruction>) {
        if function.retType != .void {
            let retValReg = LLVMVirtualRegister(withId: LLVMInstructionConstants.returnPointer,
                                                type: function.retType.llvmType)
            
            let allocRetInstr = LLVMInstruction.allocate(target: retValReg, block: entryBlock).logRegisterUses()
            entryBlock.addInstruction(allocRetInstr)
        }
        
        let parameterInstructions = function.parameters.flatMap { param -> [LLVMInstruction] in
            let paramReg = LLVMVirtualRegister(withId: param.name, type: param.type.llvmType)
            let existingParam = LLVMVirtualRegister(withId: LLVMInstructionConstants.parameterPrefix + param.name,
                                                     type: param.type.llvmType)
            
            /// We manually set the def instruction for the parameter since LLVM defined it
            existingParam.setDefiningInstruction(LLVMInstruction.allocate(target: existingParam, block: entryBlock))
            
            let allocateInstruction = LLVMInstruction.allocate(target: paramReg,
                                                               block: entryBlock).logRegisterUses()
            
            let storeInstruction = LLVMInstruction.store(source: .register(existingParam),
                                                         destPointer: paramReg.identifier,
                                                         block: entryBlock).logRegisterUses()
            
            return [allocateInstruction, storeInstruction]
        }
        
        entryBlock.addInstructions(parameterInstructions)
        
        let localAllocations = function.locals.map { local -> LLVMInstruction in
            let paramReg = LLVMVirtualRegister(withId: local.name,
                                               type: local.type.llvmType)
            
            return LLVMInstruction.allocate(target: paramReg,
                                            block: entryBlock).logRegisterUses()
        }
        
        entryBlock.addInstructions(localAllocations)
    }
    
    private func buildEntryBlockWithSSA(_ entryBlock: InstructionBlock<LLVMInstruction>) {
        if function.retType != .void {
            let retReg = LLVMVirtualRegister(withId: LLVMInstructionConstants.returnPointer, type: function.retType.llvmType)
            
            entryBlock.writeVariable(retReg.identifier, asValue: .null(function.retType.llvmType))
        }
        
        function.parameters.forEach { param  in
            let existingParam = LLVMVirtualRegister(withId: param.name,
                                                    type: param.type.llvmType)
            
            existingParam.setDefiningInstruction(LLVMInstruction.allocate(target: existingParam, block: entryBlock))
            
            entryBlock.writeVariable(existingParam.identifier, asValue: .register(existingParam))
        }
        
        
        function.locals.forEach { local in
            let localID = LLVMVirtualRegister(withId: local.name,
                                              type: local.type.llvmType)
            
            entryBlock.writeVariable(localID.identifier, asValue: localID.type.unitializedValue)
        }
    }
    
    private func buildExitBlock(_ exitBlock: InstructionBlock<LLVMInstruction>) {
        if function.retType == .void {
            exitBlock.addInstruction(.returnVoid(block: exitBlock))
        } else if ssaEnabled {
            buildExitBlockWithSSA(exitBlock)
        } else {
            buildExitBlockWithoutSSA(exitBlock)
        }
    }
    
    private func buildExitBlockWithoutSSA(_ exitBlock: InstructionBlock<LLVMInstruction>) {
        let retType = function.retType.llvmType
        let returnReg = LLVMVirtualRegister(ofType: retType)
        let retValPointer = LLVMVirtualRegister(withId: LLVMInstructionConstants.returnPointer,
                                                type: retType)
        
        let loadInstr = LLVMInstruction.load(target: returnReg,
                                             srcPointer: retValPointer.identifier,
                                             block: exitBlock).logRegisterUses()
        
        let returnInstr = LLVMInstruction.returnValue(.register(returnReg),
                                                      block: exitBlock).logRegisterUses()
        
        exitBlock.addInstructions([loadInstr, returnInstr])
    }
    
    private func buildExitBlockWithSSA(_ exitBlock: InstructionBlock<LLVMInstruction>) {
        let retType = function.retType.llvmType
        let returnValID = LLVMVirtualRegister(withId: LLVMInstructionConstants.returnPointer,
                                              type: retType)
        
        let returnValue = exitBlock.readVariable(returnValID.identifier)
        let returnInstr = LLVMInstruction.returnValue(returnValue, block: exitBlock).logRegisterUses()
        exitBlock.addInstruction(returnInstr)
    }
    
    private func build(_ statement: Statement, currentBlock: InstructionBlock<LLVMInstruction>) -> InstructionBlock<LLVMInstruction>? {
        switch(statement) {
        case let .assignment(_, lValue, source):
            var (sourceInstructions, sourceValue) = source.getLLVMInstructions(withContext: context, forBlock: currentBlock, usingSSA: ssaEnabled)
            currentBlock.addInstructions(sourceInstructions)
            
            if sourceValue.type == .i1 {
                // We need to zext this value as it was the result of a icmp
                let extTargetReg = LLVMVirtualRegister.newBoolRegister()
                let extInstr = LLVMInstruction.zeroExtend(target: extTargetReg,
                                                          source: sourceValue,
                                                          block: currentBlock).logRegisterUses()
                
                currentBlock.addInstruction(extInstr)
                sourceValue = .register(extTargetReg)
            }
            
            if let leftExpression = lValue.leftExpression {
                let (leftInstructions, leftValue) = leftExpression.getLLVMInstructions(withContext: context, forBlock: currentBlock, usingSSA: ssaEnabled)
                currentBlock.addInstructions(leftInstructions)
                
                let structTypeDeclaration = leftExpression.getStructFromDotExpression(context)
                
                let fieldIndex = structTypeDeclaration.fields.firstIndex(where: {
                    $0.name == lValue.id
                })!
                
                let fieldType = structTypeDeclaration.fields[fieldIndex].type.llvmType
                
                let getPtrTargetReg = LLVMVirtualRegister(ofType: fieldType)
                let getPtrInstruction = LLVMInstruction.getElementPointer(target: getPtrTargetReg,
                                                                          structureType: .structureType(structTypeDeclaration.name),
                                                                          structurePointer: leftValue.identifier,
                                                                          elementIndex: fieldIndex,
                                                                          block: currentBlock).logRegisterUses()
                
                let storeInstr = LLVMInstruction.store(source: sourceValue,
                                                       destPointer: getPtrTargetReg.identifier,
                                                       block: currentBlock).logRegisterUses()
                
                currentBlock.addInstructions([getPtrInstruction, storeInstr])
            } else {
                let identifier = context.getllvmIdentifier(from: lValue.id)
                
                if ssaEnabled, case .virtualRegister = identifier {
                    currentBlock.writeVariable(identifier, asValue: sourceValue)
                } else {
                    let storeInstr = LLVMInstruction.store(source: sourceValue,
                                                           destPointer: identifier,
                                                           block: currentBlock).logRegisterUses()
                    
                    currentBlock.addInstruction(storeInstr)
                }
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
            let (guardInstructions, guardValue) = guardExp.getLLVMInstructions(withContext: context, forBlock: currentBlock, usingSSA: ssaEnabled)
            currentBlock.addInstructions(guardInstructions)
            
            let condExit = InstructionBlock("CondExit")
            let thenEntry = InstructionBlock("ThenEntry")
            
            link(currentBlock, thenEntry)
            blocks.append(thenEntry)
            
            if let thenExit = build(thenStmt, currentBlock: thenEntry) {
                link(thenExit, condExit)
                thenExit.addInstruction(.unconditionalBranch(condExit.llvmIdentifier, block: thenExit))
            }
            
            let ifBranch: [LLVMInstruction]
            
            if let elseStmt = elseStmt {
                let elseEntry = InstructionBlock("ElseEntry")
                
                link(currentBlock, elseEntry)
                blocks.append(elseEntry)
                
                ifBranch = getConditionalBranch(conditional: guardValue,
                                                ifTrue: thenEntry.llvmIdentifier,
                                                ifFalse: elseEntry.llvmIdentifier,
                                                block: currentBlock)
                
                if let elseExit = build(elseStmt, currentBlock: elseEntry) {
                    link(elseExit, condExit)
                    elseExit.addInstruction(.unconditionalBranch(condExit.llvmIdentifier, block: elseExit))
                }
            } else {
                link(currentBlock, condExit)
                ifBranch = getConditionalBranch(conditional: guardValue,
                                                ifTrue: thenEntry.llvmIdentifier,
                                                ifFalse: condExit.llvmIdentifier,
                                                block: currentBlock)
            }
            
            currentBlock.addInstructions(ifBranch)
            
            if condExit.predecessors.count > 0 {
                blocks.append(condExit)
                return condExit
            } else {
                return nil
            }
        case let .delete(_, expression):
            let (instructions, value) = expression.getLLVMInstructions(withContext: context, forBlock: currentBlock, usingSSA: ssaEnabled)
            currentBlock.addInstructions(instructions)
            
            let castTargetReg = LLVMVirtualRegister(ofType: .pointer(.i8))
            let castInstr = LLVMInstruction.bitcast(target: castTargetReg,
                                                    source: value,
                                                    block: currentBlock).logRegisterUses()
            
            let freeFuncId = LLVMIdentifier.function(LLVMInstructionConstants.freeFunction,
                                                     retType: .void)
            
            let freeInstr = LLVMInstruction.call(target: nil,
                                                 functionIdentifier: freeFuncId,
                                                 arguments: [.register(castTargetReg)],
                                                 block: currentBlock).logRegisterUses()
            
            currentBlock.addInstructions([castInstr, freeInstr])
            
            return currentBlock
        case let .invocation(_, expression):
            let expressionInstructions = expression.getLLVMInstructions(withContext: context, forBlock: currentBlock, usingSSA: ssaEnabled).instructions
            currentBlock.addInstructions(expressionInstructions)
            
            return currentBlock
        case let .printLn(_, expression):
            let (instructions, value) = expression.getLLVMInstructions(withContext: context, forBlock: currentBlock, usingSSA: ssaEnabled)
            currentBlock.addInstructions(instructions)
            
            let printlnFuncId = LLVMIdentifier.function(LLVMInstructionConstants.printlnHelperFunction,
                                                        retType: .void)
            
            let printlnCallInstr = LLVMInstruction.call(target: nil,
                                                        functionIdentifier: printlnFuncId,
                                                        arguments: [value],
                                                        block: currentBlock).logRegisterUses()
            
            currentBlock.addInstruction(printlnCallInstr)
            
            return currentBlock
        case let .print(_, expression):
            let (instructions, value) = expression.getLLVMInstructions(withContext: context, forBlock: currentBlock, usingSSA: ssaEnabled)
            currentBlock.addInstructions(instructions)
            
            let printFuncId = LLVMIdentifier.function(LLVMInstructionConstants.printHelperFunction,
                                                      retType: .void)
            
            let printlnCallInstr = LLVMInstruction.call(target: nil,
                                                        functionIdentifier: printFuncId,
                                                        arguments: [value],
                                                        block: currentBlock).logRegisterUses()
            
            currentBlock.addInstruction(printlnCallInstr)
            
            return currentBlock
        case let .return(_, value):
            if let (instructions, value) = value?.getLLVMInstructions(withContext: context,
                                                                      forBlock: currentBlock,
                                                                      usingSSA: ssaEnabled) {
                currentBlock.addInstructions(instructions)
                
                let returnValId = LLVMVirtualRegister(withId: LLVMInstructionConstants.returnPointer,
                                                      type: function.retType.llvmType)
                
                if ssaEnabled {
                    currentBlock.writeVariable(returnValId.identifier, asValue: value)
                } else {
                    let storeInstr = LLVMInstruction.store(source:value,
                                                           destPointer: returnValId.identifier,
                                                           block: currentBlock).logRegisterUses()
                    
                    currentBlock.addInstruction(storeInstr)
                }
            }
            
            link(currentBlock, functionExit)
            currentBlock.addInstruction(.unconditionalBranch(functionExit.llvmIdentifier, block: currentBlock))
            
            return nil
        case let .while(_, guardExp, body):
            let (guardInstructions, guardValue) = guardExp.getLLVMInstructions(withContext: context, forBlock: currentBlock, usingSSA: ssaEnabled)
            currentBlock.addInstructions(guardInstructions)
            
            let whileBodyEntry = InstructionBlock("WhileBodyEntrance", sealed: false)
            let whileExit = InstructionBlock("WhileExit", sealed: false)
            
            link(currentBlock, whileBodyEntry)
            link(currentBlock, whileExit)
            currentBlock.addInstructions(getConditionalBranch(conditional: guardValue,
                                                              ifTrue: whileBodyEntry.llvmIdentifier,
                                                              ifFalse: whileExit.llvmIdentifier,
                                                              block: currentBlock))
            
            blocks.append(whileBodyEntry)
            
            if let whileBodyExit = build(body, currentBlock: whileBodyEntry) {
                link(whileBodyExit, whileBodyEntry)
                link(whileBodyExit, whileExit)
                whileBodyEntry.seal()
                whileExit.seal()
                
                let (secondGuardInstructions, secondGuardValue) = guardExp.getLLVMInstructions(withContext: context, forBlock: whileBodyExit, usingSSA: ssaEnabled)
                whileBodyExit.addInstructions(secondGuardInstructions)
                
                whileBodyExit.addInstructions(getConditionalBranch(conditional: secondGuardValue,
                                                                   ifTrue: whileBodyEntry.llvmIdentifier,
                                                                   ifFalse: whileExit.llvmIdentifier,
                                                                   block: whileBodyExit))
            }
            
            whileBodyEntry.seal()
            whileExit.seal()
            
            blocks.append(whileExit)
            return whileExit
        }
    }
    
    func getConditionalBranch(conditional: LLVMValue,
                              ifTrue: LLVMIdentifier,
                              ifFalse: LLVMIdentifier,
                              block: InstructionBlock<instructionType>) -> [LLVMInstruction] {
        guard conditional.type != .i1 else {
            let brInstr = LLVMInstruction.conditionalBranch(conditional: conditional,
                                                            ifTrue: ifTrue,
                                                            ifFalse: ifFalse,
                                                            block: block).logRegisterUses()
            return [brInstr]
        }
        
        let castTargetReg = LLVMVirtualRegister(ofType: .i1)
        let castInstruction = LLVMInstruction.truncate(target: castTargetReg,
                                                       source: conditional,
                                                       block: block).logRegisterUses()
        
        let branch = LLVMInstruction.conditionalBranch(conditional: .register(castTargetReg),
                                                       ifTrue: ifTrue,
                                                       ifFalse: ifFalse,
                                                       block: block).logRegisterUses()
        
        return [castInstruction, branch]
    }
}
