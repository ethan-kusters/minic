//
//  InstructionBlock.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/23/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

protocol InstructionBlock: Hashable {
    associatedtype InstructionType: InstructionProtocol
    
    var uuid: UUID { get }
    var label: String { get }
    var instructions: [InstructionType] { get set }
    var predecessors: Set<Self> { get set }
    var successors: Set<Self> { get set }
    
    func addPredecessor(_ block: Self)
    
    func addSuccesor(_ block: Self)
    
    func addInstructions(_ newInstructions: [InstructionType])
    
    func addInstruction(_ newInstruction: InstructionType)
    
    func insertInstruction(_ newInstruction: InstructionType, at index: Int)
    
    func replaceInstruction(_ currentInstruction: InstructionType, with newInstruction: InstructionType)
    
}
