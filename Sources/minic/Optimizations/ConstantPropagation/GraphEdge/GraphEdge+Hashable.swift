//
//  GraphEdge+Hashable.swift
//  minic
//
//  Created by Ethan Kusters on 6/3/20.
//

import Foundation

extension GraphEdge: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(source)
        hasher.combine(destination)
    }
    
    static func == (lhs: GraphEdge, rhs: GraphEdge) -> Bool {
        lhs.source == rhs.source
            && lhs.destination == rhs.destination
    }
}
