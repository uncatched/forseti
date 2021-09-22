//
//  File.swift
//  
//
//  Created by Denys Litvinskyi on 22.09.2021.
//

import Foundation

final class API {
    
    // MARK: - Properties
    private let session: URLSession = .shared
    private let token: String
    private let bundleID: String
    private let device: String
    
    private var url: URL {
        let urlString = "https://api.sandbox.push.apple.com:443/3/device/\(device)"
        
        return URL(string: urlString)!
    }
    
    // MARK: - Init / Deinit methods
    init(token: String, bundleID: String, device: String) {
        self.token = token
        self.bundleID = bundleID
        self.device = device
    }
    
    // MARK: - Public methods
    func sendPush(message: String, completion: @escaping () -> Void) {
        let request = request(from: message)
        
        let task = session.dataTask(with: request) { _, response, _ in
            if let response = response {
                print(response)
            }
            
            completion()
        }
        
        task.resume()
    }
    
    // MARK: - Private methods
    private func request(from message: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("alert", forHTTPHeaderField: "apns-push-type")
        request.addValue("bearer \(token)", forHTTPHeaderField: "authorization")
        request.addValue(bundleID, forHTTPHeaderField: "apns-topic")
        
        request.httpBody = payload(from: message).data(using: .utf8)
        
        return request
    }
    
    private func payload(from message: String) -> String {
        return "{ \"aps\": {\"alert\": \"\(message)\", \"sound\": \"default\" }}"
    }
}
