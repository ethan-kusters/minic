//
//  Block+Hashable.swift
//  minic
//
//  Created by Ethan Kusters on 5/17/20.
//

import Foundation

extension Block: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(label)
        hasher.combine(sealed)
        hasher.combine(uuid)
    }
    
    static func == (lhs: Block, rhs: Block) -> Bool {
        lhs.label == rhs.label && lhs.uuid == rhs.uuid
    }
}
