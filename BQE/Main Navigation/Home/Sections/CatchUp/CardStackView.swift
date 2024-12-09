import FASwiftUI
import RiveRuntime
import SwiftUI

struct CardStackView: View {
  @StateObject private var stackViewModel: CardStackViewModel = CardStackViewModel()
  @State private var selectedEntryType: EntryType = .expense
  @State private var skipAnimation: Bool = false
  @State private var showUndoButton: Bool = false
  @State private var undoCounter: Int = 5
  @State private var undoTimer: Timer? = nil
  @StateObject private var successAnimation = RiveViewModel(
    fileName: "success",
    stateMachineName: "State Machine 1",
    autoPlay: false
  )

  var body: some View {
    VStack(spacing: 16) {
      FilterEntryType(selectedEntryType: $selectedEntryType)

      VStack(spacing: 16) {
        ZStack {
          if stackViewModel.cards.isEmpty {
            VStack(spacing: 32) {
              VStack(alignment: .center, spacing: -24) {
                successAnimation.view()
                  .frame(width: 200, height: 200)
                VStack(spacing: 8) {
                  Text("Well done!")
                    .titleStyle()
                  Text("Caught up with all items")
                    .bodyStyle()
                }
              }
            }
          } else {
            ForEach(stackViewModel.cards, id: \.id) { card in
              let isTopCard: Bool = card.id == stackViewModel.cards.first?.id
              let isNextCard: Bool =
                stackViewModel.cards.count > 1 && card.id == stackViewModel.cards[1].id

              CardView(
                card: card,
                isTopCard: isTopCard,
                isNextCard: isNextCard,
                skipAnimation: isTopCard ? $skipAnimation : .constant(false),
                onRemove: { isApproved in

                  stackViewModel.removeTopCard(isApproved: isApproved)
                  showUndoButton = true
                  undoCounter = 5
                  undoTimer?.invalidate()
                  undoTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    if undoCounter > 1 {
                      undoCounter -= 1
                    } else {
                      undoCounter = 5
                      showUndoButton = false
                      timer.invalidate()
                    }
                  }
                }
              )
              .id(card.id)
              .zIndex(
                Double(
                  stackViewModel.cards.count
                    - (stackViewModel.cards.firstIndex(where: { $0.id == card.id }) ?? 0)))
            }
          }
        }
        .onChange(of: stackViewModel.cards.count) { oldValue, newValue in
          if newValue == 0 {
            successAnimation.triggerInput("startSuccessAnimation")
          }
        }
        .frame(idealHeight: 360)

//          Stack toolbar
        HStack {
          Text("\(stackViewModel.expensesLeft) left")
            .bodyStyle()
            .foregroundColor(.typographyPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .opacity(!stackViewModel.shouldShowSuccess ? 1 : 0)

          Button(action: {
            stackViewModel.undoLastAction()
            showUndoButton = false
            undoTimer?.invalidate()
          }) {
            UndoButtonView(counter: undoCounter)
          }
          .opacity(showUndoButton ? 1 : 0)
          .animation(.easeInOut, value: showUndoButton)

          Button(action: {
            if stackViewModel.cards.first != nil {
              skipAnimation = true
              stackViewModel.skipTopCard()
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
          .opacity(!stackViewModel.shouldShowSuccess ? 1 : 0)

        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, minHeight: 24)
      }
    }
    .onAppear {
      stackViewModel.resetCards()
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
    HStack(spacing: 24) {
      Menu {
        ForEach(EntryType.allCases, id: \.self) { type in
          Button(type.rawValue) {
            selectedEntryType = type
          }
        }
      } label: {
        HStack(spacing: 24) {
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
      .frame(maxWidth: .infinity, alignment: .leading)

      Button {
        print("View All")
      } label: {
        HStack(alignment: .center) {
          Text("View All")
            .bodyStyle()
            .foregroundStyle(.masterPrimary)
          FAText(iconName: "chevron-right", size: 12)
            .foregroundColor(.masterPrimary)
        }
      }
      .buttonStyle(.plain)
    }
  }
}

#Preview {
  CardStackView()
}
