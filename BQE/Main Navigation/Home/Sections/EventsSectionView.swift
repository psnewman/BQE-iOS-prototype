//
//  EventsSectionView.swift
//  BQE
//
//  Created by Paul Newman on 11/10/24.
//

import SwiftUI

struct Event: Identifiable {
    let id = UUID()
    let date: Date
    let startTime: Date
    let endTime: Date
    let title: String
    let subtitle: String
    let attendees: [String]
}

struct EventsSectionView: View {
    // Sample data
    let events = [
        Event(date: Date().addingTimeInterval(86400), startTime: Date().addingTimeInterval(86400 + 18 * 3600), endTime: Date().addingTimeInterval(86400 + 20 * 3600), title: "Color and Material Review Meeting", subtitle: "19-14 - WARNER: Design Development", attendees: ["S", "B", "B", "JS"]),
        Event(date: Date().addingTimeInterval(2 * 86400), startTime: Date().addingTimeInterval(2 * 86400 + 14 * 3600), endTime: Date().addingTimeInterval(2 * 86400 + 16 * 3600), title: "Project Planning Session", subtitle: "20-05 - ACME: Conceptual Design", attendees: ["A", "C", "D"]),
        Event(date: Date().addingTimeInterval(3 * 86400), startTime: Date().addingTimeInterval(3 * 86400 + 10 * 3600), endTime: Date().addingTimeInterval(3 * 86400 + 11 * 3600), title: "Client Presentation", subtitle: "18-22 - GLOBEX: Construction Documents", attendees: ["E", "F", "G", "H"])
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(events) { event in
                EventView(event: event)
            }
        }
    }
}

struct EventView: View {
    let event: Event
    
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 8)
                .fill(.masterPrimary)
                .frame(maxWidth: 4, maxHeight: .infinity)
            
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(event.date, format: .dateTime.weekday().month().day())
                            .captionStyle()
                            .foregroundStyle(.typographySecondary)
                        Spacer()
                        (Text(event.startTime, format: .dateTime.hour().minute()) +
                        Text(" - ") +
                        Text(event.endTime, format: .dateTime.hour().minute()))
                            .captionStyle()
                            .foregroundStyle(.typographySecondary)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Text(event.title)
                        .font(.headline)
                    
                    Text(event.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.typographySecondary)
                }
                
                HStack(spacing: -8) {
                    ForEach(event.attendees, id: \.self) { attendee in
                        Circle()
                            .fill(Color.random)
                            .frame(width: 24, height: 24)
                            .overlay(Text(attendee).captionStyle().foregroundColor(.typographyPrimary))
                            .overlay(
                                Circle()
                                    .inset(by: 0.5)
                                    .stroke(.masterBackground, lineWidth: 1)
                            )
                    }
                }
            }
        }
    }
}

extension Color {
    static var random: Color {
        // Generate lighter colors by increasing the minimum values
        Color(red: Double.random(in: 0.6...1),
              green: Double.random(in: 0.6...1),
              blue: Double.random(in: 0.6...1))
    }
}

#Preview {
    EventsSectionView()
}
