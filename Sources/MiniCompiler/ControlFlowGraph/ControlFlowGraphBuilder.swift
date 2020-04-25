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
    
    private lazy var functionEntry = {
        buildEntryBlock()
    }()
    
    private lazy var functionExit = {
       buildExitBlock()
    }()
    
    init(_ function: Function) {
        self.function = function
        
        blocks.append(functionEntry)
        
        if let final = build(function.body, currentBlock: functionEntry) {
            link(final, functionExit)
        }
        
        blocks.append(functionExit)
    }
    
    private func buildEntryBlock() -> Block {
        return Block("FunctionEntry")
    }
    
    private func buildExitBlock() -> Block {
        return Block("FunctionExit")
    }
    
    private func link(_ predecessor: Block, _ successor: Block) {
        predecessor.addSuccesor(successor)
        successor.addPredecessor(predecessor)
    }
    
    private func build(_ statement: Statement, currentBlock: Block) -> Block? {
        switch(statement) {
        case .assignment:
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
            let condExit = Block("CondExit")
            let thenEntry = Block("ThenEntry")
            
            link(currentBlock, thenEntry)
            blocks.append(thenEntry)
            
            if let thenExit = build(thenStmt, currentBlock: thenEntry) {
                link(thenExit, condExit)
            }
            
            if let elseStmt = elseStmt {
                let elseEntry = Block("ElseEntry")
                link(currentBlock, elseEntry)
                blocks.append(elseEntry)
                
                if let elseExit = build(elseStmt, currentBlock: elseEntry) {
                    link(elseExit, condExit)
                }
            } else {
                link(currentBlock, condExit)
            }
            
            if condExit.predecessors.count > 0 {
                blocks.append(condExit)
                return condExit
            } else {
                return nil
            }
        case let .delete(_, expression):
            return currentBlock
        case let .invocation(_, expression):
            return currentBlock
        case let .printLn(_, expression), let .print(_, expression):
            return currentBlock
        case .return:
            link(currentBlock, functionExit)
            return nil
        case let .while(lineNumber, guardExp, body):
            let whileBodyEntry = Block("WhileBodyEntrance")
            let whileExit = Block("WhileExit")
            
            link(currentBlock, whileBodyEntry)
            link(currentBlock, whileExit)
            
            blocks.append(whileBodyEntry)
            
            if let whileBodyExit = build(body, currentBlock: whileBodyEntry) {
                link(whileBodyExit, whileBodyEntry)
                link(whileBodyExit, whileExit)
            }
            
            blocks.append(whileExit)
            return whileExit
        }
    }
}
