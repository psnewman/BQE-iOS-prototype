import SwiftUI
import FASwiftUI

struct ExpenseHeaderView: View {
    let expenseType: EntryType
    let expenseName: String
    let costAmount: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    FAText(iconName: expenseType.icon, size: 16)
                        .foregroundColor(Color.secondary)
                    Text(expenseName)
                        .bodyStyle()                    
                }
            }
            Spacer()
            Text(costAmount)
                .bodyStyle()
        }
    }
}

#Preview {
    ExpenseHeaderView(expenseType: .expense, expenseName: "Sample Expense", costAmount: "$100.00")
}
