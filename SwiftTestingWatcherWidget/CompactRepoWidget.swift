//
//  SwiftTestingWatcherWidget.swift
//  SwiftTestingWatcherWidget
//
//  Created by Bartek Chadryś on 26/07/2024.
//

import WidgetKit
import SwiftUI

struct CompactRepoProvider: TimelineProvider {
    func placeholder(in context: Context) -> CompactRepoEntry {
        CompactRepoEntry(date: Date(), repository: .defaultRepository)
    }

    func getSnapshot(in context: Context, completion: @escaping (CompactRepoEntry) -> ()) {
        let entry = CompactRepoEntry(date: Date(), repository: .defaultRepository)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let nextUpdateDate = Date().addingTimeInterval(3600 * 12) // 12 hours

            do {
                var repo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.swiftTesting)
                let avatarData = await NetworkManager.shared.getImage(from: repo.owner.avatarUrl)
                repo.avatarData = avatarData ?? Data()
                let entry = CompactRepoEntry(date: .now, repository: repo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                completion(timeline)
            } catch {
                print("❌ Error - \(error.localizedDescription)")
            }
        }
    }
}

struct CompactRepoEntry: TimelineEntry {
    let date: Date
    let repository: Repository
}

struct CompactRepoEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: CompactRepoEntry

    var body: some View {
        switch widgetFamily {
        case .systemMedium:
            SwiftTestingMediumView(repository: entry.repository)
        case .systemLarge:
            SwiftTestingMediumView(repository: entry.repository)
        default:
            EmptyView()
        }

    }
}

public struct CompactRepoWidget: Widget {
    let kind: String = "CompactRepoWidget"

    public init() {}
    
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CompactRepoProvider()) { entry in
            if #available(iOS 17.0, *) {
                CompactRepoEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                CompactRepoEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Compact Repo Widget")
        .description("Keep an eye on your repo stats!")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    CompactRepoWidget()
} timeline: {
    CompactRepoEntry(date: Date(), repository: .defaultRepository)
}
