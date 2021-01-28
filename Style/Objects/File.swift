//
//  File.swift
//  Scene Me
//
//  Created by Vince Davis on 1/28/21.
//

import Foundation


struct File {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func moveUrlToDocumentsDirectory(url: URL, fileExtension: String) -> URL? {
        let guid = UUID().uuidString
        let targetURL = File.documentsDirectory.appendingPathComponent("\(guid).\(fileExtension)")

        do {
            try FileManager.default.moveItem(at: url, to: targetURL)
            return targetURL
        } catch let error {
            print("import script - copy error \(error.localizedDescription)")
            return nil
        }
    }
}
