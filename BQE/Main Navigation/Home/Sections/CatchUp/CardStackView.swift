import FASwiftUI
import SwiftUI

struct CardStackView: View {
  @StateObject private var viewModel: CardViewModel = CardViewModel()
  @State private var selectedEntryType: EntryType = .expense
  @State private var skipAnimation: Bool = false

  var body: some View {
    VStack(spacing: 16) {
      FilterEntryType(selectedEntryType: $selectedEntryType)

      VStack(spacing: 16) {
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
              let isTopCard: Bool = card.id == viewModel.cards.first?.id
              let isNextCard: Bool = viewModel.cards.count > 1 && card.id == viewModel.cards[1].id

              CardView(
                card: card,
                isTopCard: isTopCard,
                isNextCard: isNextCard,
                skipAnimation: isTopCard ? $skipAnimation : .constant(false),
                onRemove: { isApproved in
                  viewModel.removeTopCard(isApproved: isApproved)
                }
              )
              .id(card.id)
              .zIndex(
                Double(
                  viewModel.cards.count
                    - (viewModel.cards.firstIndex(where: { $0.id == card.id }) ?? 0)))
            }
          }
        }
        .frame(idealHeight: 360)

        //                Stack toolbar
        HStack {
          Text("\(viewModel.expensesLeft) left")
            .bodyStyle()
            .foregroundColor(.typographyPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: {
                // Add undo functionality
            }) {
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        FAText(iconName: "arrow-rotate-left", size: 12)
                            .foregroundColor(.masterPrimary)
                        
                        Text("Undo")
                            .bodySmallStyle()
                            .foregroundColor(.masterPrimary)
                    }
                    ZStack {
                        Circle()
                            .fill(.white)
                            .stroke(.masterPrimary, lineWidth: 1)
                            .frame(width: 16, height: 16)
                        Text("5")  // Add dynamic count here later
                            .bodySmallStyle()
                            .foregroundColor(.masterPrimary)
                    }
                }
                .frame(maxHeight: 24)
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 4))
                .background(Color.masterPrimary.opacity(0.1))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(.masterPrimary, lineWidth: 1))
                .cornerRadius(20)
            }
            
          Button(action: {
            if viewModel.cards.first != nil {
              skipAnimation = true
            }
          }) {
            HStack(spacing: 4) {
              FAText(iconName: "forward", size: 16)
              Text("Skip")
            }
          }
          .bodyStyle()
          .foregroundColor(.masterPrimary)
          .frame(maxWidth: .infinity, alignment: .trailing)

        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, minHeight: 24)

      }
    }
    .onAppear {
      viewModel.loadCards()
    }
  }
}

// MARK: - Helper Methods
extension CardStackView {
  private func findCardView(withId id: UUID) -> CardView? {
    return Mirror(reflecting: self)
      .children
      .lazy
      .compactMap { $0.value as? CardView }
      .first { $0.getCardId() == id }
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
          .foregroundColor(.typographySecondary)

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
  CardStackView()
}
