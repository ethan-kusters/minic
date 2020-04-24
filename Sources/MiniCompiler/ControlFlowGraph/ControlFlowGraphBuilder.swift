//
//  ControlFlowGraphBuilder.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/23/20.
//

import Foundation

class ControlFlowGraphBuilder {
    var blocks: [Block]
    private let function: Function
    
    private let entryBlock: Block
    private let returnBlock: Block
    
    private var labelIndex = -1
    
    init(_ function: Function) {
        entryBlock = constructEntryBlock()
        returnBlock = constructReturnBlock()
        
        blocks.append(entryBlock)
        _ = build(function.body, currentBlock: entryBlock)
    }
    
    private func constructEntryBlock() -> Block {
        return Block("'\(function.name)' Entry Block", instructions: [])
    }
    
    private func constructReturnBlock() -> Block {
        return Block("'\(function.name)' Return Block", instructions: [])
    }
    
    private func link(_ predecessor: Block, _ successor: Block) {
        predecessor.addSuccesor(successor)
        successor.addPredecessor(predecessor)
    }
    
    
    private func build(_ statement: Statement, currentBlock: Block) -> Block? {
        switch(statement) {
        case .assignment:
            
        case let .block(_, statements):
            var currentBlock = currentBlock
            
            for statement in statements {
                guard let newBlock = build(statement, currentBlock: currentBlock) else {
                    return nil
                }
                
                blocks.append(newBlock)
                
                link(currentBlock, newBlock)
                currentBlock = newBlock
            }
            
            return currentBlock
        case let .conditional(_, guardExp, thenStmt, elseStmt):
            let condExit = Block("CondExit")
            let thenEntry = Block("ThenEntry")
            let elseEntry = Block("ElseEntry")
            
            link(currentBlock, thenEntry)
            blocks.append(thenEntry)
            
            link(currentBlock, elseEntry)
            blocks.append(elseEntry)
            
            if let thenExit = build(thenStmt, currentBlock: thenEntry) {
                link(thenExit, condExit)
            }
            
            if let elseExit = build(elseStmt, currentBlock: elseEntry) {
                link(elseExit, condExit)
            }
        case let .delete(_, expression):
            
        case let .invocation(_, expression):
            
        case let .printLn(_, expression), let .print(_, expression):
            
        case .return:
            
        case let .while(lineNumber, guardExp, body):
            
        }
    }
}
