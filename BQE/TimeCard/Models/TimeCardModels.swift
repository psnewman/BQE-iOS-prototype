import Foundation

struct TimeCardActivityEntry: Identifiable {
    let id: UUID
    let title: String
    let subtitle: String
    let dailyHours: [DailyHours]
}

struct DailyHours: Identifiable {
    let id: UUID
    let day: String
    let hours: Double
}
