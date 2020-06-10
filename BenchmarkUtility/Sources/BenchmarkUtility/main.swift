import System
import Foundation


struct BenchmarkTimingRound {
    let minicWithoutSSA: [BenchmarkTiming]
    let minicWithSSA: [BenchmarkTiming]
    let minicWithOptimizations: [BenchmarkTiming]
    let gccWithoutOptimizations: [BenchmarkTiming]
    let gccWithOptimizations: [BenchmarkTiming]
}

struct BenchmarkTiming {
    let benchmarkName: String
    var compileTime: Double
    var executionTime: Double
}

let armGCC: String = "arm-linux-gnueabi-gcc"

private let benchmarksDirectory: URL = {
    let thisSourceFile = URL(fileURLWithPath: #file)
    return thisSourceFile
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appendingPathComponent("Benchmarks")
}()

private let benchmarkOutputDataDirectory: URL = {
    let thisSourceFile = URL(fileURLWithPath: #file)
    let outputDataDirectory = thisSourceFile
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appendingPathComponent("Results")
    
    if !FileManager.default.fileExists(atPath: outputDataDirectory.path) {
        try! FileManager.default.createDirectory(at: outputDataDirectory,
                                            withIntermediateDirectories: false,
                                            attributes: nil)
    }
    
    return outputDataDirectory
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

func runTests() throws {
    var benchmarkRounds = [BenchmarkTimingRound]()
    for round in 0..<5 {
        print()
        print("Beginning round \(round) of benchmarks.")
        benchmarkRounds.append(try performRoundOfBenchmarks())
    }
    
    print()
    print("Finished benchmarking. Calculating average.")
    
    let average = getBenchmarkRoundsAverage(benchmarkRounds)
    
    var benchmarkCSVData = [(title: String, body: String)]()
    
    for benchmarkIndex in 0..<benchmarkRounds.first!.minicWithoutSSA.count {
        benchmarkCSVData.append(getCSVForBenchmarkTimingRound(average, index: benchmarkIndex))
    }
    
    try benchmarkCSVData.forEach { (title, body) in
        let outputFile = benchmarkOutputDataDirectory.appendingPathComponent(title).appendingPathExtension("csv")
        try body.write(to: outputFile, atomically: true, encoding: .ascii)
    }
}

func getBenchmarkRoundsAverage(_ benchmarkRounds: [BenchmarkTimingRound]) -> BenchmarkTimingRound {
    guard benchmarkRounds.count > 1 else { return benchmarkRounds.first! }
    
    let minicWithoutSSAAverage = averageBenchmark(benchmarkRounds, for: \.minicWithoutSSA)
    let minicWithSSAAverage = averageBenchmark(benchmarkRounds, for: \.minicWithSSA)
    let minicWithOptimizationsAverage = averageBenchmark(benchmarkRounds, for: \.minicWithOptimizations)
    let gccWithoutOptimizationsAverage = averageBenchmark(benchmarkRounds, for: \.gccWithoutOptimizations)
    let gccWithOptimizationsAverage = averageBenchmark(benchmarkRounds, for: \.gccWithOptimizations)
    
    return BenchmarkTimingRound(minicWithoutSSA: minicWithoutSSAAverage,
                                minicWithSSA: minicWithSSAAverage,
                                minicWithOptimizations: minicWithOptimizationsAverage,
                                gccWithoutOptimizations: gccWithoutOptimizationsAverage,
                                gccWithOptimizations: gccWithOptimizationsAverage)
}

func averageBenchmark(_ benchmarkRounds: [BenchmarkTimingRound], for benchmarkPath: KeyPath<BenchmarkTimingRound, [BenchmarkTiming]>) -> [BenchmarkTiming] {
    guard benchmarkRounds.count > 1 else { return benchmarkRounds.first![keyPath: benchmarkPath] }
    
    var benchmarkAverage: [BenchmarkTiming] = benchmarkRounds.first![keyPath: benchmarkPath]
    
    for roundIndex in 1..<benchmarkRounds.count {
        for (benchmarkIndex, benchmark) in benchmarkRounds[roundIndex][keyPath: benchmarkPath].enumerated() {
            benchmarkAverage[benchmarkIndex].compileTime += benchmark.compileTime
            benchmarkAverage[benchmarkIndex].executionTime += benchmark.executionTime
        }
    }
    
    for benchmarkIndex in 0..<benchmarkAverage.count {
        benchmarkAverage[benchmarkIndex].compileTime /= Double(benchmarkRounds.count)
        benchmarkAverage[benchmarkIndex].executionTime /= Double(benchmarkRounds.count)
    }
    
    return benchmarkAverage
}

func getCSVForBenchmarkTimingRound(_ benchmarkTimingRound: BenchmarkTimingRound, index: Int) -> (title: String, body: String) {
    let header = ",Average Compile Time (s), Average Execution Time (s)"
    
    let minicWithoutSSA =
        [
            "Stack-Based MINIC",
            benchmarkTimingRound.minicWithoutSSA[index].compileTime.description,
            benchmarkTimingRound.minicWithoutSSA[index].executionTime.description
        ].joined(separator: ",")
    
    let minicWithSSA =
        [
            "Unoptimized Register-Based MINIC",
            benchmarkTimingRound.minicWithSSA[index].compileTime.description,
            benchmarkTimingRound.minicWithSSA[index].executionTime.description
        ].joined(separator: ",")
    
    let minicWithOptimizations =
        [
            "Optimized Register-Based MINIC",
            benchmarkTimingRound.minicWithOptimizations[index].compileTime.description,
            benchmarkTimingRound.minicWithOptimizations[index].executionTime.description
        ].joined(separator: ",")
    
    let gccWithoutOptimizations =
        [
            "Unoptimized GCC",
            benchmarkTimingRound.gccWithoutOptimizations[index].compileTime.description,
            benchmarkTimingRound.gccWithoutOptimizations[index].executionTime.description
        ].joined(separator: ",")
    
    let gccWithOptimizations =
        [
            "Optimized GCC",
            benchmarkTimingRound.gccWithOptimizations[index].compileTime.description,
            benchmarkTimingRound.gccWithOptimizations[index].executionTime.description
        ].joined(separator: ",")
    
    return (benchmarkTimingRound.minicWithoutSSA[index].benchmarkName, [header, minicWithoutSSA, minicWithSSA, minicWithOptimizations, gccWithoutOptimizations, gccWithOptimizations].joined(separator: "\n"))
}

func performRoundOfBenchmarks() throws -> BenchmarkTimingRound {
    let benchmarkDirectoryContents = try FileManager.default.contentsOfDirectory(at: benchmarksDirectory, includingPropertiesForKeys: nil, options: [])
    let benchmarkDirectories = benchmarkDirectoryContents.filter(\.hasDirectoryPath)
    
    print()
    print("Starting benchmarks for MINIC without SSA.")
    let minicWithoutSSA = try benchmarkDirectories.map { benchmarkDirectory in
        try runMinicBenchmark(benchmarkDirectory, benchmarkName: benchmarkDirectory.lastPathComponent, disableSSA: true, disableOptimizations: true)
    }
    
    print()
    print("Starting benchmarks for MINIC with SSA.")
    let minicWithSSA = try benchmarkDirectories.map { benchmarkDirectory in
        try runMinicBenchmark(benchmarkDirectory, benchmarkName: benchmarkDirectory.lastPathComponent, disableSSA: false, disableOptimizations: true)
    }
    
    print()
    print("Starting benchmarks for MINIC with optimizations.")
    let minicWithOptimizations = try benchmarkDirectories.map { benchmarkDirectory in
        try runMinicBenchmark(benchmarkDirectory, benchmarkName: benchmarkDirectory.lastPathComponent, disableSSA: false, disableOptimizations: false)
    }

    print()
    print("Starting benchmarks for GCC without optimizations.")
    let gccWithoutOptimizations = try benchmarkDirectories.map { benchmarkDirectory in
        try runGccBenchmark(benchmarkDirectory, benchmarkName: benchmarkDirectory.lastPathComponent, enableOptimizations: false)
    }
    
    print()
    print("Starting benchmarks for GCC with optimizations.")
    let gccWithOptimizations = try benchmarkDirectories.map { benchmarkDirectory in
        try runGccBenchmark(benchmarkDirectory, benchmarkName: benchmarkDirectory.lastPathComponent, enableOptimizations: true)
    }
    
    return BenchmarkTimingRound(minicWithoutSSA: minicWithoutSSA,
                                minicWithSSA: minicWithSSA,
                                minicWithOptimizations: minicWithOptimizations,
                                gccWithoutOptimizations: gccWithoutOptimizations,
                                gccWithOptimizations: gccWithOptimizations)
}

func runMinicBenchmark(_ benchmarkDirectory: URL, benchmarkName: String, disableSSA: Bool, disableOptimizations: Bool) throws -> BenchmarkTiming {
    let inputFileURL = benchmarkDirectory.appendingPathComponent("input.longer")
    let expectedOutputFileURL = benchmarkDirectory.appendingPathComponent("output.longer")
    let actualOutputFileURL = benchmarkOutputDirectory.appendingPathComponent(benchmarkName).appendingPathExtension("output")
    let diffOutputFileURL = benchmarkOutputDirectory.appendingPathComponent(benchmarkName).appendingPathExtension("diffoutput")
    
    let sourceFile = benchmarkDirectory.appendingPathComponent(benchmarkName).appendingPathExtension("mini")
    let compilerOutputFile = benchmarkOutputDirectory.appendingPathComponent(benchmarkName).appendingPathExtension("s")
    let executableFile = compilerOutputFile.deletingPathExtension()
    
    var startCompileTime = timeval()
    var endCompileTime = timeval()
    
    print("Starting MINIC compile for \(benchmarkName).")
    
    gettimeofday(&startCompileTime, nil)
    try system(command: "minic",
                parameters: [
                                sourceFile.path,
                                "-o",
                                compilerOutputFile.path,
                                disableSSA ? "--disable-ssa" : nil,
                                disableOptimizations ? "--disable-optimizations" : nil,
                    ].compactMap { $0 },
                captureOutput: false)
    gettimeofday(&endCompileTime, nil)
    
    let compileTime = endCompileTime.totalTime - startCompileTime.totalTime
    
    print("Completed MINIC compile for \(benchmarkName) in \(compileTime)")
    
    try system(command: armGCC,
                parameters: [
                               compilerOutputFile.path,
                               "-o",
                               executableFile.path,
                               "-static"
                           ],
                captureOutput: false)
    
    var startExecutionTime = timeval()
    var endExecutionTime = timeval()
    
    print("Starting MINIC execution for \(benchmarkName).")
    
    
    gettimeofday(&startExecutionTime, nil)
    try system(shell: "cat \(inputFileURL.path) | \(executableFile.path) > \(actualOutputFileURL.path)")
    gettimeofday(&endExecutionTime, nil)
    
    let executionTime = endExecutionTime.totalTime - startCompileTime.totalTime
    
    print("Completed MINIC execution for \(benchmarkName) in \(executionTime).\n")
    
    
    let diffResult = try system(shell: "diff \(actualOutputFileURL.path) \(expectedOutputFileURL.path) > \(diffOutputFileURL.path)")
    guard diffResult.success else {
        fatalError("Diff failed for \(benchmarkName)")
    }
    
    return BenchmarkTiming(benchmarkName: benchmarkName, compileTime: compileTime, executionTime: executionTime)
}

func runGccBenchmark(_ benchmarkDirectory: URL, benchmarkName: String, enableOptimizations: Bool) throws -> BenchmarkTiming {
    let inputFileURL = benchmarkDirectory.appendingPathComponent("input.longer")
    let expectedOutputFileURL = benchmarkDirectory.appendingPathComponent("output.longer")
    let actualOutputFileURL = benchmarkOutputDirectory.appendingPathComponent(benchmarkName).appendingPathExtension("output")
    let diffOutputFileURL = benchmarkOutputDirectory.appendingPathComponent(benchmarkName).appendingPathExtension("diffoutput")
    
    let sourceFile = benchmarkDirectory.appendingPathComponent(benchmarkName).appendingPathExtension("c")
    let executableFile = benchmarkOutputDirectory.appendingPathComponent(benchmarkName)
    
    var startCompileTime = timeval()
    var endCompileTime = timeval()
    
    print("Starting GCC compile for \(benchmarkName).")
    
    gettimeofday(&startCompileTime, nil)
    try system(command: armGCC,
                parameters: [
                                sourceFile.path,
                                "-o",
                                executableFile.path,
                                "-static",
                                "-w",
                                enableOptimizations ? "-O3" : nil,
                    ].compactMap { $0 },
                captureOutput: false)
    gettimeofday(&endCompileTime, nil)
    
    let compileTime = endCompileTime.totalTime - startCompileTime.totalTime
    
    print("Completed GCC compile for \(benchmarkName) in \(compileTime)")
    
    
    var startExecutionTime = timeval()
    var endExecutionTime = timeval()
    
    print("Starting GCC execution for \(benchmarkName).")
    
    
    gettimeofday(&startExecutionTime, nil)
    try system(shell: "cat \(inputFileURL.path) | \(executableFile.path) > \(actualOutputFileURL.path)")
    gettimeofday(&endExecutionTime, nil)
    
    let executionTime = endExecutionTime.totalTime - startCompileTime.totalTime
    
    print("Completed GCC execution for \(benchmarkName) in \(executionTime).\n")
    
    
    let diffResult = try system(shell: "diff \(actualOutputFileURL.path) \(expectedOutputFileURL.path) > \(diffOutputFileURL.path)")
    guard diffResult.success else {
        fatalError("Diff failed for \(benchmarkName)")
    }
    
    return BenchmarkTiming(benchmarkName: benchmarkName, compileTime: compileTime, executionTime: executionTime)
}

try runTests()
