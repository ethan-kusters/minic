//
//  ARMControlFlowGraph+registers.swift
//  minic
//
//  Created by Ethan Kusters on 6/8/20.
//

import Foundation

extension ARMControlFlowGraph {
    var registers: Set<ARMRegister> {
        return blocks.flatMap(\.instructions).union { instruction in
            Set(instruction.registers)
        }
    }
}
