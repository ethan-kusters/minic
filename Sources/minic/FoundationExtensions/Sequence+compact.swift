//
//  Sequence+compact.swift
//  minic
//
//  Created by Ethan Kusters on 5/23/20.
//

import Foundation

extension Sequence {
    func compact<ElementOfResult>() -> [ElementOfResult] where Element == Optional<ElementOfResult> {
        return compactMap({$0})
    }
}
