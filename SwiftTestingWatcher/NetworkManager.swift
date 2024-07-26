//
//  NetworkManager.swift
//  SwiftTestingWatcher
//
//  Created by Bartek Chadryś on 26/07/2024.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let decoder = JSONDecoder()
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func getRepo(atUrl urlString: String) async throws -> Repository {
        guard let url = URL(string: urlString) else { throw NetworkError.invalidUrl }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw NetworkError.invalidResponse }
        
        do {
            let repo = try decoder.decode(Repository.self, from: data)
            return repo
        } catch {
            throw NetworkError.invalidData
        }
    }
}

enum NetworkError: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
}

enum RepoURL {
    static let swiftTesting = "https://api.github.com/repos/apple/swift-testing"
}
