//
//  MiniCompilerTestConstants.swift
//  MiniCompilerTests
//
//  Created by Ethan Kusters on 5/15/20.
//

import Foundation

struct MiniCompilerTestConstants {
    static let productsDirectory: URL = {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }()
    
    static let benchmarksDirectory: URL = {
        let thisSourceFile = URL(fileURLWithPath: #file)
        return thisSourceFile.deletingLastPathComponent().deletingLastPathComponent().appendingPathComponent("benchmarks")
    }()
    
    static let minicBinary: URL = {
        productsDirectory.appendingPathComponent("minic")
    }()
    
    static let clangURL = URL(fileURLWithPath: "/usr/bin/clang")
}