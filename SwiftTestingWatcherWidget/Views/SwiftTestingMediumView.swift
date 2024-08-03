//
//  SwiftTestingMediumView.swift
//  SwiftTestingWatcher
//
//  Created by Bartek Chadryś on 26/07/2024.
//

import SwiftUI
import WidgetKit

struct SwiftTestingMediumView: View {
    let repository: Repository
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Label {
                    Text(repository.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                } icon: {
                    Image(uiImage: UIImage(data: repository.avatarData) ?? UIImage(named: "avatar")!)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
                .padding(.bottom, 8)
                
                HStack {
                    StatLabel(value: repository.watchers, imageName: "star.fill")
                    StatLabel(value: repository.forks, imageName: "tuningfork")
                    if repository.hasIssues {
                        StatLabel(value: repository.openIssues, imageName: "exclamationmark.triangle.fill")
                    }
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
                    .contentTransition(.numericText())
                
                Text("days ago")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    var daysSinceLastActivity: Int {
        Calendar.current.dateComponents([.day], from: repository.pushedAt, to: .now).day ?? 0
    }
}

#Preview(as: .systemMedium) {
    CompactRepoWidget()
} timeline: {
    CompactRepoEntry(date: Date(), repository: .defaultRepository)
    CompactRepoEntry(date: Date(), repository: .defaultRepositoryV2)
}

private struct StatLabel: View {
    let value: Int
    let imageName: String
    
    var body: some View {
        Label {
            Text("\(value)")
                .font(.footnote)
                .contentTransition(.numericText())
        } icon: {
            Image(systemName: imageName)
                .foregroundStyle(.green)
        }
        .fontWeight(.medium)
    }
}
