//
//  File.swift
//
//
//  Created by Denys Litvinskyi on 17.08.2021.
//

import Foundation
import CupertinoJWT

struct AuthKeyParser {
    
    // MARK: - Error
    enum AuthKeyParserError: Error {
        case unsupportedP8File
    }
    
    // MARK: - Outlets
    private let file: String
    private let teamID: String
    
    private var keyFilePath: String {
        return FileManager.default.currentDirectoryPath + "/" + file
    }
    
    // MARK: - Init / Deinit methods
    init(file: String, teamID: String) throws {
        self.file = file
        self.teamID = teamID
    }
    
    // MARK: - Public methods
    func signedToken() throws -> String {
        let keyID = try keyID()
        let content = try String(contentsOfFile: keyFilePath)
        let duration: TimeInterval = 200
        let jwt = JWT(keyID: keyID, teamID: teamID, issueDate: Date(), expireDuration: duration)
        
        return try jwt.sign(with: content)
    }
 
    // MARK: - Private methods
    private func keyID() throws -> String {
        guard file.contains("AuthKey_"), file.contains(".p8") else {
            throw AuthKeyParserError.unsupportedP8File
        }

        let keyID = file
            .replacingOccurrences(of: "AuthKey_", with: "")
            .replacingOccurrences(of: ".p8", with: "")

        return keyID
    }
}
