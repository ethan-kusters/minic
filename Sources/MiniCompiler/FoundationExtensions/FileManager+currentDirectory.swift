//
//  FileManager+currentDirectory.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/25/20.
//

import Foundation

extension FileManager {
    var currentDirectory: URL {
        URL(fileURLWithPath: currentDirectoryPath)
    }
}
