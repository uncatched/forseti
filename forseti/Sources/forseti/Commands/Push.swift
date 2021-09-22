//
//  File.swift
//  
//
//  Created by Denys Litvinskyi on 22.09.2021.
//

import Foundation
import ArgumentParser

struct Push: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Send push notification",
                                                    subcommands: [])
    
    @Argument(help: "Push notification message")
    var message: String
    
    func run() throws {
        let config = try getConfiguration()
        
        guard let authKey = config["authKey"],
              let teamID = config["teamID"],
              let bundleID = config["bundleID"],
              let deviceToken = config["deviceToken"] else {
            return
        }
        
        let token = try AuthKeyParser(file: authKey, teamID: teamID).signedToken()
        let api = API(token: token, bundleID: bundleID, device: deviceToken)
        let group = DispatchGroup()
        group.enter()
        api.sendPush(message: message) {
            group.leave()
        }
        
        group.notify(queue: .main) {
            Push.exit()
        }
        
        dispatchMain()
    }
    
    private func getConfiguration() throws -> [String: String] {
        let path = FileManager.default.currentDirectoryPath + "/config.json"
        let pathURL = URL(fileURLWithPath: path)
        do {
            let jsonData = try Data(contentsOf: pathURL)
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            guard let json = jsonObject as? [String: String] else {
                throw PushCommandError.castFailed
            }
            
            return json
        } catch {
            throw PushCommandError.fileNotFound
        }
    }
    
    enum PushCommandError: Error {
        case fileNotFound
        case castFailed
    }
}
