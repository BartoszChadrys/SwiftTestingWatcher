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
                ForEach(0..<4) { i in
                    HStack {
                        Image(uiImage: UIImage(named: "avatar")!)
                            .resizable()
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text("Bartosz Chadryś")
                                .font(.caption)
                                .minimumScaleFactor(0.7)
                            Text("42")
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
