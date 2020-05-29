//
//  ARMRegister+assignRealRegister.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

extension ARMRegister {
    func assignRealRegister() {
        guard !(register is ARMRealRegister) else { return }
        
        
    }
}
