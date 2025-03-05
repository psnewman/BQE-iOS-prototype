import FASwiftUI
import SwiftUI

struct EntryHeaderView: View {
  let entryType: EntryType
  let entryName: String
  let billedAmount: String
  let billable: BillableStatus

  var tagType: TagView.TagType {
    switch billable {
    case .nonBillable:
      return .red
    case .billable:
      return .grey
    case .billed:
      return .green
    }
  }

  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 0) {
        NavigationLink(destination: TimeEntryView()) {
          HStack {
            Text(entryName)
              .bodyBoldStyle()
              .foregroundColor(.typographyPrimary)
              .lineLimit(1)
              .truncationMode(.tail)
            FAText(iconName: "chevron-right", size: 12)
              .foregroundColor(.typographyPrimary)
          }
        }
      }
      Spacer()
      TagView(text: billedAmount, type: tagType)
    }
  }
}

#Preview {
  EntryHeaderView(
    entryType: .expense,
    entryName: "Sample ExpenseSample ExpenseSample ExpenseSample Expense",
    billedAmount: "$100.00",
    billable: .billable
  )
}
