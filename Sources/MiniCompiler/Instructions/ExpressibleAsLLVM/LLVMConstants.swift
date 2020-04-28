//
//  LLVMConstants.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/27/20.
//

import Foundation

struct LLVMConstants {
    static let targetHeader = "target triple= "
    static let sourceFilenameHeader = "source_filename = "
    
    
    static let printFunctionDeclarations = """
    @.str = private unnamed_addr constant [3 x i8] c"%d\\00", align 1
    @.str.1 = private unnamed_addr constant [4 x i8] c"%d\\0A\\00", align 1

    define void @print(i32) #0 {
      %2 = alloca i32, align 4
      store i32 %0, i32* %2, align 4
      %3 = load i32, i32* %2, align 4
      %4 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str, i64 0, i64 0), i32 %3)
      ret void
    }

    declare i32 @printf(i8*, ...) #1

    define void @println(i32) #0 {
      %2 = alloca i32, align 4
      store i32 %0, i32* %2, align 4
      %3 = load i32, i32* %2, align 4
      %4 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 %3)
      ret void
    }
    """
    
}
