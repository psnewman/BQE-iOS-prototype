import FASwiftUI
import SwiftUI

struct CardView: View {
  // MARK: - Properties
  private let card: EntryItem
  private let isTopCard: Bool
  private let isNextCard: Bool
  private let onRemove: (Bool) -> Void

  @ObservedObject var stackViewModel: CardStackViewModel
  @State private var offset: CGSize = CGSize.zero
  @State private var isDragging: Bool = false
  @State private var dragThreshold: CGFloat = 0
  @State private var isMemoSheetPresented = false

  // MARK: - Initialization
  init(
    card: EntryItem,
    isTopCard: Bool,
    isNextCard: Bool,
    stackViewModel: CardStackViewModel,
    onRemove: @escaping (Bool) -> Void
  ) {
    self.card = card
    self.isTopCard = isTopCard
    self.isNextCard = isNextCard
    self.stackViewModel = stackViewModel
    self.onRemove = onRemove
  }

  // MARK: - Body
  var body: some View {
    GeometryReader { geometry in
      cardContent
        .modifier(CardStyle(offset: currentOffset, dragThreshold: dragThreshold))
        .scaleEffect(currentScale)
        .animation(.spring(response: 0.3), value: stackViewModel.topCardOffset)
        .offset(y: verticalOffset)
        .offset(x: currentOffset.width, y: currentOffset.height)
        .rotationEffect(
          .degrees(
            stackViewModel.getCardState(card.id).isUndoing
              ? stackViewModel.getCardState(card.id).rotation
              : stackViewModel.getCardState(card.id).action == .skipped
                ? 0 : Double(currentOffset.width / CardAnimationConfig.rotationFactor)
          )
        )
        .opacity(isTopCard || isNextCard ? 1 : 0)
        .gesture(isTopCard ? dragGesture : nil)
        .onChange(of: isTopCard) { oldValue, newValue in
          if !newValue {
            offset = .zero
          }
        }
        .zIndex(stackViewModel.getCardState(card.id).zIndex)
        .onAppear {
          dragThreshold = geometry.size.width * CardAnimationConfig.dragThresholdMultiplier
        }
        .frame(width: geometry.size.width)
        // In CardView.swift, modify the body property:

        .sheet(isPresented: $isMemoSheetPresented) {
            MemoBottomSheet(
                isMemoSheetPresented: $isMemoSheetPresented,
                memo: Binding(
                    get: { self.card.memo },
                    set: { newValue in
                        self.card.memo = newValue
                        stackViewModel.updateMemo(for: card.id, memo: newValue)
                    }
                )
            )
            .presentationDetents([.height(180)])  // Adjust this value as needed
            .presentationDragIndicator(.visible)
        }
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
      // .fixedSize(horizontal: false, vertical: true)

      CardOverlayView(
        offset: currentOffset,
        dragThreshold: dragThreshold,
        isTopCard: isTopCard,
        cardState: stackViewModel.getCardState(card.id),
        card: card,
        stackViewModel: stackViewModel
      )

    }
    // .frame(maxWidth: .infinity)
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
        billedAmount: card.billedAmount,
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
        EntryTextRowView(
          label: detail.label,
          value: detail.value(for: card),
          layout: .horizontal,
          isDescription: detail == .description
        )
      }
      // In CardView.swift, in the detailsView
      EntryMemoRowView(
        card: card,
        stackViewModel: stackViewModel,
        isMemoSheetPresented: $isMemoSheetPresented
      )

    }
  }

  fileprivate var footerView: some View {
    VStack(spacing: 8) {
      Divider()
        .background(.divider)
      HStack(spacing: 16) {
        ForEach(EntrySummary.allCases) { summary in
          EntryTextRowView(
            label: summary.label,
            value: summary.value(for: card),
            layout: .vertical,
            isDescription: false
          )
          if summary != .billRate {
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
    let state = stackViewModel.getCardState(card.id)
    if state.isUndoing {
      return state.offset
    }
    return isDragging ? offset : state.offset
  }

  private var currentScale: CGSize {
    if isTopCard {
      return CGSize(width: CardAnimationConfig.maxScale, height: CardAnimationConfig.maxScale)
    }

    if isNextCard {
      // Force immediate scale update during drag
      let topCardOffset = abs(stackViewModel.topCardOffset.width)
      let progress = min(topCardOffset / dragThreshold, 1.0)
      let scale =
        CardAnimationConfig.baseScale
        + (CardAnimationConfig.maxScale - CardAnimationConfig.baseScale) * progress

      return CGSize(width: scale, height: scale)
    }

    return CGSize(width: CardAnimationConfig.baseScale, height: CardAnimationConfig.baseScale)
  }

  private var scaleEffect: CGFloat {
    if isTopCard {
      return CardAnimationConfig.maxScale
    }

    if isNextCard {
      // Use the top card's offset from the view model
      let topCardOffset = abs(stackViewModel.topCardOffset.width)
      let progress = min(topCardOffset / dragThreshold, 1.0)
      let scale =
        CardAnimationConfig.baseScale
        + (CardAnimationConfig.maxScale - CardAnimationConfig.baseScale) * progress

      return scale
    }

    return CardAnimationConfig.baseScale
  }

  // In CardView.swift
  fileprivate var verticalOffset: CGFloat {
    guard isNextCard else { return 0 }
    let topCardOffset = abs(stackViewModel.topCardOffset.width)
    let progress = min(topCardOffset / dragThreshold, 1.0)
    // Start from CardAnimationConfig.verticalOffset (12) and decrease to 0 as progress increases
    return CardAnimationConfig.verticalOffset * (1 - progress)
  }

}

// MARK: - Gesture Handling
extension CardView {
  fileprivate var dragGesture: some Gesture {
    DragGesture()
      .onChanged(handleDragChange)
      .onEnded { _ in handleDragEnd() }
  }

  // In CardView.swift
  fileprivate func handleDragChange(_ value: DragGesture.Value) {
    isDragging = true
    let resistedDrag = value.translation.width * CardAnimationConfig.dragResistance
    offset = CGSize(width: resistedDrag, height: 0)

    // Update view model state while dragging
    var state = stackViewModel.getCardState(card.id)
    state.offset = offset
    stackViewModel.cardState[card.id] = state

    // Update top card offset and force view update
    withAnimation(.linear(duration: 0)) {  // Add animation here
      stackViewModel.topCardOffset = offset
      stackViewModel.objectWillChange.send()  // Force update
    }
  }

  // In CardView.swift
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
        var state = stackViewModel.getCardState(card.id)
        state.offset = offset
        stackViewModel.cardState[card.id] = state

        // Update top card offset
        stackViewModel.topCardOffset = offset

        // Call onRemove which updates the card stack
        onRemove(isApproved)

        // Reset topCardOffset to ensure next card starts from baseScale and verticalOffset starts from 12
        DispatchQueue.main.async {
          withAnimation(.none) {
            stackViewModel.topCardOffset = .zero
          }
        }

      } else {
        offset = .zero

        // Reset view model state and top card offset
        var state = stackViewModel.getCardState(card.id)
        state.offset = .zero
        stackViewModel.cardState[card.id] = state

        stackViewModel.topCardOffset = .zero
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
    case hours
    case costRate
    case billRate

    var id: Self { self }

    var label: String {
      switch self {
      case .hours: return "Hours"
      case .costRate: return "Cost Rate"
      case .billRate: return "Bill Rate"
      }
    }

    func value(for card: EntryItem) -> String {
      switch self {
      case .hours: return card.units
      case .costRate: return card.costRate
      case .billRate: return card.billRate
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
      memo: "",
      date: "8/11/2023",
      resource: "Emma Thompson",
      project: "01-01 - SKYTOWER: Project Management",
      client: "SKYTOWER Corp",
      units: "1.00",
      costRate: "$30.00",
      costAmount: "$45.00",
      billRate: "$57.00",
      billable: .billable
    ),
    isTopCard: true,
    isNextCard: false,
    stackViewModel: CardStackViewModel(),
    onRemove: { _ in }
  )
}
