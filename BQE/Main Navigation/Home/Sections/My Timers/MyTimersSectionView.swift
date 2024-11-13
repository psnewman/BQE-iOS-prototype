//
//  MyTimersSectionView.swift
//  BQE
//
//  Created by Paul Newman on 11/11/24.
//

import SwiftUI
import FASwiftUI

struct MyTimersSectionView: View {
    var body: some View {
        List {
            ForEach(0..<3, id: \.self) { index in
                TimerRowView(
                    clientName: "Client Meeting",
                    projectDetails: "19-08 - PASADENA: Design Development"
                )
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        // Delete action
                        print("Delete timer")
                    }
                    label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.alert)
                    Button {
                        // Edit action
                        print("Add Time Entry")
                    } label: {
                        Label("Time Entry", systemImage: "calendar.badge.plus")
                    }
                    .tint(.masterPrimary)
                    Button {
                        // Edit action
                        print("Reset timer")
                    } label: {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                    }
                    .tint(.gray)
                }
            }
        }
        .listStyle(PlainListStyle())
        .frame(height: 192)
        .scrollDisabled(true)
        
    }
}

#Preview {
    MyTimersSectionView()
}
