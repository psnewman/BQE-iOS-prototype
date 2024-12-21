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
    
    
    struct CardState {
        var offset: CGSize = .zero
        var scale: CGSize = CGSize(width: CardAnimationConfig.baseScale, height: CardAnimationConfig.baseScale)
        var zIndex: Int = 0
        var isSkipping: Bool = false
        var rotation: Double = 0
        var isUndoing: Bool = false // Add this to track undo state
        var undoSource: String? = nil // Add this to track where the card is being undone from
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
                        
            if isApproved {
                approvedCards.append(topCard)
                lastAction = .approved
            } else {
                rejectedCards.append(topCard)
                lastAction = .rejected
            }
            
            cards.removeFirst()
            expensesLeft = max(0, expensesLeft - 1)
            showUndoButton = true
            checkAndUpdateSuccessState()  // Check after removing card
        }

    func skipTopCard() {
            guard let topCard = cards.first else { return }
            let cardWidth = UIScreen.main.bounds.width - 32
            
            // Reset any existing skip states
            for (id, _) in cardState {
                var state = cardState[id] ?? CardState()
                state.isSkipping = false
                cardState[id] = state
            }
            
            // Start skip animation
            withAnimation(.easeInOut(duration: 0.6)) {
                var state = cardState[topCard.id] ?? CardState()
                state.isSkipping = true
                state.offset = CGSize(width: cardWidth, height: 0)
                state.scale = CGSize(
                    width: CardAnimationConfig.maxScale,
                    height: CardAnimationConfig.maxScale
                )
                cardState[topCard.id] = state
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                if let index = self.cards.firstIndex(where: { $0.id == topCard.id }) {
                    self.cards.remove(at: index)
                }
                
                var state = self.cardState[topCard.id] ?? CardState()
                state.isSkipping = false
                self.cardState[topCard.id] = state
                self.cards.append(topCard)
                self.skippedCards.append(topCard)
                self.lastAction = .skipped
                self.showUndoButton = true
                self.checkAndUpdateSuccessState()
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
        
        switch source {
        case "approved":
            state.offset = CGSize(width: screenWidth, height: 0)
            state.rotation = CardAnimationConfig.rotationFactor
        case "rejected":
            state.offset = CGSize(width: -screenWidth, height: 0)
            state.rotation = -CardAnimationConfig.rotationFactor
        case "skipped":
            state.offset = CGSize(width: screenWidth, height: 0)
            state.rotation = 0
            state.isSkipping = false  // Reset skipping state immediately
        default:
            break
        }
        
        cardState[card.id] = state
        
        // Ensure the state is updated before animation starts
        DispatchQueue.main.async {
            self.objectWillChange.send()
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
            expensesLeft += 1
        }
        
        showUndoButton = false
        lastAction = nil
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
