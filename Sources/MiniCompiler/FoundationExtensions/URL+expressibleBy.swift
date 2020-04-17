//
//  File.swift
//  
//
//  Created by Ethan Kusters on 4/14/20.
//

import Foundation
import ArgumentParser

extension URL: ExpressibleByArgument {
    public init?(argument: String) {
        self.init(fileURLWithPath: argument)
    }
}
