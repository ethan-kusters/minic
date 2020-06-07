//
//  LLVMWithOptimizationsLongerBenchmarks.swift
//  MiniCompilerTests
//
//  Created by Ethan Kusters on 6/06/20.
//

import XCTest
import class Foundation.Bundle

final class LLVMWithOptimizationsLongerBenchmarks: XCTestCase {
    let runOptimizedBenchmarkWithLongerInput = BenchmarkLLVMTestRunner(enableSSA: true,
                                                              enableOptimizations: true,
                                                              useLongerInput: true)
    
    func testBenchMarkishTopicsBenchmark() throws {
        try runOptimizedBenchmarkWithLongerInput(named: "BenchMarkishTopics")
    }

    func testBertBenchmark() throws {
        try runOptimizedBenchmarkWithLongerInput(named: "bert")
    }
    
    func testBiggestBenchmark() throws {
        try runOptimizedBenchmarkWithLongerInput(named: "biggest")
    }
    
    func testBinaryConverterBenchmark() throws {
        try runOptimizedBenchmarkWithLongerInput(named: "binaryConverter")
    }

    func testBrettBenchmark() throws {
        try runOptimizedBenchmarkWithLongerInput(named: "brett")
    }

    func testCreativeNameBenchmark() throws {
        try runOptimizedBenchmarkWithLongerInput(named: "creativeBenchMarkName")
    }
    
    func testFactSumBenchmark() throws {
        try runOptimizedBenchmarkWithLongerInput(named: "fact_sum")
    }

    func testFibonacciBenchmark() throws {
        try runOptimizedBenchmarkWithLongerInput(named: "Fibonacci")
    }
    
    func testGeneralFunctAndOptimizeBenchmark() throws {
        try runOptimizedBenchmarkWithLongerInput(named: "GeneralFunctAndOptimize")
    }
    
    func testHailstoneBenchmark() throws {
        try runOptimizedBenchmarkWithLongerInput(named: "hailstone")
    }
    
    func testHanoiBenchmark() throws {
        try runOptimizedBenchmarkWithLongerInput(named: "hanoi_benchmark")
    }
    
    func testKillerBubblesBenchmark() throws {
        try runOptimizedBenchmarkWithLongerInput(named: "killerBubbles")
    }

    func testMile1Benchmark() throws {
        try runOptimizedBenchmarkWithLongerInput(named: "mile1")
    }
    
    func testMixedBenchmark() throws {
        try runOptimizedBenchmarkWithLongerInput(named: "mixed")
    }
    
    func testOptimizationBenchmarkBenchmark() throws {
        try runOptimizedBenchmarkWithLongerInput(named: "OptimizationBenchmark")
    }
    
    func testPrimesBenchmark() throws {
        try runOptimizedBenchmarkWithLongerInput(named: "primes")
    }
    
    func testProgramBreakerBenchmark() throws {
        try runOptimizedBenchmarkWithLongerInput(named: "programBreaker")
    }
    
    func testStatsBenchmark() throws {
        try runOptimizedBenchmarkWithLongerInput(named: "stats")
    }
    
    func testTicTacBenchmark() throws {
        try runOptimizedBenchmarkWithLongerInput(named: "TicTac")
    }
    
    func testwasteOfCyclesBenchmark() throws {
        try runOptimizedBenchmarkWithLongerInput(named: "wasteOfCycles")
    }
    
}
