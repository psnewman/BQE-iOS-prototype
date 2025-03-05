import SwiftUI

struct Event: Identifiable {
    let id = UUID()
    let date: Date
    let startTime: Date
    let endTime: Date
    let title: String
    let subtitle: String
    let attendees: [(id: UUID, initial: String)]
}

struct EventsSectionView: View {
    // Sample data based on screenshot
    let events = [
        Event(date: createDate(month: 2, day: 13), 
              startTime: createTime(month: 2, day: 13, hour: 9, minute: 0), 
              endTime: createTime(month: 2, day: 13, hour: 10, minute: 0), 
              title: "Construction All Hands", 
              subtitle: "002 - 002- State Housing Complex", 
              attendees: ["A", "AH", "CJ"].map { (UUID(), $0) }),
        
        Event(date: createDate(month: 2, day: 21), 
              startTime: createTime(month: 2, day: 21, hour: 12, minute: 0),
              endTime: createTime(month: 2, day: 21, hour: 13, minute: 0), 
              title: "Client Meeting", 
              subtitle: "002 - 002- State Housing Complex", 
              attendees: ["A", "M", "AH", "S", "A"].map { (UUID(), $0) }),
        
        Event(date: createDate(month: 2, day: 26), 
              startTime: createTime(month: 2, day: 26, hour: 16, minute: 0), 
              endTime: createTime(month: 2, day: 26, hour: 17, minute: 0), 
              title: "Pasadena Sign Off", 
              subtitle: "001 - 001- Pasadena State Hospital", 
              attendees: ["S", "A", "AE", "C", "M"].map { (UUID(), $0) })
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
    
    var formattedTimeRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.locale = Locale(identifier: "en_US")
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        let startTimeString = formatter.string(from: event.startTime)
        let endTimeString = formatter.string(from: event.endTime)
        
        return startTimeString + " - " + endTimeString
    }
    
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 8)
                .fill(.masterPrimary)
                .frame(maxWidth: 4, maxHeight: .infinity)
            
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(event.date, format: .dateTime.weekday().month().day())
                            .bodySmallStyle()
                            .foregroundStyle(.typographySecondary)
                        Spacer()
                        Text(formattedTimeRange)
                            .bodySmallStyle()
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
                    ForEach(event.attendees, id: \.id) { attendee in
                        Circle()
                            .fill(Color.random)
                            .frame(width: 24, height: 24)
                            .overlay(Text(attendee.initial).bodySmallStyle().foregroundColor(.typographyPrimary))
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

// Helper functions to create dates with specific values
func createDate(month: Int, day: Int, year: Int = 2025) -> Date {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    return Calendar.current.date(from: components) ?? Date()
}

func createTime(month: Int, day: Int, hour: Int, minute: Int, year: Int = 2025) -> Date {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    components.hour = hour
    components.minute = minute
    return Calendar.current.date(from: components) ?? Date()
}

#Preview {
    EventsSectionView()
}
