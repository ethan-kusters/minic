//
//  ARMExecutableSection+CustomStringConvertible.swift
//  minic
//
//  Created by Ethan Kusters on 5/25/20.
//

import Foundation

extension ARMExecutableSection: CustomStringConvertible {
    var description: String {
        switch(self) {
        case let .named(name):
            return ".section \(name)"
        case .instructions:
            return ".text"
        case .data:
            return ".data"
        case .readOnlyData:
            return ".rodata"
        case .uninitializedData:
            return ".bss"
        }
    }
}
