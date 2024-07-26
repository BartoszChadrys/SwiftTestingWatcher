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
        RepoEntry(date: Date(), repository: .defaultRepository, avatarImageData: Data())
    }

    func getSnapshot(in context: Context, completion: @escaping (RepoEntry) -> ()) {
        let entry = RepoEntry(date: Date(), repository: .defaultRepository, avatarImageData: Data())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let nextUpdateDate = Date().addingTimeInterval(3600 * 12) // 12 hours

            do {
                let repo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.swiftTesting)
                let avatarData = await NetworkManager.shared.getImage(from: repo.owner.avatarUrl)
                let entry = RepoEntry(date: .now, repository: repo, avatarImageData: avatarData ?? Data())
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
    let avatarImageData: Data
}

struct SwiftTestingWatcherWidgetEntryView : View {
    var entry: RepoEntry

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Label {
                    Text(entry.repository.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                } icon: {
                    Image(uiImage: UIImage(data: entry.avatarImageData) ?? UIImage(named: "avatar")!)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
                .padding(.bottom, 8)
                
                HStack {
                    StatLabel(value: entry.repository.watchers, imageName: "star.fill")
                    StatLabel(value: entry.repository.forks, imageName: "tuningfork")
                    StatLabel(value: entry.repository.openIssues, imageName: "exclamationmark.triangle.fill")
                }
            }
            
            Spacer()
            
            VStack {
                Text("\(daysSinceLastActivity)")
                    .font(.system(size: 70))
                    .frame(width: 90)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                    .fontWeight(.bold)
                    .foregroundStyle(daysSinceLastActivity > 50 ? .red.opacity(0.85) : .green)
                
                Text("days ago")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    var daysSinceLastActivity: Int {
        Calendar.current.dateComponents([.day], from: entry.repository.pushedAt, to: .now).day ?? 0
    }
}

struct SwiftTestingWatcherWidget: Widget {
    let kind: String = "SwiftTestingWatcherWidget"

    var body: some WidgetConfiguration {
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
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    SwiftTestingWatcherWidget()
} timeline: {
    RepoEntry(date: Date(), repository: .defaultRepository, avatarImageData: Data())
}


private struct StatLabel: View {
    let value: Int
    let imageName: String
    
    var body: some View {
        Label {
            Text("\(value)")
                .font(.footnote)
        } icon: {
            Image(systemName: imageName)
                .foregroundStyle(.green)
        }
        .fontWeight(.medium)
    }
}

