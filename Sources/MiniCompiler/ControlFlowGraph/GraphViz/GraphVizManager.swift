//
//  GraphVizManager.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/25/20.
//

import Foundation
import AppKit

class GraphVizManager {
    private let controlFlowGraphs: [ControlFlowGraph]
    private let baseFilename: String
    
    init(with controlFlowGraphs: [ControlFlowGraph], named baseFilename: String) {
        self.controlFlowGraphs = controlFlowGraphs
        self.baseFilename = baseFilename
    }
    
    @discardableResult
    func generateGraphDotfile(inTemporaryDirectory: Bool = false) throws -> URL {
        let fileName = baseFilename + "_GraphRepresentation"
        
        let baseDirectory = inTemporaryDirectory ?
            FileManager.default.temporaryDirectory : FileManager.default.currentDirectory
        
        let outputFilePath = baseDirectory
            .appendingPathComponent(fileName)
            .appendingPathExtension(GraphVizConstants.fileExtension)
        
        try controlFlowGraphs.graphVizDotFile.write(to: outputFilePath, atomically: true, encoding: .ascii)
        return outputFilePath
    }
    
    func generateGraphPDF() throws {
        let dotfileURL = try generateGraphDotfile(inTemporaryDirectory: true)
        
        let outputPDF = dotfileURL.deletingPathExtension().appendingPathExtension("pdf")
        
        let dotTask = Process()
        dotTask.executableURL = URL(fileURLWithPath: GraphVizConstants.dotExecutablePath)
        dotTask.arguments = ["-Tpdf", dotfileURL.path, "-o", outputPDF.path]
        try dotTask.run()
        dotTask.waitUntilExit()
        
        NSWorkspace.shared.open(outputPDF)
        
        try FileManager.default.removeItem(at: dotfileURL)
    }
}
