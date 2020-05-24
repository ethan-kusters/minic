//
//  ARMRegister.swift
//  minic
//
//  Created by Ethan Kusters on 5/18/20.
//

import Foundation

enum ARMRegister: Hashable {
    case virtual(LLVMVirtualRegister)
    case real(ARMRealRegister)
}
