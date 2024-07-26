//
//  Repository.swift
//  SwiftTestingWatcher
//
//  Created by Bartek Chadryś on 26/07/2024.
//

import Foundation

struct Repository: Decodable {
    let name: String
    let owner: Owner
    let hasIssues: Bool
    let forks: Int
    let watchers: Int
    let openIssues: Int
    let pushedAt: Date
    
    static let defaultRepository = Repository(
        name: "swift-testing",
        owner: Owner(avatarUrl: ""),
        hasIssues: true,
        forks: 56,
        watchers: 72,
        openIssues: 30,
        pushedAt: Calendar.current.date(from: DateComponents(year: 2023, month: 7, day: 24)) ?? .now
    )
}

struct Owner: Decodable {
    let avatarUrl: String
}
