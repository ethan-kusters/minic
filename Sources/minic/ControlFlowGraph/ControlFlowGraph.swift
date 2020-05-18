//
//  ControlFlowGraph.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/23/20.
//

import Foundation

protocol ControlFlowGraph {
    associatedtype instructionType where instructionType: InstructionProtocol
    var blocks: [InstructionBlock<instructionType>] { get set }
    var function: Function { get }
    var context: TypeContext { get }
    
    func link(_ predecessor: InstructionBlock<instructionType>, _ successor: InstructionBlock<instructionType>)
}

extension ControlFlowGraph {
    func link(_ predecessor: InstructionBlock<instructionType>, _ successor: InstructionBlock<instructionType>) {
        predecessor.addSuccesor(successor)
        successor.addPredecessor(predecessor)
    }
}
