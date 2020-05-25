//
//  ARMImmediateValue.swift
//  minic
//
//  Created by Ethan Kusters on 5/24/20.
//

import Foundation

struct ARMImmediateValue: Hashable {
    let value: Int

    init(_ value: Int) {
        self.value = value
    }
}
