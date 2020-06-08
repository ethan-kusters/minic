//
//  BenchmarkTestRunner.swift
//  MiniCompilerTests
//
//  Created by Ethan Kusters on 5/15/20.
//

import XCTest
import class Foundation.Bundle
import System

class BenchmarkARMTestRunner {
    let ssaEnabled: Bool
    let useLongerInput: Bool
    
    init(enableSSA: Bool, useLongerInput: Bool) {
        self.ssaEnabled = enableSSA
        self.useLongerInput = useLongerInput
    }
    
    func callAsFunction(named name: String) throws {
        let benchmarkFolder = MiniCompilerTestConstants.benchmarksDirectory.appendingPathComponent(name)
        let folderContents = try FileManager.default.contentsOfDirectory(at: benchmarkFolder,
                                                                         includingPropertiesForKeys: .none,
                                                                         options: .skipsHiddenFiles)
        
        guard let miniFile = folderContents.first(where: { $0.pathExtension == "mini" }) else {
            XCTFail("Mini File not found.")
            return
        }
        
        let compiledMiniFile = MiniCompilerTestConstants.productsDirectory
            .appendingPathComponent(name)
            .appendingPathExtension("s")
        
        let executableMiniFile = compiledMiniFile.deletingPathExtension()
        
        let inputFileURL = benchmarkFolder.appendingPathComponent(useLongerInput ? "input.longer" : "input")
        let expectedOutputFileURL = benchmarkFolder.appendingPathComponent(useLongerInput ? "output.longer" : "output")
        let diffOutputFileURL = benchmarkFolder.appendingPathComponent(useLongerInput ? "diffresult.longer" : "diffresult")
        let actualOutputFileURL = benchmarkFolder.appendingPathComponent(useLongerInput ? "actualoutput.longer" : "actualoutput")
        
        
        let miniCompilerResult = try system(command: MiniCompilerTestConstants.minicBinary.path,
                                            parameters: [
                                                            miniFile.path,
                                                            "-o",
                                                            compiledMiniFile.path,
                                                            ssaEnabled ? nil : "--disable-ssa"
                                                        ].compactMap {$0},
                                            captureOutput: true)
        
        guard miniCompilerResult.success
            && miniCompilerResult.standardError.isEmpty
            && miniCompilerResult.standardOutput.isEmpty else {
                XCTFail("Mini Comiler Failure: \n\n\(miniCompilerResult.standardOutput)\n\n\(miniCompilerResult.standardError)")
                return
        }
        
        guard MiniCompilerTestConstants.expectedArchitecture == ._32 else {
            throw XCTSkip("This test can only be run on an ARM CPU.")
        }
        
        let assemblerResult = try system(command: MiniCompilerTestConstants.armGCC,
                                         parameters: [
                                                        compiledMiniFile.path,
                                                        "-o",
                                                        executableMiniFile.path,
                                                        "-static"
                                                    ],
                                         captureOutput: true)
        
        guard assemblerResult.success
            && assemblerResult.standardError.isEmpty
            && assemblerResult.standardOutput.isEmpty else {
                XCTFail("Mini Comiler Failure: \n\n\(miniCompilerResult.standardOutput)\n\n\(miniCompilerResult.standardError)")
                return
        }
        
        try system(shell: "cat \(inputFileURL.path) | \(executableMiniFile.path) > \(actualOutputFileURL.path)")
        
        
        let diffResult = try system(shell: "diff \(actualOutputFileURL.path) \(expectedOutputFileURL.path) > \(diffOutputFileURL.path)")
        
        guard diffResult.success else {
            XCTFail("\nUnexpected program output. Diff failure. See: \(diffOutputFileURL.path) for diff output.\n")
            return
        }
    }
}
