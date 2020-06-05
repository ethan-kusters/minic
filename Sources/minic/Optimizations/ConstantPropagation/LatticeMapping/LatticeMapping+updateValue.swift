//
//  LatticeMapping+updateValue.swift
//  minic
//
//  Created by Ethan Kusters on 6/4/20.
//

import Foundation

extension Dictionary where Key == LLVMVirtualRegister, Value == LatticeValue {
    mutating func setValue(_ ssaWorkList: inout [LLVMVirtualRegister],
                              for register: LLVMVirtualRegister, with value: LatticeValue?) {
        guard self[register] != value else { return }
        self[register] = value
        ssaWorkList.append(register)
    }
}
