//
//  LLVMWithSSABenchmarks.swift
//  MiniCompilerTests
//
//  Created by Ethan Kusters on 5/15/20.
//

import XCTest
import class Foundation.Bundle

final class LLVMWithOptimizationsBenchmarks: XCTestCase {
    let runBenchmarkWithOptimizations = BenchmarkLLVMTestRunner(enableSSA: true, enableOptimizations: true, useLongerInput: false)
    
    func testBenchMarkishTopicsBenchmark() throws {
        try runBenchmarkWithOptimizations(named: "BenchMarkishTopics")
    }

    func testBertBenchmark() throws {
        try runBenchmarkWithOptimizations(named: "bert")
    }
    
    func testBiggestBenchmark() throws {
        try runBenchmarkWithOptimizations(named: "biggest")
    }
    
    func testBinaryConverterBenchmark() throws {
        try runBenchmarkWithOptimizations(named: "binaryConverter")
    }

    func testBrettBenchmark() throws {
        try runBenchmarkWithOptimizations(named: "brett")
    }

    func testCreativeNameBenchmark() throws {
        try runBenchmarkWithOptimizations(named: "creativeBenchMarkName")
    }
    
    func testFactSumBenchmark() throws {
        try runBenchmarkWithOptimizations(named: "fact_sum")
    }

    func testFibonacciBenchmark() throws {
        try runBenchmarkWithOptimizations(named: "Fibonacci")
    }
    
    func testGeneralFunctAndOptimizeBenchmark() throws {
        try runBenchmarkWithOptimizations(named: "GeneralFunctAndOptimize")
    }
    
    func testHailstoneBenchmark() throws {
        try runBenchmarkWithOptimizations(named: "hailstone")
    }
    
    func testHanoiBenchmark() throws {
        try runBenchmarkWithOptimizations(named: "hanoi_benchmark")
    }
    
    func testKillerBubblesBenchmark() throws {
        try runBenchmarkWithOptimizations(named: "killerBubbles")
    }

    func testMile1Benchmark() throws {
        try runBenchmarkWithOptimizations(named: "mile1")
    }
    
    func testMixedBenchmark() throws {
        try runBenchmarkWithOptimizations(named: "mixed")
    }
    
    func testOptimizationBenchmarkBenchmark() throws {
        try runBenchmarkWithOptimizations(named: "OptimizationBenchmark")
    }
    
    func testPrimesBenchmark() throws {
        try runBenchmarkWithOptimizations(named: "primes")
    }
    
    func testProgramBreakerBenchmark() throws {
        try runBenchmarkWithOptimizations(named: "programBreaker")
    }
    
    func testStatsBenchmark() throws {
        try runBenchmarkWithOptimizations(named: "stats")
    }
    
    func testTicTacBenchmark() throws {
        try runBenchmarkWithOptimizations(named: "TicTac")
    }
    
    func testwasteOfCyclesBenchmark() throws {
        try runBenchmarkWithOptimizations(named: "wasteOfCycles")
    }
    
}
