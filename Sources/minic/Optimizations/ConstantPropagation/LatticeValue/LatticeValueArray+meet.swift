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
        
        forEach { value in
            switch(currentValue, value) {
            case let (.constant(lhs), .constant(rhs)):
                guard lhs == rhs else {
                    currentValue = .bottom
                    return
                }
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
