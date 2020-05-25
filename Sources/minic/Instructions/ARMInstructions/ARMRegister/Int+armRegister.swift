//
//  Int+armRegister.swift
//  minic
//
//  Created by Ethan Kusters on 5/23/20.
//

import Foundation

extension IntegerLiteralType {
    var armRegister: ARMRegister {
        return .real(ARMRealRegister(integerLiteral: self))
    }
}
