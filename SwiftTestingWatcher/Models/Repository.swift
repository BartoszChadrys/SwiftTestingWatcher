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
    var contributors = [Contributor]()
    
    static let defaultRepository = Repository(
        name: "swift-testing",
        owner: Owner(avatarUrl: ""),
        hasIssues: true,
        forks: 56,
        watchers: 72,
        openIssues: 30,
        pushedAt: Calendar.current.date(from: DateComponents(year: 2024, month: 4, day: 26)) ?? .now,
        avatarData: Data(),
        contributors: [
            Contributor(login: "Bartosz Chadrys", avatarUrl: "", contributions: 87, avatarData: Data()),
            Contributor(login: "Bartosz Chadrys", avatarUrl: "", contributions: 63, avatarData: Data()),
            Contributor(login: "Bartosz Chadrys", avatarUrl: "", contributions: 54, avatarData: Data()),
            Contributor(login: "Bartosz Chadrys", avatarUrl: "", contributions: 36, avatarData: Data())
        ]
    )
    
    static let defaultRepositoryV2 = Repository(
        name: "swift-testing",
        owner: Owner(avatarUrl: ""),
        hasIssues: true,
        forks: 78,
        watchers: 90,
        openIssues: 50,
        pushedAt: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 24)) ?? .now,
        avatarData: Data(),
        contributors: [
            Contributor(login: "Bartosz Chadrys", avatarUrl: "", contributions: 100, avatarData: Data()),
            Contributor(login: "Bartosz Chadrys", avatarUrl: "", contributions: 78, avatarData: Data()),
            Contributor(login: "Bartosz Chadrys", avatarUrl: "", contributions: 68, avatarData: Data()),
            Contributor(login: "Bartosz Chadrys", avatarUrl: "", contributions: 52, avatarData: Data())
        ]
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
