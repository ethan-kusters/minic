//
//  FileManager+universalTempDirectory.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/25/20.
//

import Foundation

extension FileManager {
    var universalTempDirectory: URL {
        if #available(macOS 10.12, *) {
            return temporaryDirectory
        } else {
            return URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        }
    }
}
