#if DEBUG
import Foundation

extension TimeCardActivityEntry {
    static func sample(projectIndex: Int) -> TimeCardActivityEntry {
        let projects: [String] = [
            "19-34 - Aspen Cultural Center",
            "20-04 - Bradford Residence",
            "00-00 - Fountainhead A+E",
            "20-02 - Long Beach Sports",
            "19-08 - Pasadena Elementary School",
            "19-03 - Santa Monica Science Center",
            "20-08 - Spotlight Theaters",
            "19-24 - McCormick Residence",
            "19-14 - Warner Residence",
            "21-05 - Riverside Medical Center"
        ]
        
        let activities: [String] = [
            "PTO:Vacation",
            "Design:Elevations",
            "Meeting:Client",
            "Design:Floor Plans",
            "Meeting:Internal",
            "Design:Sections",
            "Admin:Documentation",
            "Meeting:Consultant",
            "Design:Details",
            "Admin:Email"
        ]
        
        let descriptions: [String] = [
            "PTO:Vacation - PTO Request approved by Steven Burns",
            "Elevations",
            "Client Meeting",
            "Floor Plans Development",
            "Internal Team Review",
            "Section Details",
            "Project Documentation",
            "Consultant Coordination",
            "Detail Development",
            "Email Correspondence"
        ]
        
        return TimeCardActivityEntry(
            id: UUID(),
            title: projects[projectIndex],
            subtitle: "\(activities[projectIndex]) | \(descriptions[projectIndex])",
            dailyHours: (1...7).map { dayIndex in
                DailyHours(
                    id: UUID(),
                    day: "\(dayIndex)",
                    hours: Double.random(in: 0.5...8.0).rounded(toPlaces: 1)
                )
            }
        )
    }
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor: Double = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
#endif
