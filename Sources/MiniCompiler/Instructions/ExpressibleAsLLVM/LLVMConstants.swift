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
    
    static var predefinedHelperFunctions: String {
        [printFunctionDeclarations, scanFunctionDeclaration, libraryFunctionDeclarations].joined(separator: "\n\n")
    }
    
    static let printFunctionDeclarations = """
        ; Print Helper Function Constants:
        @.printFormatString = private unnamed_addr constant [3 x i8] c"%d\\00", align 1
        @.printlnFormatString = private unnamed_addr constant [4 x i8] c"%d\\0A\\00", align 1
        
        ; Print Helper Functions:
        define void @\(InstructionConstants.printHelperFunction)(i32) #0 {
            %2 = alloca i32, align 4
            store i32 %0, i32* %2, align 4
            %3 = load i32, i32* %2, align 4
            %4 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.printFormatString, i64 0, i64 0), i32 %3)
            ret void
        }

        define void @\(InstructionConstants.printlnHelperFunction)(i32) #0 {
            %2 = alloca i32, align 4
            store i32 %0, i32* %2, align 4
            %3 = load i32, i32* %2, align 4
            %4 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.printlnFormatString, i64 0, i64 0), i32 %3)
            ret void
        }
        """
    
    static let scanFunctionDeclaration = """
        ; Scan Helper Function Constants:
        @.scanFormatString = private unnamed_addr constant [3 x i8] c"%d\\00", align 1
        
        ; Scan Helper Function:
        define i32 @\(InstructionConstants.readHelperFunction)() #0 {
          %1 = alloca i32, align 4
          %2 = call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.scanFormatString, i64 0, i64 0), i32* %1)
          %3 = load i32, i32* %1, align 4
          ret i32 %3
        }
        """
    
    static let libraryFunctionDeclarations = """
        ; Library Functions:
        declare i32 @scanf(i8*, ...)
        declare i32 @printf(i8*, ...)
        declare i8* @malloc(i32)
        declare void @free(i8*)
        """
}
