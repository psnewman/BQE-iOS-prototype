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
            
            print("\n=== Removing Top Card ===")
            print("Card being removed: \(topCard.entryName)")
            print("Is Approved: \(isApproved)")
            print("Arrays before removal:")
            print("Main Cards: \(cards.map { $0.entryName })")
            print("Approved Cards: \(approvedCards.map { $0.entryName })")
            print("Rejected Cards: \(rejectedCards.map { $0.entryName })")
            
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
            
            print("\nArrays after removal:")
            print("Main Cards: \(cards.map { $0.entryName })")
            print("Approved Cards: \(approvedCards.map { $0.entryName })")
            print("Rejected Cards: \(rejectedCards.map { $0.entryName })")
            print("Last Action: \(String(describing: lastAction))")
        }

    func skipTopCard() {
            guard let topCard = cards.first else { return }
            let cardWidth = UIScreen.main.bounds.width - 32
            
            print("\n=== Skipping Top Card ===")
            print("Card being skipped: \(topCard.entryName)")
            print("Arrays before skip:")
            print("Main Cards: \(cards.map { $0.entryName })")
            print("Skipped Cards: \(skippedCards.map { $0.entryName })")
            
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
                state.zIndex = -1
                state.offset = .zero
                state.isSkipping = false
                state.scale = CGSize(
                    width: CardAnimationConfig.baseScale,
                    height: CardAnimationConfig.baseScale
                )
                self.cardState[topCard.id] = state

                self.cards.append(topCard)
                self.skippedCards.append(topCard)
                self.lastAction = .skipped
                self.showUndoButton = true
                
                self.checkAndUpdateSuccessState()  // Check after skip animation
                
                print("\nArrays after skip:")
                print("Main Cards: \(self.cards.map { $0.entryName })")
                print("Skipped Cards: \(self.skippedCards.map { $0.entryName })")
                print("Last Action: \(String(describing: self.lastAction))")
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
        print("\n=== Starting Undo Action ===")
        print("Current Arrays State:")
        print("Main Cards: \(cards.map { $0.entryName })")
        print("Approved Cards: \(approvedCards.map { $0.entryName })")
        print("Rejected Cards: \(rejectedCards.map { $0.entryName })")
        print("Skipped Cards: \(skippedCards.map { $0.entryName })")
        print("Last Action: \(String(describing: lastAction))")
        
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
                print("\nUndoing Skipped Card: \(lastSkipped.entryName)")
                handleUndo(card: lastSkipped, from: "skipped", array: &skippedCards)
            }
        case .approved:
            if let lastApproved = approvedCards.last {
                print("\nUndoing Approved Card: \(lastApproved.entryName)")
                handleUndo(card: lastApproved, from: "approved", array: &approvedCards)
            }
        case .rejected:
            if let lastRejected = rejectedCards.last {
                print("\nUndoing Rejected Card: \(lastRejected.entryName)")
                handleUndo(card: lastRejected, from: "rejected", array: &rejectedCards)
            }
        }
        
        lastAction = nil
    }



    private func handleUndo(card: EntryItem, from source: String, array: inout [EntryItem]) {
            print("\n--- Handle Undo Details ---")
            print("Card being undone: \(card.entryName)")
            print("Source: \(source)")
            print("Current array count before removal: \(array.count)")
            
            // Position the card before animation
            positionCardForUndo(card: card, from: source)
            
            // Remove from source array
            array.removeLast()
            
            // Remove any existing instances of the card from the main array
            cards.removeAll(where: { $0.id == card.id })
            
            print("Array count after removal: \(array.count)")
            
            DispatchQueue.main.async {
                print("\nInserting card into main stack: \(card.entryName)")
                print("Main stack before insertion: \(self.cards.map { $0.entryName })")
                self.cards.insert(card, at: 0)
                print("Main stack after insertion: \(self.cards.map { $0.entryName })")
                
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
                    
                    print("\n=== Undo Complete ===")
                    print("Final Arrays State:")
                    print("Main Cards: \(self.cards.map { $0.entryName })")
                    print("Approved Cards: \(self.approvedCards.map { $0.entryName })")
                    print("Rejected Cards: \(self.rejectedCards.map { $0.entryName })")
                    print("Skipped Cards: \(self.skippedCards.map { $0.entryName })")
                    print("Should Show Success: \(self.shouldShowSuccess)")
                }
            }
        
        if source != "skipped" {
            expensesLeft += 1
        }
        
        showUndoButton = false
        lastAction = nil
    }
    
    func checkAndUpdateSuccessState() {
        print("\n=== Checking Success State ===")
        print("Current cards count: \(cards.count)")
        print("Current success state: \(shouldShowSuccess)")
        
        // Update success state whenever cards array becomes empty
        if cards.isEmpty {
            shouldShowSuccess = true
        } else {
            shouldShowSuccess = false
        }
        
        print("New success state: \(shouldShowSuccess)")
    }

    
    private func loadSampleCards() {
        let cardViewModel = CardViewModel()
        cards = cardViewModel.generateSampleCards()
        expensesLeft = cards.count
    }
}
