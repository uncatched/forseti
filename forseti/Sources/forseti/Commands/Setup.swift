//
//  File.swift
//  
//
//  Created by Denys Litvinskyi on 22.09.2021.
//

import Foundation
import ArgumentParser

struct Setup: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Setup environment",
                                                    subcommands: [])
    
    @Argument(help: "Application bundle identifier")
    var bundleID: String
    
    @Argument(help: "Device token string")
    var deviceToken: String
    
    @Argument(help: "Apple developer team identifier")
    var teamID: String
    
    @Argument(help: "Name of push token file")
    var authKey: String
    
    func run() throws {
        createConfigFile()
    }
    
    private func createConfigFile() {
        var file = FileHandle(forWritingAtPath: "config.json")
        if file == nil {
            FileManager.default.createFile(atPath: "config.json", contents: nil, attributes: nil)
            file = FileHandle(forWritingAtPath: "config.json")
        }
        
        let object = [
            "bundleID": bundleID,
            "deviceToken": deviceToken,
            "teamID": teamID,
            "authKey": authKey
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: object, options: [])
            file?.write(jsonData)
            
            print("Configuration file successfully created")
        } catch {
            print(error)
        }
        
        file?.closeFile()
    }
}
