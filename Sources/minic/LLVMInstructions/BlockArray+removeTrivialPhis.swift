//
//  BlockArray+removeTrivialPhis.swift
//  minic
//
//  Created by Ethan Kusters on 5/11/20.
//

import Foundation

extension Array where Element == Block {
    func remoeveTrivialPhis() {
        forEach { block in
            for (index, phi) in block.phiInstructions.enumerated() {
                
            }
        }
    }
}
