//
//  Int+armRegister.swift
//  minic
//
//  Created by Ethan Kusters on 5/23/20.
//

import Foundation

extension IntegerLiteralType {
    func getARMRegister(_ context: CodeGenerationContext) -> ARMRegister {
        return context.getRegister(fromRealRegister: ARMRealRegister(integerLiteral: self))
    }
}
