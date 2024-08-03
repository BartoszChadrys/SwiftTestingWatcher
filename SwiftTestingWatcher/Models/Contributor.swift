//
//  Contributor.swift
//  SwiftTestingWatcher
//
//  Created by Bartek Chadryś on 03/08/2024.
//

import Foundation

struct Contributor: Identifiable {
    let id = UUID()
    let login: String
    let avatarUrl: String
    let contributions: Int
    var avatarData: Data
}

extension Contributor {
    struct CodingData: Decodable {
        let login: String
        let avatarUrl: String
        let contributions: Int
        
        var contributor: Contributor {
            Contributor(
                login: login,
                avatarUrl: avatarUrl,
                contributions: contributions,
                avatarData: Data()
            )
        }
    }
}
