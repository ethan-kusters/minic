import XCTest
import class Foundation.Bundle

final class MiniCompilerTests: XCTestCase {
    let clangURL = URL(fileURLWithPath: "/usr/bin/clang")
    
    func test_BenchMarkishTopics_Benchmark() throws {
        try runBenchmarkTest(named: "BenchMarkishTopics", longerInput: false)
    }

    func test_BenchMarkishTopics_LongerBenchmark() throws {
        try runBenchmarkTest(named: "BenchMarkishTopics", longerInput: true)
    }
    
    func test_bert_Benchmark() throws {
        try runBenchmarkTest(named: "bert", longerInput: false)
    }

    func test_bert_LongerBenchmark() throws {
        try runBenchmarkTest(named: "bert", longerInput: true)
    }
    
    func test_biggest_Benchmark() throws {
        try runBenchmarkTest(named: "biggest", longerInput: false)
    }

    func test_biggest_LongerBenchmark() throws {
        try runBenchmarkTest(named: "biggest", longerInput: true)
    }
    
    func test_binaryConverter_Benchmark() throws {
        try runBenchmarkTest(named: "binaryConverter", longerInput: false)
    }

    func test_binaryConverter_LongerBenchmark() throws {
        try runBenchmarkTest(named: "binaryConverter", longerInput: true)
    }
    
    func test_brett_Benchmark() throws {
        try runBenchmarkTest(named: "brett", longerInput: false)
    }

    func test_brett_LongerBenchmark() throws {
        try runBenchmarkTest(named: "brett", longerInput: true)
    }
    
    func test_creativeBenchMarkName_Benchmark() throws {
        try runBenchmarkTest(named: "creativeBenchMarkName", longerInput: false)
    }

    func test_creativeBenchMarkName_LongerBenchmark() throws {
        try runBenchmarkTest(named: "creativeBenchMarkName", longerInput: true)
    }
    
    func test_factSum_Benchmark() throws {
        try runBenchmarkTest(named: "fact_sum", longerInput: false)
    }

    func test_factSum_LongerBenchmark() throws {
        try runBenchmarkTest(named: "fact_sum", longerInput: true)
    }
    
    func test_Fibonacci_Benchmark() throws {
        try runBenchmarkTest(named: "Fibonacci", longerInput: false)
    }

    func test_Fibonacci_LongerBenchmark() throws {
        try runBenchmarkTest(named: "Fibonacci", longerInput: true)
    }
    
    func test_GeneralFunctAndOptimize_Benchmark() throws {
        try runBenchmarkTest(named: "GeneralFunctAndOptimize", longerInput: false)
    }

    func test_GeneralFunctAndOptimize_LongerBenchmark() throws {
        try runBenchmarkTest(named: "GeneralFunctAndOptimize", longerInput: true)
    }
    
    func test_hailstone_Benchmark() throws {
        try runBenchmarkTest(named: "hailstone", longerInput: false)
    }

    func test_hailstone_LongerBenchmark() throws {
        try runBenchmarkTest(named: "hailstone", longerInput: true)
    }
    
    func test_hanoi_benchmark_Benchmark() throws {
        try runBenchmarkTest(named: "hanoi_benchmark", longerInput: false)
    }

    func test_hanoi_benchmark_LongerBenchmark() throws {
        try runBenchmarkTest(named: "hanoi_benchmark", longerInput: true)
    }
    
    func test_killerBubbles_Benchmark() throws {
        try runBenchmarkTest(named: "killerBubbles", longerInput: false)
    }

    func test_killerBubbles_LongerBenchmark() throws {
        try runBenchmarkTest(named: "killerBubbles", longerInput: true)
    }
    
    func test_mile1_Benchmark() throws {
        try runBenchmarkTest(named: "mile1", longerInput: false)
    }

    func test_mile1_LongerBenchmark() throws {
        try runBenchmarkTest(named: "mile1", longerInput: true)
    }
    
    func test_mixed_Benchmark() throws {
        try runBenchmarkTest(named: "mixed", longerInput: false)
    }

    func test_mixed_LongerBenchmark() throws {
        try runBenchmarkTest(named: "mixed", longerInput: true)
    }
    
    func test_OptimizationBenchmark_Benchmark() throws {
        try runBenchmarkTest(named: "OptimizationBenchmark", longerInput: false)
    }

    func test_OptimizationBenchmark_LongerBenchmark() throws {
        try runBenchmarkTest(named: "OptimizationBenchmark", longerInput: true)
    }
    
    func test_primes_Benchmark() throws {
        try runBenchmarkTest(named: "primes", longerInput: false)
    }

    func test_primes_LongerBenchmark() throws {
        try runBenchmarkTest(named: "primes", longerInput: true)
    }
    
    func test_programBreaker_Benchmark() throws {
        try runBenchmarkTest(named: "programBreaker", longerInput: false)
    }

    func test_programBreaker_LongerBenchmark() throws {
        try runBenchmarkTest(named: "programBreaker", longerInput: true)
    }
    
    func test_stats_Benchmark() throws {
        try runBenchmarkTest(named: "stats", longerInput: false)
    }

    func test_stats_LongerBenchmark() throws {
        try runBenchmarkTest(named: "stats", longerInput: true)
    }
    
    func test_TicTac_Benchmark() throws {
        try runBenchmarkTest(named: "TicTac", longerInput: false)
    }

    func test_TicTac_LongerBenchmark() throws {
        try runBenchmarkTest(named: "TicTac", longerInput: true)
    }
    
    func test_wasteOfCycles_Benchmark() throws {
        try runBenchmarkTest(named: "wasteOfCycles", longerInput: false)
    }

    func test_wasteOfCycles_LongerBenchmark() throws {
        try runBenchmarkTest(named: "wasteOfCycles", longerInput: true)
    }
    
    private func runBenchmarkTest(named name: String, longerInput: Bool) throws {
        guard #available(macOS 10.13, *) else { return }

        
        let benchmarkFolder = benchmarksDirectory.appendingPathComponent(name)
        let folderContents = try FileManager.default.contentsOfDirectory(at: benchmarkFolder,
                                                                         includingPropertiesForKeys: .none,
                                                                         options: .skipsHiddenFiles)
        
        guard let miniFile = folderContents.first(where: {$0.pathExtension == "mini"}) else {
            XCTFail("Mini File not found.")
            return
        }
        
        let compiledMiniFile = productsDirectory.appendingPathComponent(name).appendingPathExtension("ll")
        let executableMiniFile = compiledMiniFile.deletingPathExtension()
        let minicProcessOutput = Pipe()
        
        let minicProcess = Process()
        minicProcess.executableURL = minicBinary
        minicProcess.arguments = [miniFile.path, "-o", compiledMiniFile.path]
        minicProcess.standardOutput = minicProcessOutput
        minicProcess.standardError = minicProcessOutput
        try minicProcess.run()
        minicProcess.waitUntilExit()
        
//        XCTAssertNoThrow(try CompilerManager.compile(sourceFile: miniFile, outputFile: compiledMiniFile), "Compiler error.")
        
        let minicProcessOutputData = minicProcessOutput.fileHandleForReading.readDataToEndOfFile()
        let minicProcessOutputString = String(data: minicProcessOutputData, encoding: .utf8)!
        
        
        guard minicProcessOutputString.isEmpty else {
            XCTFail("\n\n\(minicProcessOutputString)")
            return
        }
        
        let clangProcessOutput = Pipe()
        
        let clangProcess = Process()
        clangProcess.executableURL = clangURL
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
        
        
        let inputFileURL = benchmarkFolder.appendingPathComponent(longerInput ? "input.longer" : "input")
        let miniProgramOutput = Pipe()
        
        let miniProgramProcess = Process()
        miniProgramProcess.executableURL = executableMiniFile
        miniProgramProcess.standardInput = try FileHandle(forReadingFrom: inputFileURL)
        miniProgramProcess.standardOutput = miniProgramOutput
        miniProgramProcess.standardError = miniProgramOutput
        try miniProgramProcess.run()
        clangProcess.waitUntilExit()
        
        let data = miniProgramOutput.fileHandleForReading.readDataToEndOfFile()
        let programOutput = String(data: data, encoding: .utf8)!
        
        let expectedOutputFileURL = benchmarkFolder.appendingPathComponent(longerInput ? "output.longer" : "output")
        let expectedOutput = try String(contentsOf: expectedOutputFileURL)
        
        guard programOutput == expectedOutput else {
            XCTFail("\nUnexpected program output. Diff failure\n")
            return
        }
    }
    
    var minicBinary: URL {
        productsDirectory.appendingPathComponent("minic")
    }

    var benchmarksDirectory: URL {
        let thisSourceFile = URL(fileURLWithPath: #file)
        return thisSourceFile.deletingLastPathComponent().deletingLastPathComponent().appendingPathComponent("benchmarks")
    }
    
    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }
}
