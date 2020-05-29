//
//  ARMRealRegister+index.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

extension ARMRealRegister {
    var index: Int {
        switch(self) {
        case let .generalPurpose(index):
            return index
        case .intraproceduralScratch:
            return 12
        case .framePointer:
            return 11
        case .stackPointer:
            return 13
        case .linkRegister:
            return 14
        case .programCounter:
            return 15
        case .applicationProgramStatusRegister:
            return 16
        }
    }
}
