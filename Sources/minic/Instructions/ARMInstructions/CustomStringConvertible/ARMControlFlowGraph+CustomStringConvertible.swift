//
//  ARMControlFlowGraph+CustomStringConvertible.swift
//  minic
//
//  Created by Ethan Kusters on 5/25/20.
//

import Foundation

extension ARMControlFlowGraph: CustomStringConvertible {
    var description: String {
        instructions.map(\.description).joined(separator: "\n")
    }
}
