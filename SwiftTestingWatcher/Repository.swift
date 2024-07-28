//
//  Repository.swift
//  SwiftTestingWatcher
//
//  Created by Bartek Chadryś on 26/07/2024.
//

import Foundation

struct Repository {
    let name: String
    let owner: Owner
    let hasIssues: Bool
    let forks: Int
    let watchers: Int
    let openIssues: Int
    let pushedAt: Date
    var avatarData: Data
    
    static let defaultRepository = Repository(
        name: "swift-testing",
        owner: Owner(avatarUrl: ""),
        hasIssues: true,
        forks: 56,
        watchers: 72,
        openIssues: 30,
        pushedAt: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 24)) ?? .now,
        avatarData: Data()
    )
}

extension Repository {
    struct CodingData: Decodable {
        let name: String
        let owner: Owner
        let hasIssues: Bool
        let forks: Int
        let watchers: Int
        let openIssues: Int
        let pushedAt: Date
        
        var repo: Repository {
            Repository(
                name: name,
                owner: owner,
                hasIssues: hasIssues,
                forks: forks,
                watchers: watchers,
                openIssues: openIssues,
                pushedAt: pushedAt,
                avatarData: Data()
            )
        }
    }
}

struct Owner: Decodable {
    let avatarUrl: String
}
