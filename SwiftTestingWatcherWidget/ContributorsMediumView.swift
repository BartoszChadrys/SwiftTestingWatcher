//
//  ContributorsMediumView.swift
//  SwiftTestingWatcher
//
//  Created by Bartek Chadryś on 03/08/2024.
//

import Foundation
import SwiftUI
import WidgetKit

struct ContributorsMediumView: View {
    let repository: Repository
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Top Contributors")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2),
                      alignment: .leading,
                      spacing: 20
            ) {
                ForEach(repository.contributors) { contributor in
                    HStack {
                        Image(uiImage: UIImage(data: contributor.avatarData) ?? UIImage(named: "avatar")!)
                            .resizable()
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text(contributor.login)
                                .font(.caption)
                                .minimumScaleFactor(0.7)
                            Text("\(contributor.contributions)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }
}

#Preview(as: .systemLarge) {
    ContributorsRepoWidget()
} timeline: {
    ContributorsEntry(date: .now, repository: .defaultRepository)
}
