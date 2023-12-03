#!/usr/bin/env swift

import Foundation

try syncSnippets()

func syncSnippets() throws {
    
    let snippetDirFileURL = URL(fileURLWithPath: "Snippets")
    
    let xcodeUserDataFileURL = URL(fileURLWithPath: NSHomeDirectory().appending("/Library/Developer/Xcode/UserData/CodeSnippets/"))
    
    print("Sync Snippets to directory: \(xcodeUserDataFileURL.path())")
    
    try syncDir(from: snippetDirFileURL, to: xcodeUserDataFileURL)
}

func syncDir(from sourceDirFileURL: URL, to destinationDirFileURL: URL) throws {
 
    if let isDir = try sourceDirFileURL.resourceValues(forKeys: [.isDirectoryKey]).isDirectory, isDir == true {
        
        let sourceDirFiles =  try FileManager.default.contentsOfDirectory(atPath: sourceDirFileURL.path())
        
        if !sourceDirFiles.isEmpty {
            
            let isExist = FileManager.default.fileExists(atPath: destinationDirFileURL.path(percentEncoded: true))
            
            if !isExist {
                
                try FileManager.default.createDirectory(at: destinationDirFileURL, withIntermediateDirectories: true)
            }
            
            try sourceDirFiles.forEach { sourceFile in
                
                let sourceFilePath = sourceDirFileURL.appending(path: sourceFile).path
                
                let destinationFilePath = destinationDirFileURL.path().appending(sourceFile)
                
                if FileManager.default.fileExists(atPath: destinationFilePath) {
                    
                    try FileManager.default.removeItem(atPath: destinationFilePath)
                }
                
                try FileManager.default.copyItem(atPath: sourceFilePath, toPath: destinationFilePath)
                
                print("✓ \(sourceFile)")
            }
        }
    }
}
