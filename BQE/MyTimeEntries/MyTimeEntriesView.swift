import FASwiftUI
import SwiftUI

struct MyTimeEntriesView: View {
    var body: some View {
        WeekPickerView(selectedWeek: .constant(Date()))
        ScrollView(.horizontal) {
            HStack(spacing: 16) {
                TimerView()
                TimerView()
            }
            .padding(16)
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    MyTimeEntriesView()
}
