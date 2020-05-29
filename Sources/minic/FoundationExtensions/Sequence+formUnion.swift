//
//  Sequence+union.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

extension Array {
    func formUnion<T>(_ transform: (Self.Element) throws -> Set<T>) rethrows -> Set<T> {
        guard isEmpty == false else { return [] }

        var result = Set<T>()

        try forEach { element in
            let transform = try transform(element)
            result.formUnion(transform)
        }
        
        return result
    }
}
