#!/usr/bin/env swift

import Foundation


let snippetDirFileURL = URL(fileURLWithPath: "Snippets")

if let isDir = try snippetDirFileURL.resourceValues(forKeys: [.isDirectoryKey]).isDirectory, isDir == true {
    
    let snippets =  try FileManager.default.contentsOfDirectory(atPath: snippetDirFileURL.path())
    
    if !snippets.isEmpty {
        
        let xcodeUserDataFilePath = NSHomeDirectory().appending("/Library/Developer/Xcode/UserData/CodeSnippets/")
        
        let xcodeUserDataFileURL = URL(fileURLWithPath: xcodeUserDataFilePath)
        
        let isExist = FileManager.default.fileExists(atPath: xcodeUserDataFileURL.path(percentEncoded: true))
        
        if !isExist {
            
            try FileManager.default.createDirectory(at: xcodeUserDataFileURL, withIntermediateDirectories: true)
        }
        
        try snippets.forEach { snippetFile in
            
            let snippetSourceFilePath = snippetDirFileURL.appending(path: snippetFile).path
            
            let snippetTargetFilePath = xcodeUserDataFilePath.appending(snippetFile)
            
            if FileManager.default.fileExists(atPath: snippetTargetFilePath) {
                
                try FileManager.default.removeItem(atPath: snippetTargetFilePath)
            }
            
            try FileManager.default.copyItem(atPath: snippetSourceFilePath, toPath: snippetTargetFilePath)
            
            print("✓ \(snippetFile)")
        }
    }
}



