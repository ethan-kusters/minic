//
//  ErrorBucket.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/12/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

class ErrorBucker: ErrorHandler {
    private let header = String(" Line | Error Message                                                          ")
    
    private var errors = [Error]()
    
    var count: Int {
        errors.count
    }
    
    func report(_ typeError: TypeError) {
        errors.append(typeError)
    }
    
    func printErrors() {
        guard errors.isEmpty == false else {
            print("no errors found")
            return
        }
        
        let sortedErrors = errors.sorted { (first, second) in
            (first as? TypeError)?.lineNumber ?? 0 <= (second as? TypeError)?.lineNumber ?? 0
        }
        
        print("Type check failure.")
        print()
        print(header.colorize(.darkBlue, background: .cyan2).bold())
        
        sortedErrors.forEach { error in
            guard let typeError = error as? TypeError else { return }
            
            let lineNumber = typeError.lineNumber.description.padding(toLength: 4, withPad: " ", startingAt: 0)
            let message = typeError.message.padding(toLength: 71, withPad: " ", startingAt: 0)
            
            let errorToPrint = "  \(lineNumber)| \(message)"
            print(errorToPrint.colorize(.black, background: .lightCyan1))
        }
        
        print()
    }
}
