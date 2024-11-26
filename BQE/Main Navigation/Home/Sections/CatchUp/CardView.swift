import FASwiftUI
import SwiftUI

struct CardView: View {
  // MARK: - Properties
  private let card: ExpenseCard
  private let isTopCard: Bool
  private let isNextCard: Bool
  private let onRemove: (Bool) -> Void

  @State private var offset: CGSize = CGSize.zero
  @State private var isDragging: Bool = false
  @State private var dragThreshold: CGFloat = 0

  // MARK: - Initialization
  init(
    card: ExpenseCard,
    isTopCard: Bool,
    isNextCard: Bool,
    onRemove: @escaping (Bool) -> Void
  ) {
    self.card = card
    self.isTopCard = isTopCard
    self.isNextCard = isNextCard
    self.onRemove = onRemove
  }

  // MARK: - Body
  var body: some View {
    GeometryReader { geometry in
      cardContent
        .modifier(CardStyle(offset: offset, dragThreshold: dragThreshold))
        .scaleEffect(scaleEffect)
        .offset(y: verticalOffset)
        .offset(x: offset.width, y: offset.height)
        .rotationEffect(.degrees(Double(offset.width / CardAnimationConfig.rotationFactor)))
        .opacity(isTopCard || isNextCard ? 1 : 0)
        .gesture(isTopCard ? dragGesture : nil)
        .onAppear {
          dragThreshold = geometry.size.width * CardAnimationConfig.dragThresholdMultiplier
        }
    }
  }
}

// MARK: - Content Views
extension CardView {
  fileprivate var cardContent: some View {
    ZStack {
      mainContent
        .padding(16)

      CardOverlayView(
        offset: offset,
        dragThreshold: dragThreshold,
        isTopCard: isTopCard
      )
    }
  }

  fileprivate var mainContent: some View {
    VStack(alignment: .leading, spacing: 16) {
      headerView
      detailsView
      footerView
    }
    // .padding(16)
  }

  fileprivate var headerView: some View {
    VStack(spacing: 8) {
      ExpenseHeaderView(
        expenseType: card.expenseType,
        expenseName: card.expenseName,
        costAmount: card.costAmount
      )
      Divider()
        .background(.divider)
    }
  }

  fileprivate var detailsView: some View {
    VStack(alignment: .leading, spacing: 16) {
      ForEach(ExpenseDetail.allCases) { detail in
        ExpenseRowView(
          label: detail.label,
          value: detail.value(for: card),
          layout: .horizontal
        )
      }
    }
  }

  fileprivate var footerView: some View {
    Group {
      Spacer()
      Divider()
        .background(.divider)
      HStack(spacing: 16) {
        ForEach(ExpenseSummary.allCases) { summary in
          ExpenseRowView(
            label: summary.label,
            value: summary.value(for: card),
            layout: .vertical
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
}

// MARK: - Supporting Types
extension CardView {
  fileprivate enum ExpenseDetail: CaseIterable, Identifiable {
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

    func value(for card: ExpenseCard) -> String {
      switch self {
      case .date: return card.date
      case .resource: return card.resource
      case .project: return card.project
      case .client: return card.client
      case .description: return card.expenseName
      }
    }
  }

  fileprivate enum ExpenseSummary: CaseIterable, Identifiable {
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

    func value(for card: ExpenseCard) -> String {
      switch self {
      case .units: return card.units
      case .costRate: return card.costRate
      case .costAmount: return card.costAmount
      }
    }
  }
}
