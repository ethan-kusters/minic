//
//  ControlFlowGraph+registers.swift
//  minic
//
//  Created by Ethan Kusters on 6/3/20.
//

import Foundation

extension LLVMControlFlowGraph {
    var virtualRegisters: Set<LLVMVirtualRegister> {
        blocks.union { block in
            block.instructions.union { llvmInstruction in
                Set(llvmInstruction.registers)
            }
        }
    }
}
