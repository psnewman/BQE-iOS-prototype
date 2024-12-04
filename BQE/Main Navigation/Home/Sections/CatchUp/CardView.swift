import FASwiftUI
import SwiftUI

struct CardView: View {
  // MARK: - Properties
  private let card: EntryItem
  private let isTopCard: Bool
  private let isNextCard: Bool
  private let onRemove: (Bool) -> Void
  @Binding var skipAnimation: Bool

  @State private var offset: CGSize = CGSize.zero
  @State private var isDragging: Bool = false
  @State private var dragThreshold: CGFloat = 0
  @State private var isSkipping: Bool = false

  // MARK: - Initialization
  init(
    card: EntryItem,
    isTopCard: Bool,
    isNextCard: Bool,
    skipAnimation: Binding<Bool> = .constant(false),
    onRemove: @escaping (Bool) -> Void
  ) {
    self.card = card
    self.isTopCard = isTopCard
    self.isNextCard = isNextCard
    self._skipAnimation = skipAnimation
    self.onRemove = onRemove
  }

  // MARK: - Body
  var body: some View {
    GeometryReader { geometry in
      cardContent
        .modifier(CardStyle(offset: offset, dragThreshold: dragThreshold))
        .scaleEffect(scaleEffect)
        .animation(.spring(response: 0.3), value: scaleEffect)
        .offset(y: verticalOffset)
        .offset(x: offset.width, y: offset.height)
        .rotationEffect(.degrees(Double(offset.width / CardAnimationConfig.rotationFactor)))
        .opacity(isTopCard || isNextCard ? 1 : 0)
        .gesture(isTopCard && !isSkipping ? dragGesture : nil)
        .onChange(of: isTopCard) { oldValue, newValue in
          if !newValue {
            isSkipping = false
            offset = .zero
          }
        }
        .onChange(of: skipAnimation) { _, newValue in
          if newValue && isTopCard {
            skip()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
              skipAnimation = false
              onRemove(false)
            }
          }
        }
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
        .padding(16)
        .fixedSize(horizontal: false, vertical: true)

      CardOverlayView(
        offset: offset,
        dragThreshold: dragThreshold,
        isTopCard: isTopCard,
        isSkipped: isSkipping
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
      Divider()
        .background(.divider)
    }
  }

  fileprivate var detailsView: some View {
    VStack(alignment: .leading, spacing: 16) {
      ForEach(EntryDetail.allCases) { detail in
        EntryRowView(
          label: detail.label,
          value: detail.value(for: card),
          layout: .horizontal,
          isDescription: detail == .description
        )
      }
    }
  }

  fileprivate var footerView: some View {
    Group {
      // Spacer()
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
      .frame(maxWidth: .infinity)
    }
  }
}

// MARK: - Animations
extension CardView {
  fileprivate var scaleEffect: CGFloat {
    guard isTopCard || isNextCard else { return CardAnimationConfig.baseScale }
    if isTopCard { return CardAnimationConfig.maxScale }
    return CardAnimationConfig.baseScale
      + ((CardAnimationConfig.maxScale - CardAnimationConfig.baseScale) * abs(offset.width)
        / dragThreshold)
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
        onRemove(isApproved)
      } else {
        offset = .zero
      }
      isDragging = false
    }
  }

  func skip() {
    isSkipping = true
    withAnimation(
      .easeInOut(duration: 0.6)
    ) {
      offset = CGSize(
        width: -CardAnimationConfig.swipeOutDistance / 2,
        height: -100
      )
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
    case memo

    var id: Self { self }

    var label: String {
      switch self {
      case .date: return "Date"
      case .resource: return "Resource"
      case .project: return "Project"
      case .client: return "Client"
      case .description: return "Description"
      case .memo: return "Memo"
      }
    }

    func value(for card: EntryItem) -> String {
      switch self {
      case .date: return card.date
      case .resource: return card.resource
      case .project: return card.project
      case .client: return card.client
      case .description: return card.description
      case .memo: return card.memo
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
      memo: "Team discussed Q4 deliverables and milestones for the upcoming phase",
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
    skipAnimation: .constant(false),
    onRemove: { _ in }
  )
}
