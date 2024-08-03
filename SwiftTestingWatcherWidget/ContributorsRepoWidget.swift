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
        let entry = ContributorsEntry(date: .now, repository: .defaultRepository)
        let nextUpdateDate = Date().addingTimeInterval(3600 * 12) // 12 hours
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        completion(timeline)
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
            ContributorsMediumView()
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
