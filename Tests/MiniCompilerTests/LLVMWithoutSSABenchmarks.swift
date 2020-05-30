//
//  LLVMWithoutSSABenchmarks.swift
//  MiniCompilerTests
//
//  Created by Ethan Kusters on 5/15/20.
//

import XCTest
import class Foundation.Bundle

final class LLVMWithoutSSABenchmarks: XCTestCase {
    let runBenchmarkWithoutSSA = BenchmarkLLVMTestRunner(enableSSA: false, useLongerInput: false)
    
    func testBenchMarkishTopicsBenchmark() throws {
        try runBenchmarkWithoutSSA(named: "BenchMarkishTopics")
    }

    func testBertBenchmark() throws {
        try runBenchmarkWithoutSSA(named: "bert")
    }
    
    func testBiggestBenchmark() throws {
        try runBenchmarkWithoutSSA(named: "biggest")
    }
    
    func testBinaryConverterBenchmark() throws {
        try runBenchmarkWithoutSSA(named: "binaryConverter")
    }

    func testBrettBenchmark() throws {
        try runBenchmarkWithoutSSA(named: "brett")
    }

    func testCreativeNameBenchmark() throws {
        try runBenchmarkWithoutSSA(named: "creativeBenchMarkName")
    }
    
    func testFactSumBenchmark() throws {
        try runBenchmarkWithoutSSA(named: "fact_sum")
    }

    func testFibonacciBenchmark() throws {
        try runBenchmarkWithoutSSA(named: "Fibonacci")
    }
    
    func testGeneralFunctAndOptimizeBenchmark() throws {
        try runBenchmarkWithoutSSA(named: "GeneralFunctAndOptimize")
    }
    
    func testHailstoneBenchmark() throws {
        try runBenchmarkWithoutSSA(named: "hailstone")
    }
    
    func testHanoiBenchmark() throws {
        try runBenchmarkWithoutSSA(named: "hanoi_benchmark")
    }
    
    func testKillerBubblesBenchmark() throws {
        try runBenchmarkWithoutSSA(named: "killerBubbles")
    }

    func testMile1Benchmark() throws {
        try runBenchmarkWithoutSSA(named: "mile1")
    }
    
    func testMixedBenchmark() throws {
        try runBenchmarkWithoutSSA(named: "mixed")
    }
    
    func testOptimizationBenchmarkBenchmark() throws {
        try runBenchmarkWithoutSSA(named: "OptimizationBenchmark")
    }
    
    func testPrimesBenchmark() throws {
        try runBenchmarkWithoutSSA(named: "primes")
    }
    
    func testProgramBreakerBenchmark() throws {
        try runBenchmarkWithoutSSA(named: "programBreaker")
    }
    
    func testStatsBenchmark() throws {
        try runBenchmarkWithoutSSA(named: "stats")
    }
    
    func testTicTacBenchmark() throws {
        try runBenchmarkWithoutSSA(named: "TicTac")
    }
    
    func testwasteOfCyclesBenchmark() throws {
        try runBenchmarkWithoutSSA(named: "wasteOfCycles")
    }
}
