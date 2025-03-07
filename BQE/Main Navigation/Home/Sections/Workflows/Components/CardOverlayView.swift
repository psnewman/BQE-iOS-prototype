import SwiftUI
import FASwiftUI

struct CardOverlayView: View {
    let offset: CGSize
    let dragThreshold: CGFloat
    let isTopCard: Bool
    let cardState: CardStackViewModel.CardState
    let card: EntryItem
    @ObservedObject var stackViewModel: CardStackViewModel
    
    var body: some View {
        ZStack {
            overlayBackground
            overlayIcons
        }
        .cornerRadius(8)
        .opacity(calculateOverlayOpacity())
        .allowsHitTesting(false)
    }
    
    private var overlayBackground: some View {
        Group {
            if cardState.action == .skipped || (cardState.undoSource == "skipped" && cardState.isUndoing) {
                Color.blue
            } else if cardState.action == .approved || offset.width > 0 {
                Color.green
            } else if cardState.action == .rejected || offset.width < 0 {
                Color.red
            } else {
                Color.clear
            }
        }
    }
    
    private var overlayIcons: some View {
        ZStack(alignment: .bottom) {
            if cardState.action == .skipped || (cardState.undoSource == "skipped" && cardState.isUndoing) {
                skipIcon
            } else if cardState.action == .approved || offset.width > 0 {
                approveIcon
            } else if cardState.action == .rejected || offset.width < 0 {
                rejectIcon
            }
        }
    }
    
    private var approveIcon: some View {
        HStack {
            FAText(iconName: "circle-check", size: 50, style: .regular)
                .foregroundColor(.white)
                .opacity(calculateIconOpacity(isApprove: true))
                .padding(16)
        }
    }
    
    private var rejectIcon: some View {
        HStack {
            FAText(iconName: "xmark-circle", size: 50, style: .regular)
                .foregroundColor(.white)
                .opacity(calculateIconOpacity(isApprove: false))
                .padding(16)
        }
    }
    
    private var skipIcon: some View {
        HStack {
            FAText(iconName: "forward-step", size: 50, style: .regular)
                .foregroundColor(.white)
                .opacity(isTopCard ? 1.0 : 0)
                .padding(16)
        }
    }
    
    private func calculateOverlayOpacity() -> Double {
        guard isTopCard else { return 0 }
        
        if cardState.isUndoing {
            let screenWidth = UIScreen.main.bounds.width - 32
            let progress = abs(cardState.offset.width) / screenWidth
            return progress * CardAnimationConfig.maxOverlayOpacity
        }
        
        if cardState.action == .skipped {
            return CardAnimationConfig.maxOverlayOpacity
        }
        
        if cardState.action == .approved || cardState.action == .rejected {
            return CardAnimationConfig.maxOverlayOpacity
        }
        
        let normalizedOffset = abs(offset.width) / dragThreshold
        return min(normalizedOffset, CardAnimationConfig.maxOverlayOpacity)
    }
    
    private func calculateIconOpacity(isApprove: Bool) -> Double {
        guard isTopCard else { return 0 }
        let normalizedOffset = offset.width / dragThreshold
        let iconOpacity = isApprove ? max(normalizedOffset, 0) : max(-normalizedOffset, 0)
        return min(abs(iconOpacity), 1.0)
    }
}
