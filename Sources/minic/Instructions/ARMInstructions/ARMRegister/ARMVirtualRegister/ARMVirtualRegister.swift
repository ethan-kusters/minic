//
//  ARMVirtualRegister.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

struct ARMVirtualRegister: ARMRegisterProtocol {
    let label: String
    
    init(_ label: String) {
        self.label = label
    }
}
