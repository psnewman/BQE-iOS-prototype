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
  @Published var lastAction: CardAction?
  @Published var topCardOffset: CGSize = .zero

  struct CardState {
    var offset: CGSize = .zero
    var scale: CGSize = CGSize(
      width: CardAnimationConfig.baseScale,
      height: CardAnimationConfig.baseScale
    )
    var zIndex: Double = 0
    var isSkipping: Bool = false
    var rotation: Double = 0
    var isUndoing: Bool = false
    var undoSource: String? = nil
    var action: CardAction? = nil
  }

  init() {
    loadSampleCards()
  }

  enum CardAction {
    case approved
    case rejected
    case skipped
  }

  func removeTopCard(isApproved: Bool) {
    guard let topCard = cards.first else { return }

    // Update card state with action
    var state = cardState[topCard.id] ?? CardState()
    if isApproved {
      approvedCards.append(topCard)
      lastAction = .approved
      state.action = .approved
    } else {
      rejectedCards.append(topCard)
      lastAction = .rejected
      state.action = .rejected
    }
    cardState[topCard.id] = state

    cards.removeFirst()
    withAnimation { expensesLeft = max(0, expensesLeft - 1) }
    showUndoButton = true
    checkAndUpdateSuccessState()  // Check after removing card
  }

  func skipTopCard() {
    guard let topCard = cards.first, cards.count > 1 else { return }
    let screenWidth = UIScreen.main.bounds.width

    // Set action state before animation
    lastAction = .skipped
    showUndoButton = true

    // var state: CardStackViewModel.CardState = cardState[topCard.id] ?? CardState()
    // state.isSkipping = true
    // cardState[topCard.id] = state

    // Move the card off-screen to the right
      withAnimation(.easeIn(duration: 0.5)) {
      var state: CardStackViewModel.CardState = cardState[topCard.id] ?? CardState()
      state.offset = CGSize(width: screenWidth, height: 0)
      state.rotation = 0
      state.action = .skipped
      cardState[topCard.id] = state
      topCardOffset = state.offset
    } completion: {
        // Reset the flag in completion handler
        if var state = self.cardState[topCard.id] {
          state.isSkipping = false
          self.cardState[topCard.id] = state
      }

      // Add a copy to the skipped cards array for tracking
      self.skippedCards.append(topCard)

      // Remove card from its current position
      if let index = self.cards.firstIndex(where: { $0.id == topCard.id }) {
        self.cards.remove(at: index)

        // Move the card to the end of the stack
        self.cards.append(topCard)
        withAnimation(.easeInOut(duration: 0.2)) {
          var state = self.cardState[topCard.id] ?? CardState()
          state.offset = .zero
          state.rotation = 0

          // Reset the action state completely for recycled cards
          state.action = nil
          self.cardState[topCard.id] = state
          self.topCardOffset = .zero
        }

        self.updateCardZIndices()
      }
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

  func positionCardForUndo(card: EntryItem, from source: String) {
    let screenWidth = UIScreen.main.bounds.width - 32
    var state = cardState[card.id] ?? CardState()

    state.isUndoing = true
    state.undoSource = source
    state.action = nil  // Reset action

    switch source {
    case "approved":
      state.offset = CGSize(width: screenWidth, height: 0)
      state.rotation = CardAnimationConfig.rotationFactor
    case "rejected":
      state.offset = CGSize(width: -screenWidth, height: 0)
      state.rotation = -CardAnimationConfig.rotationFactor
    case "skipped":
      state.offset = CGSize(width: screenWidth, height: 0)
      state.rotation = 10  // Match the skip rotation for consistency
    default:
      break
    }

    cardState[card.id] = state

    // Ensure the state is updated before animation starts
    DispatchQueue.main.async {
      self.objectWillChange.send()
    }
  }

  func updateMemo(for cardId: UUID, memo: String) {
    if let index = cards.firstIndex(where: { $0.id == cardId }) {
      cards[index].memo = memo
      objectWillChange.send()  // Force update
    }
    if let index = approvedCards.firstIndex(where: { $0.id == cardId }) {
      approvedCards[index].memo = memo
      objectWillChange.send()  // Force update
    }
    if let index = rejectedCards.firstIndex(where: { $0.id == cardId }) {
      rejectedCards[index].memo = memo
      objectWillChange.send()  // Force update
    }
    if let index = skippedCards.firstIndex(where: { $0.id == cardId }) {
      skippedCards[index].memo = memo
      objectWillChange.send()  // Force update
    }
  }

  func undoLastAction() {

    // Clear any existing undo states
    for (id, _) in cardState {
      var state = cardState[id] ?? CardState()
      state.isUndoing = false
      state.undoSource = nil
      cardState[id] = state
    }

    guard let action = lastAction else { return }

    switch action {
    case .skipped:
      if let lastSkipped = skippedCards.last {
        handleUndo(card: lastSkipped, from: "skipped", array: &skippedCards)
      }
    case .approved:
      if let lastApproved = approvedCards.last {
        handleUndo(card: lastApproved, from: "approved", array: &approvedCards)
      }
    case .rejected:
      if let lastRejected = rejectedCards.last {
        handleUndo(card: lastRejected, from: "rejected", array: &rejectedCards)
      }
    }

    lastAction = nil
  }

  private func handleUndo(card: EntryItem, from source: String, array: inout [EntryItem]) {

    // Position the card before animation
    positionCardForUndo(card: card, from: source)

    // Remove from source array
    array.removeLast()

    // Remove any existing instances of the card from the main array
    cards.removeAll(where: { $0.id == card.id })

    DispatchQueue.main.async {
      self.cards.insert(card, at: 0)

      self.checkAndUpdateSuccessState()  // Check after inserting card

      // Animate the card back
      withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
        var state = self.cardState[card.id] ?? CardState()
        state.offset = .zero
        state.rotation = 0
        state.isSkipping = false
        state.zIndex = 0
        self.cardState[card.id] = state
      }

      // Reset undo state after animation
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
        var state = self.cardState[card.id] ?? CardState()
        state.isUndoing = false
        state.undoSource = nil
        state.isSkipping = false
        state.zIndex = 0
        self.cardState[card.id] = state

        self.checkAndUpdateSuccessState()  // Check after animation completes
      }
    }

    if source != "skipped" {
      withAnimation { expensesLeft += 1 }
    }

    showUndoButton = false
    lastAction = nil
  }

  private func updateCardZIndices() {
    let total = Double(cards.count)
    for (index, card) in cards.enumerated() {
      var state = cardState[card.id] ?? CardState()

      // Determine if this card is the top card
      let isTopCard = index == 0

      // Set z-index based on position in the stack
      state.zIndex = total - Double(index)

      // If a card has been skipped and is not the top card, ensure it's properly reset for visual purposes
      if state.action == .skipped && !isTopCard {
        state.offset = .zero
        state.rotation = 0
      }

      // If this is the top card, ensure it doesn't have a skip action to allow interaction
      if isTopCard && state.action == .skipped {
        state.action = nil
      }

      cardState[card.id] = state
    }
  }

  func checkAndUpdateSuccessState() {

    // Update success state whenever cards array becomes empty
    if cards.isEmpty {
      shouldShowSuccess = true
    } else {
      shouldShowSuccess = false
    }
  }

  private func loadSampleCards() {
    let cardViewModel = CardViewModel()
    cards = cardViewModel.generateSampleCards()
    expensesLeft = cards.count
  }
}
