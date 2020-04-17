//
//  URL+expressibleBy.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/14/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation
import ArgumentParser

extension URL: ExpressibleByArgument {
    public init?(argument: String) {
        self.init(fileURLWithPath: argument)
    }
}
