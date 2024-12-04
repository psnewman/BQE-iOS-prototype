import SwiftUI

struct CardOverlayView: View {
  let offset: CGSize
  let dragThreshold: CGFloat
  let isTopCard: Bool
  let isSkipped: Bool

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
      if isSkipped {
        Color.blue
      } else if offset.width > 0 {
        Color.green
      } else if offset.width < 0 {
        Color.red
      } else {
        Color.clear
      }
    }
  }

  private var overlayIcons: some View {
    ZStack(alignment: .bottom) {
      if isSkipped {
        skipIcon
      } else if offset.width > 0 {
        approveIcon
      } else if offset.width < 0 {
        rejectIcon
      }
    }
  }

  private var approveIcon: some View {
    HStack {
      Image(systemName: "checkmark.circle.fill")
        .foregroundColor(.white)
        .font(.system(size: 50))
        .opacity(calculateIconOpacity(isApprove: true))
        .padding(16)
    }
  }

  private var rejectIcon: some View {
    HStack {
      Image(systemName: "xmark.circle.fill")
        .foregroundColor(.white)
        .font(.system(size: 50))
        .opacity(calculateIconOpacity(isApprove: false))
        .padding(16)
    }
  }

  private var skipIcon: some View {
    HStack {
      Image(systemName: "forward.circle.fill")
        .foregroundColor(.white)
        .font(.system(size: 50))
        .opacity(isTopCard ? 1.0 : 0)
        .padding(16)
    }
  }

  private func calculateOverlayOpacity() -> Double {
    guard isTopCard else { return 0 }
    let normalizedOffset = abs(offset.width) / dragThreshold
    return min(normalizedOffset, 0.8)
  }

  private func calculateIconOpacity(isApprove: Bool) -> Double {
    guard isTopCard else { return 0 }
    let normalizedOffset = offset.width / dragThreshold
    let iconOpacity = isApprove ? max(normalizedOffset, 0) : max(-normalizedOffset, 0)
    return min(abs(iconOpacity), 1.0)
  }
}
