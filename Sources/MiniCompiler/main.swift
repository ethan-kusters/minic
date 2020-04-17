
import ArgumentParser
import Foundation

struct minic: ParsableCommand {
    @Argument(help: "The path of the source file to be compiled.") var sourceFilePath: URL
    
    mutating func validate() throws {
      // Verify the file actually exists.
      guard FileManager.default.fileExists(atPath: sourceFilePath.path) else {
        throw ValidationError("File does not exist at \(sourceFilePath.path)")
      }
    }
    
    func run() throws {
        let program = try ParsingManager().parseFileAtURL(sourceFilePath)
        _ = try TypeCheckingManager().check(program)
    }
}

minic.main()
