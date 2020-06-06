//
//  LatticeValueArray+meet.swift
//  minic
//
//  Created by Ethan Kusters on 6/4/20.
//

import Foundation

extension Array where Element == LatticeValue {
    func meet() -> LatticeValue {
        guard var currentValue = first else { return .top }
        
        forEach { newValue in
            switch(currentValue, newValue) {
            case let (.constant(currentValueConstant), .constant(newValueConstant)):
                guard currentValueConstant == newValueConstant else {
                    currentValue = .bottom
                    return
                }
            case let (.top, .constant(newValueConstant)):
                currentValue = .constant(newValueConstant)
            case (_, .bottom):
                currentValue = .bottom
            case (_, .top):
                return
            default:
                return
            }
        }
        
        return currentValue
    }
}
