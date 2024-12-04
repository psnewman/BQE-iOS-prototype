import SwiftUI

struct TimeCardSectionView: View {
    // Add sample data
    let sampleDays: [TimeCardDayView] = [
        TimeCardDayView(day: "Mon", date: "Apr 1", timeTracked: "4.99"),
        TimeCardDayView(day: "Tue", date: "Apr 2", timeTracked: "5.50"),
        TimeCardDayView(day: "Wed", date: "Apr 3", timeTracked: "6.25"),
        TimeCardDayView(day: "Thu", date: "Apr 4", timeTracked: "4.75"),
        TimeCardDayView(day: "Fri", date: "Apr 5", timeTracked: "5.00"),
        TimeCardDayView(day: "Sat", date: "Apr 6", timeTracked: "2.50"),
        TimeCardDayView(day: "Sun", date: "Apr 7", timeTracked: "0.00")
    ]

    var body: some View {
        HStack {
            ForEach(sampleDays, id: \.date) { dayView in
                dayView
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 0)
        .frame(maxWidth: .infinity)
        .cornerRadius(4)
    }
}

struct TimeCardDayView: View {
    let day: String
    let date: String
    let timeTracked: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            
            VStack() {
                Text(day)
                    .font(Font.custom("Inter", size: 10))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.typographySecondary)
                
                Text(date)
                    .bodySmallStyle()
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.typographyPrimary)
            }
            Divider().background(.divider)
                .padding(.horizontal, 16)
            
            Text(timeTracked)
                .bodySmallBoldStyle()
              .multilineTextAlignment(.center)
              .foregroundColor(.typographyPrimary)
        }
        .padding(.horizontal, 0)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, minHeight: 64, maxHeight: 64, alignment: .top)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .inset(by: 0.5)
                .stroke(.border, lineWidth: 1)
        )
    }
}

#Preview {
    TimeCardSectionView()
}
