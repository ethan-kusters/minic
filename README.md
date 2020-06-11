# MINIC

![Swift](https://github.com/keen-cp/compiler-project-ethankusters/workflows/Swift/badge.svg)

## Overview
This repository holds a compiler for the Mini language. It was developed entirely in Swift for Professor Aaron Keen's [Compiler Construction](http://users.csc.calpoly.edu/~akeen/courses/csc431/) course at Cal Poly. MINIC can generate 32-bit ARM Assembly instructions or LLVM IR.

## Building MINIC

MINIC is written entirely in Swift and developed as a Swift package. It requires Swift 5.3 or later and while it supports Linux, when run on macOS it requires macOS 10.13 or later.

### Requirements

- [Swift 5.2 or later](https://swift.org/download/#releases)

- macOS 10.13 or later (or Linux)

### Quick Run Instructions

- Clone this repository

- Execute `swift run -c release -help`

### Installation Instructions

- Clone this repository

- Execute `swift build -configuration release` from the repositories root

- A minic executable will be placed in a `.build/release` folder

- Add a symbolic link to `./build/release/minic` in your `/usr/bin/local`

- Run `minic -help`

### Developing for MINIC

- The easiest way to work on or view the codebase is via Xcode

- Execute `swift package generate-xcodeproj` to create an Xcode project for the compiler

## Mini Language
The following grammar partially describes the language’s syntax. This language is similar in many respects to C, but limited in features. In the EBNF below, non-terminals are typeset in **bold** font and terminals are typeset in `typewriter` font.

![Mini Grammar Overview](/Resources/MiniGrammarOverview.svg)	

The following rules complete the syntactic definition.

- A valid program is followed by an end-of-file indicator; extra text is not legal.

- The terminal (token) “id” represents a nonempty sequence (beginning with a letter) of letters and digits other than one of the keywords. Similarly, the terminal (token) “number” represents a nonempty sequence of digits.

- As is the case in most languages, a token is formed by taking the longest possible sequence of constituent characters. For example, the input “abcd” represents a single identifier, not several identifiers. Whitespace (i.e., one or more blanks, tabs, or newlines) may precede or follow any token. E.g., “x=10” and “x = 10” are equivalent. Note that whitespace delimits tokens; e.g., “abc” is one token whereas “a bc” is two.

- A comment begins with “#” and consists of all characters up to a newline.

## Features

- Utilizes the [ANTLR4](https://github.com/antlr/antlr4) Swift target for parsing

- Utilizes [Swift Argument Parser](https://github.com/apple/swift-argument-parser) to parse command-line arguments in a user-friendly way

![Swift argument parser help output](/Resources/ArgumentParserOutput.png)

- Can generate a visual representation of the input program's control flow graph via the [Graphviz](https://graphviz.org/about/) [DOT Language](https://graphviz.org/doc/info/lang.html):

![Example control flow graph](/Resources/GraphExample.svg) 

## Compiler Overview

### Parsing

MINIC relies on [ANTLR4](https://github.com/antlr/antlr4) for text parsing and its generated Visitor pattern to translate that initial parse into an Abstract Syntax Tree representation. The AST is represented as several enumerations. After working with [SML](https://www.smlnj.org/sml.html) in Professor Aaron Keen's [Programming Languages course](http://users.csc.calpoly.edu/~akeen/courses/csc430/) while developing an interpreter, I recognized how similar Swift's enum is to SML's datatype and was interested in continuing to work with this representation. For example, an `Expression` in my compiler is represented as the following:

```swift
enum Expression {
    
    indirect case binary(lineNumber: Int, op: BinaryOperator, left: Expression, right: Expression)
    
    indirect case dot(lineNumber: Int, left: Expression, id: String)
    
    case `false`(lineNumber: Int)
    
    case identifier(lineNumber: Int, id: String)
    
    case integer(lineNumber: Int, value: Int)
    
    indirect case invocation(lineNumber: Int, name: String, arguments: [Expression])
    
    case new(lineNumber: Int, id: String)
    
    case null(lineNumber: Int, typeIndex: Int)
    
    case read(lineNumber: Int)
    
    case `true`(lineNumber: Int)
    
    indirect case unary(lineNumber: Int, op: UnaryOperator, operand: Expression)
    
}
```

Type checking is done on this representation via a series of `switch` statements over these enumerations. Errors are represented via yet another enumeration called `TypeError` which holds specific information for the kind of type error found. This allows for generation of user-friendly type errors:

![Example type checker output](/Resources/TypeChecker.png)

### Static Semantics




MINIC constructs a Single Static Assignment (SSA) Form as [discussed by Braun, et. al.](http://compilers.cs.uni-saarland.de/papers/bbhlmz13cc.pdf). This form is used as a backbone for other optimizations as well as register allocation. Register allocation is done via a graph coloring-based algorithm. MINIC's main optimization is Sparse Conditional Constant Propagation as [described by Wegman and Zadeck](https://www.cse.wustl.edu/~cytron/531Pages/f11/Resources/Papers/cprop.pdf). MINIC also performs useless instruction removal.

## Benchmark Results

### [BenchMarkishTopics](/Benchmarks/BenchMarkishTopics)

![Graph for BenchMarkishTopics](/BenchmarkUtility/Results/BenchMarkishTopics.png)

### [bert](/Benchmarks/bert)

![Graph for bert](/BenchmarkUtility/Results/bert.png)

### [biggest](/Benchmarks/biggest)

![Graph for biggest](/BenchmarkUtility/Results/biggest.png)

### [binaryConverter](/Benchmarks/binaryConverter)

![Graph for binaryConverter](/BenchmarkUtility/Results/binaryConverter.png)

### [brett](/Benchmarks/brett)

![Graph for brett](/BenchmarkUtility/Results/brett.png)

### [creativeBenchMarkName](/Benchmarks/creativeBenchMarkName)

![Graph for creativeBenchMarkName](/BenchmarkUtility/Results/creativeBenchMarkName.png)

### [fact_sum](/Benchmarks/fact_sum)

![Graph for bert](/BenchmarkUtility/Results/fact_sum.png)

### [Fibonacci](/Benchmarks/Fibonacci)

![Graph for Fibonacci](/BenchmarkUtility/Results/Fibonacci.png)

### [GeneralFunctAndOptimize](/Benchmarks/GeneralFunctAndOptimize)

![Graph for GeneralFunctAndOptimize](/BenchmarkUtility/Results/GeneralFunctAndOptimize.png)

### [hailstone](/Benchmarks/hailstone)

![Graph for hailstone](/BenchmarkUtility/Results/hailstone.png)

### [hanoi_benchmark](/Benchmarks/hanoi_benchmark)

![Graph for hanoi_benchmark](/BenchmarkUtility/Results/hanoi_benchmark.png)

### [killerBubbles](/Benchmarks/killerBubbles)

![Graph for killerBubbles](/BenchmarkUtility/Results/killerBubbles.png)

### [mile1](/Benchmarks/mile1)

![Graph for mile1](/BenchmarkUtility/Results/mile1.png)

### [mixed](/Benchmarks/mixed)

![Graph for mixed](/BenchmarkUtility/Results/mixed.png)

### [OptimizationBenchmark](/Benchmarks/OptimizationBenchmark)

![Graph for OptimizationBenchmark](/BenchmarkUtility/Results/OptimizationBenchmark.png)

### [primes](/Benchmarks/primes)

![Graph for primes](/BenchmarkUtility/Results/primes.png)

### [programBreaker](/Benchmarks/programBreaker)

![Graph for programBreaker](/BenchmarkUtility/Results/programBreaker.png)

### [stats](/Benchmarks/stats)

![Graph for stats](/BenchmarkUtility/Results/stats.png)

### [TicTac](/Benchmarks/TicTac)

![Graph for TicTac](/BenchmarkUtility/Results/TicTac.png)

### [wasteOfCycles](/Benchmarks/wasteOfCycles)

![Graph for wasteOfCycles](/BenchmarkUtility/Results/wasteOfCycles.png)

