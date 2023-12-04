#!/usr/bin/env swift

import Foundation

// MARK: 脚本执行逻辑

try syncSnippets()

try syncFileTemplates()

try openTestWorkspace()

// MARK: 工具函数

func syncFileTemplates() throws {
    
    let fileTemplateDirName = "File Templates"
    
    let fileTemplateDirFileURL = URL(fileURLWithPath: fileTemplateDirName)
    
    let xcodeUserDataFileTemplatesFileURL = URL(fileURLWithPath: NSHomeDirectory().appending("/Library/Developer/Xcode/Templates/\(fileTemplateDirName)/"))
    
    print("Sync Templates to directory: \(xcodeUserDataFileTemplatesFileURL.path(percentEncoded: false))")
    
    try syncDir(from: fileTemplateDirFileURL, to: xcodeUserDataFileTemplatesFileURL)
    
}

func syncSnippets() throws {
    
    let snippetDirName = "CodeSnippets"
    
    let snippetDirFileURL = URL(fileURLWithPath: snippetDirName)
    
    let xcodeUserDataCodeSnippetsFileURL = URL(fileURLWithPath: NSHomeDirectory().appending("/Library/Developer/Xcode/UserData/\(snippetDirName)/"))
    
    print("Sync Snippets to directory: \(xcodeUserDataCodeSnippetsFileURL.path(percentEncoded: false))")
    
    try syncDir(from: snippetDirFileURL, to: xcodeUserDataCodeSnippetsFileURL)
}

func syncDir(from sourceDirFileURL: URL, to destinationDirFileURL: URL) throws {
 
    if let isDir = try sourceDirFileURL.resourceValues(forKeys: [.isDirectoryKey]).isDirectory, isDir == true {
        
        let sourceDirFiles =  try FileManager.default.contentsOfDirectory(atPath: sourceDirFileURL.path(percentEncoded: false))
        
        if !sourceDirFiles.isEmpty {
            
            let isExist = FileManager.default.fileExists(atPath: destinationDirFileURL.path(percentEncoded: false))
            
            if !isExist {
                
                try FileManager.default.createDirectory(at: destinationDirFileURL, withIntermediateDirectories: true)
            }
            
            try sourceDirFiles.forEach { sourceFile in
                
                let sourceFilePath = sourceDirFileURL.appending(path: sourceFile).path(percentEncoded: false)
                
                let destinationFilePath = destinationDirFileURL.path(percentEncoded: false).appending(sourceFile)
                
                if FileManager.default.fileExists(atPath: destinationFilePath) {
                    
                    try FileManager.default.removeItem(atPath: destinationFilePath)
                }
                
                try FileManager.default.copyItem(atPath: sourceFilePath, toPath: destinationFilePath)
                
                print("✓ \(sourceFile)")
            }
        }
    }
}

func openTestWorkspace() throws {

    try closeXcode()

    try runShellCommand(executableURL: URL(filePath: "/usr/bin/xed"), arguments: ["TestProject"])

    print("Open Test Workspace")
    
}

func closeXcode() throws {

    try runShellCommand(executableURL: URL(filePath: "/usr/bin/pkill"), arguments: ["Xcode$"])

    print("Closed Xcode!")
}

func runShellCommand(executableURL: URL, arguments: [String]?) throws {

    let task = Process()

    task.executableURL = executableURL

    task.arguments = arguments

    try task.run()

    task.waitUntilExit()

}