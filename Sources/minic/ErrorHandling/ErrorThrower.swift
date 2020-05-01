//
//  ErrorThrower.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/12/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

class ErrorThrower: ErrorHandler {
    func report(_ typeError: TypeError) {
        try! throwError(typeError)
    }
    
    private func throwError(_ error: Error) throws {
        throw error
    }
}
