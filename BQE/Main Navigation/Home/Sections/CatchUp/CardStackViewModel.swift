import SwiftUI

class CardStackViewModel: ObservableObject {
    @Published var cards: [EntryItem] = []
    @Published var approvedCards: [EntryItem] = []
    @Published var rejectedCards: [EntryItem] = []
    @Published var expensesLeft: Int = 10
    @Published var shouldShowSuccess: Bool = false
    
    init() {
        loadSampleCards()
    }
    
    func removeTopCard(isApproved: Bool) {
        guard let topCard = cards.first else { return }
        
        if isApproved {
            approvedCards.append(topCard)
        } else {
            rejectedCards.append(topCard)
        }
        
        cards.removeFirst()
        expensesLeft = max(0, expensesLeft - 1)
        
        if cards.isEmpty {
            shouldShowSuccess = true
        }
    }
    
    func skipTopCard() {
        guard let topCard = cards.first else { return }
        cards.removeFirst()
        cards.append(topCard)
    }
    
    func resetCards() {
        loadSampleCards()
        approvedCards.removeAll()
        rejectedCards.removeAll()
        expensesLeft = 10
        shouldShowSuccess = false
    }
    
    func undoLastAction() {
        if let lastApproved = approvedCards.last {
            approvedCards.removeLast()
            cards.insert(lastApproved, at: 0)
            expensesLeft += 1
            shouldShowSuccess = false
        } else if let lastRejected = rejectedCards.last {
            rejectedCards.removeLast()
            cards.insert(lastRejected, at: 0)
            expensesLeft += 1
            shouldShowSuccess = false
        }
    }
    
    private func loadSampleCards() {
        let cardViewModel = CardViewModel()
        cards = cardViewModel.generateSampleCards()
        expensesLeft = cards.count
    }
}
