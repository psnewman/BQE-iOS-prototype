// CardStackView is responsible for displaying a stack of cards related to user entries, allowing users to filter and manage their entries interactively.
import FASwiftUI
import RiveRuntime
import SwiftUI

struct CardStackView: View {
  // ViewModel for managing the state of the card stack, including the logic for card removal and filtering.
  @StateObject private var stackViewModel: CardStackViewModel = CardStackViewModel()
  @State private var selectedEntryType: EntryType = .expense
  @State private var undoCounter: Int = 5
  @State private var undoTimer: Timer? = nil
  @StateObject private var successAnimation = RiveViewModel(
    fileName: "success",
    stateMachineName: "State Machine 1",
    autoPlay: false
  )

  var body: some View {
    VStack(spacing: 16) {
      // Filter component for selecting entry type.
      FilterEntryType(selectedEntryType: $selectedEntryType, stackViewModel: stackViewModel)

      VStack(spacing: 16) {
        ZStack {
          // If there are no cards, display a success message.
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
            // Render each card in the stack, displaying the top card and the next card for user interaction.
            ForEach(stackViewModel.cards, id: \.id) { card in
              let isTopCard: Bool = card.id == stackViewModel.cards.first?.id
              let isNextCard: Bool =
                stackViewModel.cards.count > 1 && card.id == stackViewModel.cards[1].id

              CardView(
                card: card,
                isTopCard: isTopCard,
                isNextCard: isNextCard,
                viewModel: stackViewModel,
                onRemove: { isApproved in
                  // Handle card removal logic, including showing the undo button.
                  stackViewModel.removeTopCard(isApproved: isApproved)
                  undoCounter = 5
                  undoTimer?.invalidate()
                  undoTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    if undoCounter > 1 {
                      undoCounter -= 1
                    } else {
                      undoCounter = 5
                      stackViewModel.showUndoButton = false
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
        .onChange(of: stackViewModel.shouldShowSuccess) { oldValue, newValue in
          
          if newValue {
            successAnimation.triggerInput("startSuccessAnimation")
          }
        }

        // Todo: try to avoid fixed height
        .frame(minHeight: 334)

        // Stack toolbar
        HStack {
          Text("\(stackViewModel.expensesLeft) left")
            .bodyStyle()
            .foregroundColor(.typographyPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .opacity(!stackViewModel.shouldShowSuccess ? 1 : 0)

          Button(action: {
            stackViewModel.undoLastAction()
            stackViewModel.showUndoButton = false
            undoTimer?.invalidate()
          }) {
            UndoButtonView(counter: undoCounter)
          }
          .opacity(stackViewModel.showUndoButton ? 1 : 0)
          .animation(.easeInOut, value: stackViewModel.showUndoButton)

          Button(action: {
            if stackViewModel.cards.first != nil {
              stackViewModel.skipTopCard()
              undoCounter = 5  // Reset counter
              undoTimer?.invalidate()  // Invalidate any existing timer
              undoTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if undoCounter > 1 {
                  undoCounter -= 1
                } else {
                  undoCounter = 5
                  stackViewModel.showUndoButton = false
                  timer.invalidate()
                }
              }
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
          .disabled(stackViewModel.cards.count <= 1)
          .opacity(stackViewModel.cards.count > 1 ? 1 : (stackViewModel.cards.count == 0 ? 0 : 0.5))       
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
  @ObservedObject var stackViewModel: CardStackViewModel = CardStackViewModel()

  var body: some View {
    HStack(spacing: 24) {
      Menu {
        ForEach(EntryType.allCases, id: \.self) { type in
          Button(type.rawValue) {
            selectedEntryType = type
          }
        }
      } label: {
        HStack(spacing: 8) {
          FAText(iconName: selectedEntryType.icon, size: 12)
            .foregroundColor(.typographySecondary)

          Text("\(selectedEntryType.rawValue) (\(stackViewModel.expensesLeft))")
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
        // Navigate to the dedicated screen
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
