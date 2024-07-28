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
            let codingData = try decoder.decode(Repository.CodingData.self, from: data)
            return codingData.repo
        } catch {
            throw NetworkError.invalidData
        }
    }
    
    func getImage(from urlString: String) async -> Data? {
        guard let url = URL(string: urlString) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            return nil
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
