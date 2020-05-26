//
//  LLVMInstructionBlock+getUniqueLabel.swift
//  minic
//
//  Created by Ethan Kusters on 5/17/20.
//

import Foundation

extension LLVMInstructionBlock {
    private static var labelIndex: Int = 0
    
    static func getUniqueLabel(_ description: String) -> String {
        labelIndex += 1
        return "_L\(labelIndex)_\(description)".replacingOccurrences(of: " ", with: "_")
    }
}
