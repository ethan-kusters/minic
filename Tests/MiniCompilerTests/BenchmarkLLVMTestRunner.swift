//
//  BenchmarkTestRunner.swift
//  MiniCompilerTests
//
//  Created by Ethan Kusters on 5/15/20.
//

import XCTest
import class Foundation.Bundle
import System

class BenchmarkLLVMTestRunner {
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
            .appendingPathExtension("ll")
        
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
                                                            ssaEnabled ? nil : "--disable-ssa",
                                                            "--emit-llvm"
                                                        ].compactMap {$0},
                                            captureOutput: true)
        
        guard miniCompilerResult.success
            && miniCompilerResult.standardError.isEmpty
            && miniCompilerResult.standardOutput.isEmpty else {
                XCTFail("Mini Comiler Failure: \n\n\(miniCompilerResult.standardOutput)\n\n\(miniCompilerResult.standardError)")
                return
        }
        
        let clangResult = try system(command: MiniCompilerTestConstants.clang,
                                         parameters: [
                                                        "-Wno-override-module",
                                                        compiledMiniFile.path,
                                                        "-o",
                                                        executableMiniFile.path
                                                    ],
                                         captureOutput: true)
        
        guard clangResult.success
            && clangResult.standardError.isEmpty
            && clangResult.standardOutput.isEmpty else {
                XCTFail("Mini Compiler Failure: \n\n\(miniCompilerResult.standardOutput)\n\n\(miniCompilerResult.standardError)")
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
