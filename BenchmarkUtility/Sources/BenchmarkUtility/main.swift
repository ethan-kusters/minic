import System
import Foundation

struct BenchmarkTiming {
    let benchmarkName: String
    let compileTime: Double
    let executionTime: Double
}

let armAssembler: String = "arm-linux-gnueabi-gcc"

private let benchmarksDirectory: URL = {
    let thisSourceFile = URL(fileURLWithPath: #file)
    return thisSourceFile
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appendingPathComponent("Benchmarks")
}()

private let benchmarkOutputDirectory: URL = {
    let benchmarkOutputDirectory = FileManager.default.temporaryDirectory.appendingPathComponent("MinicBenchmarkOutput")
    
    if !FileManager.default.fileExists(atPath: benchmarkOutputDirectory.path) {
        try! FileManager.default.createDirectory(at: benchmarkOutputDirectory,
                                            withIntermediateDirectories: false,
                                            attributes: nil)
    }
    
    return benchmarkOutputDirectory
}()

func loadTests() throws {
    let benchmarkDirectoryContents = try FileManager.default.contentsOfDirectory(at: benchmarksDirectory, includingPropertiesForKeys: nil, options: [])
    let benchmarkDirectories = benchmarkDirectoryContents.filter(\.hasDirectoryPath)
    let armBenchmarkWithoutSSA = try benchmarkDirectories.map { benchmarkDirectory in
        try runBenchmarkWithoutSSA(benchmarkDirectory, benchmarkName: benchmarkDirectory.lastPathComponent)
    }
    
    print(armBenchmarkWithoutSSA)
}

func runARMBenchmark(_ benchmarkDirectory: URL, benchmarkName: String) throws -> BenchmarkTiming {
    let inputFileURL = benchmarkDirectory.appendingPathComponent("input.longer")
    let expectedOutputFileURL = benchmarkDirectory.appendingPathComponent("output.longer")
    let actualOutputFileURL = benchmarkOutputDirectory.appendingPathComponent(benchmarkName).appendingPathExtension("output")
    let diffOutputFileURL = benchmarkOutputDirectory.appendingPathComponent(benchmarkName).appendingPathExtension("diffoutput")
    
    let sourceFile = benchmarkDirectory.appendingPathComponent(benchmarkName).appendingPathExtension("mini")
    let compilerOutputFile = benchmarkOutputDirectory.appendingPathComponent(benchmarkName).appendingPathExtension("s")
    let executableFile = compilerOutputFile.deletingPathExtension()
    
    var startCompileTime = timeval()
    var endCompileTime = timeval()
    
    print("Starting ARM compile for \(benchmarkName) without SSA.")
    
    gettimeofday(&startCompileTime, nil)
    try system(command: "minic",
                parameters: [
                                sourceFile.path,
                                "-o",
                                compilerOutputFile.path,
                                "--disable-ssa",
                                "--disable-optimizations"
                            ],
                captureOutput: false)
    gettimeofday(&endCompileTime, nil)
    
    let compileTime = endCompileTime.totalTime - startCompileTime.totalTime
    
    print("Completed ARM compile for \(benchmarkName) without SSA in \(compileTime)")
    
    try system(command: armAssembler,
                parameters: [
                               compilerOutputFile.path,
                               "-o",
                               executableFile.path,
                               "-static"
                           ],
                captureOutput: false)
    
    var startExecutionTime = timeval()
    var endExecutionTime = timeval()
    
    print("Starting ARM execution for \(benchmarkName) without SSA.")
    
    
    gettimeofday(&startExecutionTime, nil)
    try system(shell: "cat \(inputFileURL.path) | \(executableFile.path) > \(actualOutputFileURL.path)")
    gettimeofday(&endExecutionTime, nil)
    
    let executionTime = endExecutionTime.totalTime - startCompileTime.totalTime
    
    print("Completed ARM execution for \(benchmarkName) without SSA in \(executionTime).\n")
    
    
    let diffResult = try system(shell: "diff \(actualOutputFileURL.path) \(expectedOutputFileURL.path) > \(diffOutputFileURL.path)")
    guard diffResult.success else {
        fatalError("Diff failed for \(benchmarkName)")
    }
    
    return BenchmarkTiming(benchmarkName: benchmarkName, compileTime: compileTime, executionTime: executionTime)
}

try loadTests()

