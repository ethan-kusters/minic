//
//  GraphEdge.swift
//  minic
//
//  Created by Ethan Kusters on 6/3/20.
//

import Foundation

struct GraphEdge {
    let source: LLVMInstructionBlock
    let destination: LLVMInstructionBlock
    
    var executable: Bool {
        get {
            destination.incomingEdgeIsExecutable[source]!
        }
    }
    
    init(from source: LLVMInstructionBlock, to destination: LLVMInstructionBlock) {
        self.source = source
        self.destination = destination
    }
    
    func makeExecutable() {
        destination.incomingEdgeIsExecutable[source] = true
    }
}

