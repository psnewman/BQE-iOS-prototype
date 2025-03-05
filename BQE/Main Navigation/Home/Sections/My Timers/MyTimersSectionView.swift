//
//  MyTimersSectionView.swift
//  BQE
//
//  Created by Paul Newman on 11/11/24.
//

import SwiftUI
import FASwiftUI

struct TimerData: Identifiable {
    let id = UUID()
    let timerName: String
    let projectDetails: String
}

struct MyTimersSectionView: View {
    // Sample timer data with unique information
    private let timers: [TimerData] = [
        TimerData(timerName: "Drafting:", projectDetails: "002 - 002- State Housing Complex"),
        TimerData(timerName: "Drafting:", projectDetails: "001 - 001- Pasadena State Hospital"),
        TimerData(timerName: "Drafting:", projectDetails: "002 - 002- State Housing Complex")
    ]
    
    var body: some View {
        List {
            ForEach(timers) { timer in
                TimerRowView(
                    timerName: timer.timerName,
                    projectDetails: timer.projectDetails
                )
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .background(.masterBackground)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        print("Delete timer")
                    }
                    label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.alert)
                    Button {
                        print("Add Time Entry")
                    } label: {
                        Label("Time Entry", systemImage: "calendar.badge.plus")
                    }
                    .tint(.masterPrimary)
                    Button {
                        print("Reset timer")
                    } label: {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                    }
                    .tint(.gray)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(PlainListStyle())
        .frame(height: 192)
        .scrollDisabled(true)
    }
}

#Preview {
    MyTimersSectionView()
}
