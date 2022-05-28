//
//  URL+FontConfiguration.swift
//  
//
//  Created by Stephen Anthony on 28/05/2022.
//

import Foundation

extension URL {
    static func urlForConfigurationFile(withName name: String) -> URL {
        let sourceFileURL = URL(fileURLWithPath: #file)
        let sourceFileDirectory = sourceFileURL.deletingLastPathComponent()
        return sourceFileDirectory.appendingPathComponent("Font Configuration Files").appendingPathComponent(name).appendingPathExtension("json")
    }
}
