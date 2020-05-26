//
//  LLVMVirtualRegister+getARMRegister.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

extension LLVMVirtualRegister {
    func getARMRegister(_ context: CodeGenerationContext) -> ARMRegister {
        context.getRegister(fromVirtualRegister: self)
    }
}
