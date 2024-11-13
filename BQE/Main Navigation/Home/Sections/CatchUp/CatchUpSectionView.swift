import SwiftUI
import SVGView
import FASwiftUI

enum EntryType: String, CaseIterable {
    case timeAndExpense = "Time & Expense"
    case time = "Time"
    case expense = "Expense"
    
    var icon: String {
        switch self {
        case .timeAndExpense: return "timer"
        case .time: return "stopwatch"
        case .expense: return "cart-shopping"
        }
    }
}



struct ExpenseCard: Identifiable {
    let id = UUID()
    let expenseType: EntryType
    let expenseName: String
    let date: String
    let resource: String
    let project: String
    let client: String
    let units: String
    let costRate: String
    let costAmount: String
    
    var formattedCostAmount: String {
        return costAmount
    }
}

struct CatchUpSectionView: View {
    @StateObject private var viewModel = CatchUpCardViewModel()
    @State private var selectedExpense: EntryType = .expense

    var body: some View {
        VStack(spacing: 24) {
            FilterEntryType(selectedEntryType: $selectedExpense)

            VStack(spacing: 16) {
                HStack(alignment: .center) {
                    Text("\(viewModel.expensesLeft) left")
                        .bodyStyle()
                        .foregroundColor(.typographyPrimary)
                    Spacer()
                    Button("Undo") {
                        // Add undo functionality
                    }
                    .bodyStyle()
                    .foregroundColor(.masterPrimary)
                }
                .frame(maxWidth: .infinity)

                ZStack {
                    if viewModel.cards.isEmpty {
                        Button("Repeat") {
                            viewModel.resetCards()
                        }
                        .bodyStyle()
                        .foregroundColor(.masterPrimary)
                        .padding()
                        .background(.masterBackground)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.border, lineWidth: 1)
                        )
                    } else {
                        ForEach(viewModel.cards, id: \.id) { card in
                            let isTopCard = card.id == viewModel.cards.first?.id
                            let isNextCard = viewModel.cards.count > 1 && card.id == viewModel.cards[1].id
                            
                            CatchUpCardView(
                                card: card,
                                isTopCard: isTopCard,
                                isNextCard: isNextCard,
                                onRemove: { isApproved in
                                    viewModel.removeTopCard(isApproved: isApproved)
                                }
                            )
                            .zIndex(Double(viewModel.cards.count - (viewModel.cards.firstIndex(where: { $0.id == card.id }) ?? 0)))
                        }
                    }
                }
                .frame(height: 400)
            }
        }
        .onAppear {
            viewModel.loadCards()
        }
    }
}

struct FilterEntryType: View {
    @Binding var selectedEntryType: EntryType

    var body: some View {
        Menu {
            ForEach(EntryType.allCases, id: \.self) { type in
                Button(type.rawValue) {
                    selectedEntryType = type
                }
            }
        } label: {
            HStack(spacing: 8) {
                FAText(iconName: "filter", size: 16)
                    .foregroundColor(.typographyPrimary)

                Text(selectedEntryType.rawValue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bodyStyle()
                    .foregroundColor(.typographyPrimary)

                FAText(iconName: "chevron-down", size: 12)
                    .foregroundColor(.typographySecondary)
            }
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
            .frame(maxWidth: .infinity, minHeight: 40)
            .background(.masterBackground)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.5)
                    .stroke(.border, lineWidth: 0.5)
            )
        }
    }
}

#Preview {
    CatchUpSectionView()
}
