//
//  ControlFlowGraphProtocol.swift
//  minic
//
//  Created by Ethan Kusters on 5/26/20.
//

import Foundation

protocol ControlFlowGraphProtocol {
    var function: Function { get set }
    func graphVizSubgraph(index: Int) -> String
}
