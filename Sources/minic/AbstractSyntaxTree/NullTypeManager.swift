//
//  NullTypeManager.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 5/1/20.
//

import Foundation

public class NullTypeManager {
    private static var nullTypeMap = [Int : Type]()
    
    private static var currentNullIndex = -1
    
    static func getNullIndex() -> Int {
        currentNullIndex += 1
        return currentNullIndex
    }
    
    static func setNullType(forIndex index: Int, asType type: Type) {
        guard index >= 0 else { return }
        nullTypeMap[index] = type
    }
    
     static func getNullType(forIndex index: Int) -> Type {
        return nullTypeMap[index] ?? .null(typeIndex: -1)
    }
}
