import SwiftUI
import SVGView
import FASwiftUI

struct CatchUpCardView: View {
    // MARK: - Properties
    let card: ExpenseCard
    let isTopCard: Bool
    let isNextCard: Bool
    var onRemove: (Bool) -> Void

    @State private var offset = CGSize.zero
    @State private var isDragging = false
    @State private var dragThreshold: CGFloat = 0
    @State private var dragResistance: CGFloat = 0.5

    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            cardContent
                .cardStyle(offset: offset, dragThreshold: dragThreshold)
                .scaleEffect(scaleEffect)
                .offset(y: verticalOffset)
                .offset(x: offset.width, y: offset.height)
                .rotationEffect(.degrees(Double(offset.width / 20)))
                .opacity(isTopCard || isNextCard ? 1 : 0)
                .gesture(isTopCard ? dragGesture : nil)
                .onAppear {
                    dragThreshold = geometry.size.width * 0.35
                }
        }
    }
    
    // MARK: - Card Content
    private var cardContent: some View {
        ZStack {
            // Main Card Content
            mainCardContent
            
            // Overlay
            cardOverlay
        }
    }
    
    private var mainCardContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            headerSection
            detailsSection
            footerSection
        }
        .padding(16)
    }

    // MARK: - Card Sections
    private var headerSection: some View {
        VStack(spacing: 8) {
            ExpenseHeaderView(
                expenseType: card.expenseType,
                expenseName: card.expenseName,
                costAmount: card.costAmount
            )
            Divider().background(.divider)
        }
    }

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            ExpenseRowView(label: "Date", value: card.date, layout: .horizontal)
            ExpenseRowView(label: "Resource", value: card.resource, layout: .horizontal)
            ExpenseRowView(label: "Project", value: card.project, layout: .horizontal)
            ExpenseRowView(label: "Client", value: card.client, layout: .horizontal)
            ExpenseRowView(label: "Description", value: card.expenseName, layout: .horizontal)
        }
    }

    private var footerSection: some View {
        Group {
            Spacer()
            Divider().background(.divider)
            HStack(spacing: 16) {
                ExpenseRowView(label: "Units", value: card.units, layout: .vertical)
                Spacer()
                ExpenseRowView(label: "Cost Rate", value: card.costRate, layout: .vertical)
                Spacer()
                ExpenseRowView(label: "Cost Amount", value: card.costAmount, layout: .vertical)
            }
            .background(.masterBackground)
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - Card Overlay
    private var cardOverlay: some View {
        ZStack {
            // Background Overlay
            overlayBackground
            
            // Icons
            overlayIcons
        }
        .cornerRadius(8)
        .opacity(calculateOverlayOpacity())
        .allowsHitTesting(false)
    }
    
    // Dynamic background color based on drag direction
    private var overlayBackground: some View {
        Group {
            if offset.width > 0 {
                Color.green
            } else if offset.width < 0 {
                Color.red
            } else {
                Color.clear
            }
        }
    }
    
    // Icons with dynamic opacity
    private var overlayIcons: some View {
        ZStack(alignment: .bottom) {
            // Approve Icon (Swipe Right)
            if offset.width > 0 {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 50))
                        .opacity(calculateIconOpacity(isApprove: true))
                        .padding(16)
                }
            }
            
            // Reject Icon (Swipe Left)
            if offset.width < 0 {
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 50))
                        .opacity(calculateIconOpacity(isApprove: false))
                        .padding(16)
                }
            }
        }
    }

    // MARK: - Visual Effects
    private var scaleEffect: CGFloat {
        guard isTopCard || isNextCard else { return 0.97 }
        
        if isTopCard { return 1.0 }
        return 0.97 + (0.03 * abs(offset.width) / dragThreshold)
    }

    private var verticalOffset: CGFloat {
        isNextCard ? 12 - (12 * abs(offset.width) / dragThreshold) : 0
    }

    // MARK: - Opacity Calculations
    private func calculateOverlayOpacity() -> Double {
        guard isTopCard else { return 0 }
        
        let normalizedOffset = abs(offset.width) / dragThreshold
        return min(normalizedOffset, 0.8)
    }
    
    private func calculateIconOpacity(isApprove: Bool) -> Double {
        guard isTopCard else { return 0 }
        
        let normalizedOffset = offset.width / dragThreshold
        let iconOpacity = isApprove
            ? max(normalizedOffset, 0)
            : max(-normalizedOffset, 0)
        
        return min(abs(iconOpacity), 1.0)
    }

    // MARK: - Drag Gesture
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                isDragging = true
                let resistedDrag = gesture.translation.width * dragResistance
                offset = CGSize(width: resistedDrag, height: 0)
            }
            .onEnded { _ in
                handleDragEnd()
            }
    }

    private func handleDragEnd() {
        withAnimation(.spring()) {
            if abs(offset.width) > dragThreshold {
                let isApproved = offset.width > 0
                offset = CGSize(width: isApproved ? 1000 : -1000, height: 0)
                onRemove(isApproved)
            } else {
                offset = .zero
            }
            isDragging = false
        }
    }
}

// MARK: - View Extensions
extension View {
    func cardStyle(offset: CGSize, dragThreshold: CGFloat) -> some View {
        self
            .background(.masterBackground)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.border, lineWidth: 1)
                    .opacity(1 - calculateStrokeOpacity(offset: offset, dragThreshold: dragThreshold))
            )
    }
    
    private func calculateStrokeOpacity(offset: CGSize, dragThreshold: CGFloat) -> Double {
        guard abs(offset.width) > 0 else { return 0 }
        
        let normalizedOffset = abs(offset.width) / dragThreshold
        return min(normalizedOffset, 1.0)
    }
}

// MARK: - Child Views
struct ExpenseHeaderView: View {
    let expenseType: EntryType
    let expenseName: String
    let costAmount: String

    var body: some View {
        HStack {
            FAText(iconName: expenseType.icon, size: 16)
                .foregroundColor(.typographyPrimary)
                .frame(width: 20, height: 20)

            Text(expenseName)
                .headlineStyle()
                .foregroundColor(.typographyPrimary)

            Spacer()

            Text(costAmount)
                .bodyStyle()
                .foregroundColor(.tagRedText)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.tagRedBackground)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.tagRedBorder)
                )
        }
    }
}

enum ExpenseRowLayout {
    case horizontal
    case vertical
}

struct ExpenseRowView: View {
    var label: String
    var value: String
    var layout: ExpenseRowLayout = .horizontal

    var body: some View {
        Group {
            switch layout {
            case .horizontal:
                HStack(alignment: .top, spacing: 8) {
                    Text(label)
                        .frame(width: 96, alignment: .leading)
                        .bodyStyle()
                        .foregroundColor(.typographySecondary)

                    Text(value)
                        .bodyStyle()
                        .foregroundColor(.typographyPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            case .vertical:
                VStack(alignment: .leading, spacing: 4) {
                    Text(label)
                        .bodyStyle()
                        .foregroundColor(.typographySecondary)

                    Text(value)
                        .bodyStyle()
                        .foregroundColor(.typographyPrimary)
                }
            }
        }
    }
}
