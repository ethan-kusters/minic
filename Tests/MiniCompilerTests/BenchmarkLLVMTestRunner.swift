//
//  BenchmarkTestRunner.swift
//  MiniCompilerTests
//
//  Created by Ethan Kusters on 5/15/20.
//

import XCTest
import class Foundation.Bundle

class BenchmarkLLVMTestRunner {
    let ssaEnabled: Bool
    let useLongerInput: Bool
    
    init(enableSSA: Bool, useLongerInput: Bool) {
        self.ssaEnabled = enableSSA
        self.useLongerInput = useLongerInput
    }
    
    func callAsFunction(named name: String) throws {
        guard #available(macOS 10.13, *) else {
            XCTFail("macOS 10.13 is required for this test.")
            return
        }
        
        let benchmarkFolder = MiniCompilerTestConstants.benchmarksDirectory.appendingPathComponent(name)
        let folderContents = try FileManager.default.contentsOfDirectory(at: benchmarkFolder,
                                                                         includingPropertiesForKeys: .none,
                                                                         options: .skipsHiddenFiles)
        
        guard let miniFile = folderContents.first(where: {$0.pathExtension == "mini"}) else {
            XCTFail("Mini File not found.")
            return
        }
        
        let compiledMiniFile = MiniCompilerTestConstants.productsDirectory.appendingPathComponent(name).appendingPathExtension("ll")
        let executableMiniFile = compiledMiniFile.deletingPathExtension()
        let minicProcessOutput = Pipe()
        
        let minicProcess = Process()
        minicProcess.executableURL = MiniCompilerTestConstants.minicBinary
        minicProcess.arguments = [miniFile.path, "-o", compiledMiniFile.path]
        
        
        if !ssaEnabled {
            minicProcess.arguments?.append("--disable-ssa")
        }
        
        minicProcess.standardOutput = minicProcessOutput
        minicProcess.standardError = minicProcessOutput
        try minicProcess.run()
        minicProcess.waitUntilExit()
        
        let minicProcessOutputData = minicProcessOutput.fileHandleForReading.readDataToEndOfFile()
        let minicProcessOutputString = String(data: minicProcessOutputData, encoding: .utf8)!
        
        
        guard minicProcessOutputString.isEmpty else {
            XCTFail("\n\n\(minicProcessOutputString)")
            return
        }
        
        let clangProcessOutput = Pipe()
        
        let clangProcess = Process()
        clangProcess.executableURL = MiniCompilerTestConstants.clangURL
        clangProcess.arguments = ["-Wno-override-module", compiledMiniFile.path, "-o", executableMiniFile.path]
        clangProcess.standardOutput = clangProcessOutput
        clangProcess.standardError = clangProcessOutput
        try clangProcess.run()
        clangProcess.waitUntilExit()
        
        let clangProcessOutputData = clangProcessOutput.fileHandleForReading.readDataToEndOfFile()
        let clangProcessOutputString = String(data: clangProcessOutputData, encoding: .utf8)!
        
        guard clangProcessOutputString.isEmpty else {
            XCTFail("\nClang failure:\n\n\(clangProcessOutputString)")
            return
        }
        
        
        let inputFileURL = benchmarkFolder.appendingPathComponent(useLongerInput ? "input.longer" : "input")
        let miniProgramOutput = Pipe()
        
        let miniProgramProcess = Process()
        miniProgramProcess.executableURL = executableMiniFile
        miniProgramProcess.standardInput = try FileHandle(forReadingFrom: inputFileURL)
        miniProgramProcess.standardOutput = miniProgramOutput
        miniProgramProcess.standardError = miniProgramOutput
        try miniProgramProcess.run()
        miniProgramProcess.waitUntilExit()
        
        let data = miniProgramOutput.fileHandleForReading.readDataToEndOfFile()
        let programOutput = String(data: data, encoding: .utf8)!
        
        let expectedOutputFileURL = benchmarkFolder.appendingPathComponent(useLongerInput ? "output.longer" : "output")
        let expectedOutput = try String(contentsOf: expectedOutputFileURL)
        
        guard programOutput == expectedOutput else {
            XCTFail("\nUnexpected program output. Diff failure\n")
            return
        }
    }
}
