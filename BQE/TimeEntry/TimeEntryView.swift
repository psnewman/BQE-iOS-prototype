import SwiftUI

struct TimeEntryView: View {

  // State variables
  @State private var showFields: Bool = false
  @State private var employee: String = "Steven Burns"
  @State private var project: String = "00-00 - FOUNTAINHEAD: Paid Time Off"
  @State private var activity: String = "PTO:Vacation"
  @State private var description: String = "PTO:Vacation - PTO Request Approved by Steven Burns"
  @State private var hours: String = "1.00"
  @State private var date: Date = Date(timeIntervalSince1970: 1_732_665_600)  // Nov 28, 2024

  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        // Show/Hide Fields Toggle
        HStack {
          Image(systemName: showFields ? "checkmark.square.fill" : "square")
            .foregroundColor(.masterPrimary)
          Text("Show/Hide Fields")
            .foregroundColor(.masterPrimary)
          Spacer()
        }
        .onTapGesture {
          showFields.toggle()
        }
        .padding(.bottom, 10)

        // Form Fields
        VStack(spacing: 24) {
          fieldRow(title: "Employee", value: employee)
          fieldRow(title: "Project", value: project)
          fieldRow(title: "Activity", value: activity)

          // Description Field
          VStack(alignment: .leading, spacing: 8) {
            Text("Description")
              .foregroundColor(.typographySecondary)
            Text(description)
              .foregroundColor(.typographyPrimary)
          }
          .frame(maxWidth: .infinity, alignment: .leading)

          // Hours Field
          VStack(alignment: .leading, spacing: 8) {
            Text("Hours")
              .foregroundColor(.typographySecondary)
            Text(hours)
              .foregroundColor(.typographyPrimary)
          }
          .frame(maxWidth: .infinity, alignment: .leading)

          // Date Field
          VStack(alignment: .leading, spacing: 8) {
            Text("Date")
              .foregroundColor(.typographySecondary)
            Text(formatDate(date))
              .foregroundColor(.typographyPrimary)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
        }
      }
      .padding()
    }
    .background(.masterBackground)
    .navigationTitle("Edit Time Entry")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("Save") {
          // Saving logic...
        }
      }
    }
//    .tint(.white)
  }

  private func fieldRow(title: String, value: String) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .foregroundColor(.typographySecondary)
      HStack {
        Text(value)
          .foregroundColor(.typographyPrimary)
        Spacer()
        Image(systemName: "chevron.right")
          .foregroundColor(.typographySecondary)
      }
    }
  }

  private func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "E, MMM d, yyyy"
    return formatter.string(from: date)
  }
}

#Preview {
  NavigationView {
    TimeEntryView()
  }
}
