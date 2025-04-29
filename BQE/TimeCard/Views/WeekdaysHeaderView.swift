import SwiftUI

struct WeekdaysHeaderView: View {
  @Binding var selectedWeek: Date

  var body: some View {
    HStack(spacing: 0) {
      ForEach(0..<7) { index in
        VStack(alignment: .center, spacing: 4) {
          Text(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][index])
                .bodySmallBoldStyle()            .foregroundColor(.typographyPrimary)
          Text(formattedDate(for: selectedWeek, dayIndex: index))
            .bodySmallStyle()
            .foregroundColor(.typographyPrimary)
        }
        .frame(maxWidth: .infinity)
      }
    }
    .frame(height: 56)
    .padding(.bottom, 8)
    .padding(.horizontal, 16)
    .overlay(
      Rectangle()
        .frame(height: 1)
        .foregroundColor(.border),
      alignment: .bottom
    )    
  }

  private func formattedDate(for date: Date, dayIndex: Int) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d"
    let startDate = date.startOfWeek
    let targetDate = Calendar.current.date(byAdding: .day, value: dayIndex, to: startDate)!
    return formatter.string(from: targetDate)
  }
}

#Preview {
    WeekdaysHeaderView(selectedWeek: .constant(Date()))
}
