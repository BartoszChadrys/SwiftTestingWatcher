//
//  SwiftTestingWatcherWidget.swift
//  SwiftTestingWatcherWidget
//
//  Created by Bartek Chadryś on 26/07/2024.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> RepoEntry {
        RepoEntry(date: Date(), repository: .defaultRepository)
    }

    func getSnapshot(in context: Context, completion: @escaping (RepoEntry) -> ()) {
        let entry = RepoEntry(date: Date(), repository: .defaultRepository)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let nextUpdateDate = Date().addingTimeInterval(3600 * 12) // 12 hours

            do {
                var repo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.swiftTesting)
                let avatarData = await NetworkManager.shared.getImage(from: repo.owner.avatarUrl)
                repo.avatarData = avatarData ?? Data()
                let entry = RepoEntry(date: .now, repository: repo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                completion(timeline)
            } catch {
                print("❌ Error - \(error.localizedDescription)")
            }
        }
    }
}

struct RepoEntry: TimelineEntry {
    let date: Date
    let repository: Repository
}

struct SwiftTestingWatcherWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: RepoEntry

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

public struct SwiftTestingWatcherWidget: Widget {
    let kind: String = "SwiftTestingWatcherWidget"

    public init() {}
    
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                SwiftTestingWatcherWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                SwiftTestingWatcherWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

#Preview(as: .systemMedium) {
    SwiftTestingWatcherWidget()
} timeline: {
    RepoEntry(date: Date(), repository: .defaultRepository)
}
