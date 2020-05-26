//
//  GraphVizManager.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/25/20.
//

import Foundation

#if canImport(AppKit)
    import AppKit
#endif

class GraphVizManager<InstructionType: InstructionProtocol, BlockType: InstructionBlock, GraphType: ControlFlowGraph<InstructionType, BlockType>> {
    private let controlFlowGraphs: [GraphType]
    private let baseFilename: String
    private var fileName: String {
        baseFilename + "_GraphRepresentation"
    }
    
    
    init(with controlFlowGraphs: [GraphType], named baseFilename: String) {
        self.controlFlowGraphs = controlFlowGraphs
        self.baseFilename = baseFilename
    }
    
    @discardableResult
    func generateGraphDotfile(inTemporaryDirectory: Bool = false) throws -> URL {
        let baseDirectory = inTemporaryDirectory ?
            FileManager.default.universalTempDirectory : FileManager.default.currentDirectory
        
        let outputFilePath = baseDirectory
            .appendingPathComponent(fileName)
            .appendingPathExtension(GraphVizConstants.fileExtension)
        
        try controlFlowGraphs.graphVizDotFile.write(to: outputFilePath, atomically: true, encoding: .ascii)
        return outputFilePath
    }
    
    func generateGraphPDF() throws {
        let dotfileURL = try generateGraphDotfile(inTemporaryDirectory: true)
        
        let outputPDF = FileManager.default.currentDirectory
            .appendingPathComponent(fileName)
            .appendingPathExtension("pdf")
        
        let dotTask = Process()
        dotTask.arguments = ["-Tpdf", dotfileURL.path, "-o", outputPDF.path]
        
        if #available(macOS 10.13, *) {
            dotTask.executableURL = URL(fileURLWithPath: GraphVizConstants.dotExecutablePath)
            try dotTask.run()
        } else {
            dotTask.launchPath = GraphVizConstants.dotExecutablePath
            dotTask.launch()
        }
        
        dotTask.waitUntilExit()
        try FileManager.default.removeItem(at: dotfileURL)
        
        #if canImport(AppKit)
            NSWorkspace.shared.open(outputPDF)
        #endif
    }
}
