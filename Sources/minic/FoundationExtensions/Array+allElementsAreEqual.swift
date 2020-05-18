//
//  Array+allElementsAreEqual.swift
//  minic
//
//  Created by Ethan Kusters on 5/15/20.
//

import Foundation

extension Array where Element: Equatable {
    func allElementsAreEqual() -> Bool {
        guard let firstElement = first else { return true }
        
        for currentElement in self {
            guard firstElement == currentElement else { return false }
        }
        
        return true
    }
}
