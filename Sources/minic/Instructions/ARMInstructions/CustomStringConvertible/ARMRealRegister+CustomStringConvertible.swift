//
//  ARMRealRegister+CustomStringConvertible.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

extension ARMRealRegister: CustomStringConvertible {
    var description: String {
        switch (self) {
        case let .generalPurpose(registerIndex):
            return "r\(registerIndex)"
        case .intraproceduralScratch:
            return "r12"
        case .framePointer:
            return "r11"
        case .stackPointer:
            return "sp"
        case .linkRegister:
            return "lr"
        case .programCounter:
            return "pc"
        case .applicationProgramStatusRegister:
            return "apsr"
        }
    }
}
