import FASwiftUI
import SwiftUI

struct WeekPickerView: View {
    @Binding var selectedWeek: Date

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    // Previous week action
                }) {
                    FAText(iconName: "chevron-left", size: 16, style: .regular)
                        .foregroundColor(.typographyPrimary)
                }
                Text("\(formattedDateRange(for: selectedWeek))")
                    .bodyBoldStyle()
                    .foregroundColor(.typographyPrimary)
                Button(action: {
                    // Next week action
                }) {
                    FAText(iconName: "chevron-right", size: 16, style: .regular)
                        .foregroundColor(.typographyPrimary)
                }
                Spacer()
                Button(action: {
                    // Today action
                }) {
                    Text("Today")
                        .bodyStyle()
                        .foregroundColor(.masterPrimary)
                }

            }
            .frame(height: 48)
            Divider()
                .background(.divider)
        }
        .padding(.horizontal, 16)
        .background(Color.masterBackground)
    }

    private func formattedDateRange(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let startDate = date.startOfWeek
        let endDate = Calendar.current.date(
            byAdding: .day,
            value: 6,
            to: startDate
        )!
        return
            "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
    }
}

#Preview {
    WeekPickerView(selectedWeek: .constant(Date()))
}
