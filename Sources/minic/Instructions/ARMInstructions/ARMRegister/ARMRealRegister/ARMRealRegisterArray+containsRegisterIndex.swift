//
//  ARMRealRegisterArray+containsRegisterIndex.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

extension Array where Element == ARMRealRegister {
    func containsRegisterIndex(_ index: Int) -> Bool {
        compactMap { register in
            switch(register) {
            case let .generalPurpose(regIndex):
                return regIndex
            case .intraproceduralScratch:
                return 12
            case .framePointer:
                return nil
            case .stackPointer:
                return nil
            case .linkRegister:
                return nil
            case .programCounter:
                return nil
            case .applicationProgramStatusRegister:
                return nil
            }
        }.contains(index)
    }
}
