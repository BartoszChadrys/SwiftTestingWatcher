//
//  ContributorsRepoWidget.swift
//  SwiftTestingWatcherWidgetExtension
//
//  Created by Bartek Chadryś on 28/07/2024.
//

import WidgetKit
import SwiftUI

struct ContributorsProvider: TimelineProvider {
    func placeholder(in context: Context) -> ContributorsEntry {
        ContributorsEntry(date: .now, repository: .defaultRepository)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ContributorsEntry) -> Void) {
        let entry = ContributorsEntry(date: .now, repository: .defaultRepository)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ContributorsEntry>) -> Void) {
        Task {
            let nextUpdateDate = Date().addingTimeInterval(3600 * 12) // 12 hours
            
            do {
                var repo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.swiftTesting)
                
                let avatarData = await NetworkManager.shared.getImage(from: repo.owner.avatarUrl)
                repo.avatarData = avatarData ?? Data()
                
                let contributors = try await NetworkManager.shared.getContributors(from: RepoURL.swiftTesting + "/contributors")
                var topFour = Array(contributors.prefix(4))
                
                for i in topFour.indices {
                    let avatarData = await NetworkManager.shared.getImage(from: topFour[i].avatarUrl)
                    topFour[i].avatarData = avatarData ?? Data()
                }
                
                repo.contributors = topFour
                
                let entry = ContributorsEntry(date: .now, repository: repo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                completion(timeline)
            } catch {
                print("❌ Error - \(error.localizedDescription)")
            }
        }
    }
}

struct ContributorsEntry: TimelineEntry {
    var date: Date
    let repository: Repository
}

struct ContributorsRepoEntryView : View {
    var entry: ContributorsEntry

    var body: some View {
        VStack(spacing: 24) {
            SwiftTestingMediumView(repository: entry.repository)
            ContributorsMediumView(repository: entry.repository)
        }
    }
}

public struct ContributorsRepoWidget: Widget {
    let kind: String = "ContributorsRepoWidget"

    public init() {}
    
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ContributorsProvider()) { entry in
            if #available(iOS 17.0, *) {
                ContributorsRepoEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ContributorsRepoEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Contributors Repo")
        .description("Stay in touch with your repo and contributors!")
        .supportedFamilies([.systemLarge])
    }
}

#Preview(as: .systemLarge) {
    ContributorsRepoWidget()
} timeline: {
    ContributorsEntry(date: Date(), repository: .defaultRepository)
}
