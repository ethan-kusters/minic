//
//  TypeError+LocalizedError.swift
//  minic
//
//  Created by Ethan Kusters on 5/18/20.
//

import Foundation

extension TypeError: LocalizedError {
    var errorDescription: String? {
        return "Line \(lineNumber): \(message)"
    }
}
