//
//  ARMWithOptimizationsBenchmarks.swift
//  MiniCompilerTests
//
//  Created by Ethan Kusters on 5/29/20.
//

import Foundation

import XCTest
import class Foundation.Bundle

final class ARMWithOptimizationsBenchmarks: XCTestCase {
    let runBenchmarkWithSSA = BenchmarkARMTestRunner(enableSSA: true, enableOptimizations: true, useLongerInput: false)
    
    func testBenchMarkishTopicsBenchmark() throws {
        try runBenchmarkWithSSA(named: "BenchMarkishTopics")
    }

    func testBertBenchmark() throws {
        try runBenchmarkWithSSA(named: "bert")
    }
    
    func testBiggestBenchmark() throws {
        try runBenchmarkWithSSA(named: "biggest")
    }
    
    func testBinaryConverterBenchmark() throws {
        try runBenchmarkWithSSA(named: "binaryConverter")
    }

    func testBrettBenchmark() throws {
        try runBenchmarkWithSSA(named: "brett")
    }

    func testCreativeNameBenchmark() throws {
        try runBenchmarkWithSSA(named: "creativeBenchMarkName")
    }
    
    func testFactSumBenchmark() throws {
        try runBenchmarkWithSSA(named: "fact_sum")
    }

    func testFibonacciBenchmark() throws {
        try runBenchmarkWithSSA(named: "Fibonacci")
    }
    
    func testGeneralFunctAndOptimizeBenchmark() throws {
        try runBenchmarkWithSSA(named: "GeneralFunctAndOptimize")
    }
    
    func testHailstoneBenchmark() throws {
        try runBenchmarkWithSSA(named: "hailstone")
    }
    
    func testHanoiBenchmark() throws {
        try runBenchmarkWithSSA(named: "hanoi_benchmark")
    }
    
    func testKillerBubblesBenchmark() throws {
        try runBenchmarkWithSSA(named: "killerBubbles")
    }

    func testMile1Benchmark() throws {
        try runBenchmarkWithSSA(named: "mile1")
    }
    
    func testMixedBenchmark() throws {
        try runBenchmarkWithSSA(named: "mixed")
    }
    
    func testOptimizationBenchmarkBenchmark() throws {
        try runBenchmarkWithSSA(named: "OptimizationBenchmark")
    }
    
    func testPrimesBenchmark() throws {
        try runBenchmarkWithSSA(named: "primes")
    }
    
    func testProgramBreakerBenchmark() throws {
        try runBenchmarkWithSSA(named: "programBreaker")
    }
    
    func testStatsBenchmark() throws {
        try runBenchmarkWithSSA(named: "stats")
    }
    
    func testTicTacBenchmark() throws {
        try runBenchmarkWithSSA(named: "TicTac")
    }
    
    func testwasteOfCyclesBenchmark() throws {
        try runBenchmarkWithSSA(named: "wasteOfCycles")
    }
    
}
