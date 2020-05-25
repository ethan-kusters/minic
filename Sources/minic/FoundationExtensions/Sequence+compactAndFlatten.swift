//
//  Sequence+compactAndFlatten.swift
//  minic
//
//  Created by Ethan Kusters on 5/23/20.
//

import Foundation

extension Sequence {
    func compact<ElementOfResult>() -> [ElementOfResult] where Element == Optional<ElementOfResult> {
        return compactMap({$0})
    }
    
    func flatten<ElementOfResult>() -> [ElementOfResult] where Element == [ElementOfResult] {
        return flatMap({$0})
    }
    
    func compactAndFlatten<ElementOfResult>() -> [ElementOfResult] where Element == Optional<[ElementOfResult]> {
        return compactMap({$0}).flatMap({$0})
    }
}
