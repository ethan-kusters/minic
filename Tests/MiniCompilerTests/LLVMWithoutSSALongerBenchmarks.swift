//
//  LLVMWithoutSSALongerBenchmarks.swift
//  MiniCompilerTests
//
//  Created by Ethan Kusters on 5/15/20.
//

import XCTest
import class Foundation.Bundle

final class LLVMWithoutSSALongerBenchmarks: XCTestCase {
    let runBenchmarkWithoutSSALongerInput = BenchmarkTestRunner(enableSSA: false, useLongerInput: true)
    
    func testBenchMarkishTopicsBenchmark() throws {
        try runBenchmarkWithoutSSALongerInput(named: "BenchMarkishTopics")
    }

    func testBertBenchmark() throws {
        try runBenchmarkWithoutSSALongerInput(named: "bert")
    }
    
    func testBiggestBenchmark() throws {
        try runBenchmarkWithoutSSALongerInput(named: "biggest")
    }
    
    func testBinaryConverterBenchmark() throws {
        try runBenchmarkWithoutSSALongerInput(named: "binaryConverter")
    }

    func testBrettBenchmark() throws {
        try runBenchmarkWithoutSSALongerInput(named: "brett")
    }

    func testCreativeNameBenchmark() throws {
        try runBenchmarkWithoutSSALongerInput(named: "creativeBenchMarkName")
    }
    
    func testFactSumBenchmark() throws {
        try runBenchmarkWithoutSSALongerInput(named: "fact_sum")
    }

    func testFibonacciBenchmark() throws {
        try runBenchmarkWithoutSSALongerInput(named: "Fibonacci")
    }
    
    func testGeneralFunctAndOptimizeBenchmark() throws {
        try runBenchmarkWithoutSSALongerInput(named: "GeneralFunctAndOptimize")
    }
    
    func testHailstoneBenchmark() throws {
        try runBenchmarkWithoutSSALongerInput(named: "hailstone")
    }
    
    func testHanoiBenchmark() throws {
        try runBenchmarkWithoutSSALongerInput(named: "hanoi_benchmark")
    }
    
    func testKillerBubblesBenchmark() throws {
        try runBenchmarkWithoutSSALongerInput(named: "killerBubbles")
    }

    func testMile1Benchmark() throws {
        try runBenchmarkWithoutSSALongerInput(named: "mile1")
    }
    
    func testMixedBenchmark() throws {
        try runBenchmarkWithoutSSALongerInput(named: "mixed")
    }
    
    func testOptimizationBenchmarkBenchmark() throws {
        try runBenchmarkWithoutSSALongerInput(named: "OptimizationBenchmark")
    }
    
    func testPrimesBenchmark() throws {
        try runBenchmarkWithoutSSALongerInput(named: "primes")
    }
    
    func testProgramBreakerBenchmark() throws {
        try runBenchmarkWithoutSSALongerInput(named: "programBreaker")
    }
    
    func testStatsBenchmark() throws {
        try runBenchmarkWithoutSSALongerInput(named: "stats")
    }
    
    func testTicTacBenchmark() throws {
        try runBenchmarkWithoutSSALongerInput(named: "TicTac")
    }
    
    func testwasteOfCyclesBenchmark() throws {
        try runBenchmarkWithoutSSALongerInput(named: "wasteOfCycles")
    }
}
