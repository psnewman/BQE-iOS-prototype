import SwiftUI

class CardStackViewModel: ObservableObject {
  @Published var cards: [EntryItem] = []
  @Published var approvedCards: [EntryItem] = []
  @Published var rejectedCards: [EntryItem] = []
  @Published var skippedCards: [EntryItem] = []
  @Published var expensesLeft: Int = 10
  @Published var shouldShowSuccess: Bool = false
  @Published var cardState: [UUID: CardState] = [:]
  @Published var showUndoButton: Bool = false


  struct CardState {
    var offset: CGSize = .zero
    var scale: CGSize = CGSize(
      width: CardAnimationConfig.baseScale, height: CardAnimationConfig.baseScale)
    var zIndex: Int = 0
    var isSkipping: Bool = false
  }

  init() {
    loadSampleCards()
  }

  func removeTopCard(isApproved: Bool) {
    guard let topCard = cards.first else { return }

    print("Removing top card: \(topCard.entryName), Approved: \(isApproved)") // Debugging output

    if isApproved {
      approvedCards.append(topCard)
    } else {
      rejectedCards.append(topCard)
    }

    cards.removeFirst()
    expensesLeft = max(0, expensesLeft - 1)
    showUndoButton = true

    if cards.isEmpty {
      shouldShowSuccess = true
    }
  }

  func skipTopCard() {
    guard let topCard = cards.first else { return }
    let cardWidth = UIScreen.main.bounds.width - 32

    // Start skip animation
    withAnimation(.easeInOut(duration: 0.6)) {
        var state = cardState[topCard.id] ?? CardState()
        state.isSkipping = true
        state.offset = CGSize(width: cardWidth / 2, height: 0)
        state.scale = CGSize(
            width: CardAnimationConfig.maxScale, height: CardAnimationConfig.maxScale)
        cardState[topCard.id] = state
    }

    // Reset card position and move it to the end of the stack
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
        var state = self.cardState[topCard.id] ?? CardState()
        state.zIndex = -1
        state.offset = .zero
        state.scale = CGSize(
            width: CardAnimationConfig.baseScale, height: CardAnimationConfig.baseScale)
        self.cardState[topCard.id] = state

        // Update card order
        if let index = self.cards.firstIndex(where: { $0.id == topCard.id }) {
            self.cards.remove(at: index)
            self.cards.append(topCard)
        }
        self.skippedCards.append(topCard)
        
        // Add these lines to handle undo button visibility
        self.showUndoButton = true
        
        // Print debug information
        print("After skipping:")
        print("Cards: \(self.cards.map { $0.entryName })")
        print("Skipped Cards: \(self.skippedCards.map { $0.entryName })")
        print("Approved Cards: \(self.approvedCards.map { $0.entryName })")
        print("Rejected Cards: \(self.rejectedCards.map { $0.entryName })")
    }
}


  func getCardState(_ cardId: UUID) -> CardState {
    return cardState[cardId] ?? CardState()
  }

  func resetCards() {
    loadSampleCards()
    approvedCards.removeAll()
    rejectedCards.removeAll()
    skippedCards.removeAll()
    expensesLeft = 10
    shouldShowSuccess = false
  }

  func undoLastAction() {
    if let lastSkipped = skippedCards.last {
      skippedCards.removeLast()
      cards.insert(lastSkipped, at: 0)
      expensesLeft += 1
      shouldShowSuccess = false
      cardState[lastSkipped.id] = CardState()
      showUndoButton = false

      // Print debug information
      print("After undoing skipped card:")
      print("Cards: \(self.cards.map { $0.entryName })")
      print("Skipped Cards: \(self.skippedCards.map { $0.entryName })")
      print("Approved Cards: \(self.approvedCards.map { $0.entryName })")
      print("Rejected Cards: \(self.rejectedCards.map { $0.entryName })")
    } else if let lastApproved = approvedCards.last {
      approvedCards.removeLast()
      cards.insert(lastApproved, at: 0)
      expensesLeft += 1
      shouldShowSuccess = false
      cardState[lastApproved.id] = CardState()
      showUndoButton = false

      // Print debug information
      print("After undoing approved card:")
      print("Cards: \(self.cards.map { $0.entryName })")
      print("Skipped Cards: \(self.skippedCards.map { $0.entryName })")
      print("Approved Cards: \(self.approvedCards.map { $0.entryName })")
      print("Rejected Cards: \(self.rejectedCards.map { $0.entryName })")
    } else if let lastRejected = rejectedCards.last {
      rejectedCards.removeLast()
      cards.insert(lastRejected, at: 0)
      expensesLeft += 1
      shouldShowSuccess = false
      cardState[lastRejected.id] = CardState()
      showUndoButton = false

      // Print debug information
      print("After undoing rejected card:")
      print("Cards: \(self.cards.map { $0.entryName })")
      print("Skipped Cards: \(self.skippedCards.map { $0.entryName })")
      print("Approved Cards: \(self.approvedCards.map { $0.entryName })")
      print("Rejected Cards: \(self.rejectedCards.map { $0.entryName })")
    }
  }

  private func loadSampleCards() {
    let cardViewModel = CardViewModel()
    cards = cardViewModel.generateSampleCards()
    expensesLeft = cards.count
  }
}
