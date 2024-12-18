import FASwiftUI
import SwiftUI

struct CardView: View {
  // MARK: - Properties
  private let card: EntryItem
  private let isTopCard: Bool
  private let isNextCard: Bool
  private let onRemove: (Bool) -> Void
  @ObservedObject var viewModel: CardStackViewModel

  @State private var offset: CGSize = CGSize.zero
  @State private var isDragging: Bool = false
  @State private var dragThreshold: CGFloat = 0
  @State private var memo: String = ""

  // MARK: - Initialization
  init(
    card: EntryItem,
    isTopCard: Bool,
    isNextCard: Bool,
    viewModel: CardStackViewModel,
    onRemove: @escaping (Bool) -> Void
  ) {
    self.card = card
    self.isTopCard = isTopCard
    self.isNextCard = isNextCard
    self.viewModel = viewModel
    self.onRemove = onRemove
  }

  // MARK: - Body
  var body: some View {
    GeometryReader { geometry in
      cardContent
        .modifier(CardStyle(offset: currentOffset, dragThreshold: dragThreshold))
        .scaleEffect(currentScale)
        .animation(.spring(response: 0.3), value: scaleEffect)
        .offset(y: verticalOffset)
        .offset(x: currentOffset.width, y: currentOffset.height)
        .rotationEffect(
          viewModel.getCardState(card.id).isSkipping
            ? .degrees(0) : .degrees(Double(currentOffset.width / CardAnimationConfig.rotationFactor))
        )
        .opacity(isTopCard || isNextCard ? 1 : 0)
        .gesture(isTopCard ? dragGesture : nil)
        .onChange(of: isTopCard) { oldValue, newValue in
          if !newValue {
            offset = .zero
          }
        }
        .zIndex(Double(viewModel.getCardState(card.id).zIndex))
        .onAppear {
          dragThreshold = geometry.size.width * CardAnimationConfig.dragThresholdMultiplier
        }
        .frame(width: geometry.size.width)
    }
  }
}

// MARK: - Content Views
extension CardView {
  fileprivate var cardContent: some View {
    ZStack {
      mainContent
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        .fixedSize(horizontal: false, vertical: true)

      CardOverlayView(
        offset: currentOffset,
        dragThreshold: dragThreshold,
        isTopCard: isTopCard,
        isSkipped: viewModel.getCardState(card.id).isSkipping
      )
    }
    .frame(maxWidth: .infinity)
  }

  fileprivate var mainContent: some View {
    VStack(alignment: .leading, spacing: 16) {
      headerView
      detailsView
      footerView
    }
  }

  fileprivate var headerView: some View {
    VStack(spacing: 8) {
      EntryHeaderView(
        entryType: card.entryType,
        entryName: card.entryName,
        costAmount: card.costAmount,
        billable: card.billable
      )
      .padding(.top, 4)
      Divider()
        .background(.divider)
    }
  }

  fileprivate var detailsView: some View {
    VStack(alignment: .leading, spacing: 12) {
      ForEach(EntryDetail.allCases) { detail in
        EntryRowView(
          label: detail.label,
          value: detail.value(for: card),
          layout: .horizontal,
          isDescription: detail == .description
        )
      }
      TextAreaView(
        label: "Memo",
        placeholder: "Add memo",
        text: $memo
      )
    }
  }

  fileprivate var footerView: some View {
      VStack(spacing: 8) {
      Divider()
        .background(.divider)
      HStack(spacing: 16) {
        ForEach(EntrySummary.allCases) { summary in
          EntryRowView(
            label: summary.label,
            value: summary.value(for: card),
            layout: .vertical,
            isDescription: false
          )
          if summary != .costAmount {
            Spacer()
          }
        }
      }
      .frame(maxWidth: .infinity, minHeight: 24)
      .padding(.bottom, 4)
    }
  }
}

// MARK: - Animations
extension CardView {
  private var currentOffset: CGSize {
    isDragging ? offset : viewModel.getCardState(card.id).offset
  }
  
  private var currentScale: CGSize {
    let scale = if isDragging {
      scaleEffect
    } else {
      if isTopCard {
        CardAnimationConfig.maxScale
      } else if isNextCard {
        CardAnimationConfig.baseScale
      } else {
        CardAnimationConfig.baseScale
      }
    }
    return CGSize(width: scale, height: scale)
  }

  private var scaleEffect: CGFloat {
    if isTopCard {
      return CardAnimationConfig.maxScale
    }
    
    if isNextCard {
      // Calculate scale for next card based on top card's movement
      let topCardOffset = isDragging ? offset.width : 0
      let progress = abs(topCardOffset) / dragThreshold
      return CardAnimationConfig.baseScale +
        ((CardAnimationConfig.maxScale - CardAnimationConfig.baseScale) * progress)
    }
    
    return CardAnimationConfig.baseScale
  }

  fileprivate var verticalOffset: CGFloat {
    guard isNextCard else { return 0 }
    return CardAnimationConfig.verticalOffset * (1 - abs(offset.width) / dragThreshold)
  }
}

// MARK: - Gesture Handling
extension CardView {
  fileprivate var dragGesture: some Gesture {
    DragGesture()
      .onChanged(handleDragChange)
      .onEnded { _ in handleDragEnd() }
  }

  fileprivate func handleDragChange(_ value: DragGesture.Value) {
    isDragging = true
    let resistedDrag = value.translation.width * CardAnimationConfig.dragResistance
    offset = CGSize(width: resistedDrag, height: 0)
    
    // Update view model state while dragging
    var state = viewModel.getCardState(card.id)
    state.offset = offset
    viewModel.cardState[card.id] = state
  }

  fileprivate func handleDragEnd() {
    withAnimation(.spring()) {
      if abs(offset.width) > dragThreshold {
        let isApproved = offset.width > 0
        offset = CGSize(
          width: isApproved
            ? CardAnimationConfig.swipeOutDistance : -CardAnimationConfig.swipeOutDistance,
          height: 0
        )
        
        // Update view model state
        var state = viewModel.getCardState(card.id)
        state.offset = offset
        viewModel.cardState[card.id] = state
        
        onRemove(isApproved)
      } else {
        offset = .zero
        
        // Reset view model state
        var state = viewModel.getCardState(card.id)
        state.offset = .zero
        viewModel.cardState[card.id] = state
      }
      isDragging = false
    }
  }
}

// MARK: - Helper Methods
extension CardView {
  public func getCardId() -> UUID {
    return card.id
  }
}

// MARK: - Supporting Types
extension CardView {
  fileprivate enum EntryDetail: CaseIterable, Identifiable {
    case date
    case resource
    case project
    case client
    case description

    var id: Self { self }

    var label: String {
      switch self {
      case .date: return "Date"
      case .resource: return "Resource"
      case .project: return "Project"
      case .client: return "Client"
      case .description: return "Description"
      }
    }

    func value(for card: EntryItem) -> String {
      switch self {
      case .date: return card.date
      case .resource: return card.resource
      case .project: return card.project
      case .client: return card.client
      case .description: return card.description
      }
    }
  }

  fileprivate enum EntrySummary: CaseIterable, Identifiable {
    case units
    case costRate
    case costAmount

    var id: Self { self }

    var label: String {
      switch self {
      case .units: return "Units"
      case .costRate: return "Cost Rate"
      case .costAmount: return "Cost Amount"
      }
    }

    func value(for card: EntryItem) -> String {
      switch self {
      case .units: return card.units
      case .costRate: return card.costRate
      case .costAmount: return card.costAmount
      }
    }
  }
}

#Preview {
  CardView(
    card: EntryItem(
      entryType: .expense,
      entryName: "Business lunch",
      description:
        "Business lunch with client team to discuss project requirements and timeline. Total of 4 attendees including project manager and lead architect.",
      date: "8/11/2023",
      resource: "Emma Thompson",
      project: "01-01 - SKYTOWER: Project Management",
      client: "SKYTOWER Corp",
      units: "1.00",
      costRate: "$45.00",
      costAmount: "$45.00",
      billable: .billable
    ),
    isTopCard: true,
    isNextCard: false,
    viewModel: CardStackViewModel(),
    onRemove: { _ in }
  )
}
