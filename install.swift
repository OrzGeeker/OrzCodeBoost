#!/usr/bin/env swift

import Foundation

try syncSnippets()

try syncFileTemplates()

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
