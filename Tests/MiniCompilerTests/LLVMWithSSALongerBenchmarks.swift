//
//  LLVMWithSSALongerBenchmarks.swift
//  MiniCompilerTests
//
//  Created by Ethan Kusters on 5/15/20.
//

import XCTest
import class Foundation.Bundle

final class LLVMWithSSALongerBenchmarks: XCTestCase {
    let runBenchmarkWithLongerInput = BenchmarkLLVMTestRunner(enableSSA: true, enableOptimizations: false, useLongerInput: true)
    
    func testBenchMarkishTopicsBenchmark() throws {
        try runBenchmarkWithLongerInput(named: "BenchMarkishTopics")
    }

    func testBertBenchmark() throws {
        try runBenchmarkWithLongerInput(named: "bert")
    }
    
    func testBiggestBenchmark() throws {
        try runBenchmarkWithLongerInput(named: "biggest")
    }
    
    func testBinaryConverterBenchmark() throws {
        try runBenchmarkWithLongerInput(named: "binaryConverter")
    }

    func testBrettBenchmark() throws {
        try runBenchmarkWithLongerInput(named: "brett")
    }

    func testCreativeNameBenchmark() throws {
        try runBenchmarkWithLongerInput(named: "creativeBenchMarkName")
    }
    
    func testFactSumBenchmark() throws {
        try runBenchmarkWithLongerInput(named: "fact_sum")
    }

    func testFibonacciBenchmark() throws {
        try runBenchmarkWithLongerInput(named: "Fibonacci")
    }
    
    func testGeneralFunctAndOptimizeBenchmark() throws {
        try runBenchmarkWithLongerInput(named: "GeneralFunctAndOptimize")
    }
    
    func testHailstoneBenchmark() throws {
        try runBenchmarkWithLongerInput(named: "hailstone")
    }
    
    func testHanoiBenchmark() throws {
        try runBenchmarkWithLongerInput(named: "hanoi_benchmark")
    }
    
    func testKillerBubblesBenchmark() throws {
        try runBenchmarkWithLongerInput(named: "killerBubbles")
    }

    func testMile1Benchmark() throws {
        try runBenchmarkWithLongerInput(named: "mile1")
    }
    
    func testMixedBenchmark() throws {
        try runBenchmarkWithLongerInput(named: "mixed")
    }
    
    func testOptimizationBenchmarkBenchmark() throws {
        try runBenchmarkWithLongerInput(named: "OptimizationBenchmark")
    }
    
    func testPrimesBenchmark() throws {
        try runBenchmarkWithLongerInput(named: "primes")
    }
    
    func testProgramBreakerBenchmark() throws {
        try runBenchmarkWithLongerInput(named: "programBreaker")
    }
    
    func testStatsBenchmark() throws {
        try runBenchmarkWithLongerInput(named: "stats")
    }
    
    func testTicTacBenchmark() throws {
        try runBenchmarkWithLongerInput(named: "TicTac")
    }
    
    func testwasteOfCyclesBenchmark() throws {
        try runBenchmarkWithLongerInput(named: "wasteOfCycles")
    }
    
}
