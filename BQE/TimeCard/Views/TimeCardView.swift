//  TimeCardView.swift
//  Works on iOS 16+

import FASwiftUI
import SwiftUI

// ────────────────────────────────────────────────
// MARK: 0.  Helpers
// ────────────────────────────────────────────────

// 0-a  A PreferenceKey that broadcasts a view’s vertical position
private struct ScrollYKey: PreferenceKey {
  static var defaultValue: CGFloat = .zero
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}

// 0-b  Attach to any child inside your ScrollView to monitor its y-offset
extension View {
  fileprivate func trackY(
    in space: CoordinateSpace,
    onChange: @escaping (CGFloat) -> Void
  ) -> some View {
    background(
      GeometryReader { geo in
        Color.clear
          .preference(
            key: ScrollYKey.self,
            value: geo.frame(in: space).minY)
      }
    )
    .onPreferenceChange(ScrollYKey.self, perform: onChange)
  }
}

// 0-c  Current key window → for safe-area inset without deprecation
extension UIApplication {
  var keyWindow: UIWindow? {
    connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap(\.windows)
      .first(where: \.isKeyWindow)
  }
}

// ────────────────────────────────────────────────
// MARK: 1.  TimeCardView
// ────────────────────────────────────────────────

struct TimeCardView: View {

  // footer control
  @State private var barHidden = false
  @State private var lastOffset = CGFloat.zero

  // local state
  @State private var selectedWeek: Date = .now
  @State private var selectedResource: String = "Steve Burns"

  private let barHeight: CGFloat = 56  // real height of TimeCardTotalBarView
  private let extra: CGFloat = 8  // push a bit further to hide under TabBar

  var body: some View {
    NavigationStack {
      VStack(spacing: 0) {

        // fixed header
        VStack(spacing: 0) {
          WeekPickerView(selectedWeek: $selectedWeek)
//          WeekdaysHeaderView(selectedWeek: $selectedWeek)
            HStack {
                TimeCardSectionView()
            }
            .padding(8)
            .overlay(
              RoundedRectangle(cornerRadius: 0)
                .stroke(.divider, lineWidth: 1)
            )
        }

        // ─────────────── ScrollView
        ScrollView {
          // Invisible probe that reports scroll offset
          Color.clear
            .frame(height: 0)
            .trackY(in: .named("SCROLL")) { y in
              // Simple fix: only change bar state when y is negative
              // (which means we're not at the top overscroll)
              if y < 0 {
                let delta = y - lastOffset

                // Use a single threshold check with larger value for stability
                if abs(delta) > 10 {
                  // True when scrolling up (negative delta), False when scrolling down (positive delta)
                  let shouldHide = delta < 0

                  // Only update if state is actually changing
                  if barHidden != shouldHide {
                    barHidden = shouldHide
                  }
                }
              }

              lastOffset = y
            }

          resourcePicker
            .padding(16)

          VStack(spacing: 16) {
            ForEach(0..<7) { i in
              TimeCardRowView(entry: .sample(projectIndex: i))
            }
          }
          .padding(.bottom, 40)
        }
        .coordinateSpace(name: "SCROLL")  // <-- important
      }
      .navigationTitle("Time Card")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar { navToolbar }
      .background(Color.masterBackground)
      // ─────────────── Footer outside scroll hierarchy
      .overlay(alignment: .bottom) {
        let bottomInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        let tabBarHeight: CGFloat = 49  // Standard TabBar height
        let additionalGap: CGFloat = 8  // Additional gap when visible

        TimeCardTotalBarView()
          .frame(height: barHeight)
          .offset(
            y: barHidden
              ? barHeight + tabBarHeight + bottomInset  // Move below TabBar + safe area
              : bottomInset > 0 ? -additionalGap : -16 - additionalGap
          )  // Increased gap
          .animation(.easeInOut(duration: 0.25), value: barHidden)
          .ignoresSafeArea(.keyboard)
      }

    }
  }

  // MARK: small helpers ------------------------------------------------
  private var resourcePicker: some View {
    Menu {
      Button("Steve Burns") { selectedResource = "Steve Burns" }
      Button("John Doe") { selectedResource = "John Doe" }
      Button("Jane Smith") { selectedResource = "Jane Smith" }
    } label: {
      HStack(spacing: 8) {
        Text("Resource:")
          .foregroundColor(.typographySecondary)
        Text(selectedResource)
          .foregroundColor(.typographyPrimary)
        Spacer()
        FAText(iconName: "chevron-down", size: 14, style: .solid)
          .foregroundColor(.typographyPrimary)
      }
      .bodyStyle()
      .frame(height: 40)
      .padding(.horizontal, 12)
      .overlay(
        RoundedRectangle(cornerRadius: 8)
          .stroke(Color.border, lineWidth: 1)
      )
    }
  }

  @ToolbarContentBuilder
  private var navToolbar: some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      HStack(spacing: 16) {
Button {
  /* filter action */
} label: {
  FAText(iconName: "filter", size: 16, style: .regular)
    .foregroundColor(.white)
}

Button {
  /* add action */
} label: {
  FAText(iconName: "plus", size: 16, style: .solid)
    .foregroundColor(.white)
}

Button {
  /* more action */
} label: {
  FAText(iconName: "ellipsis", size: 16, style: .solid)
    .foregroundColor(.white)
}
      }
      .foregroundColor(.white)
    }
  }

}

// ────────────────────────────────────────────────
// MARK: 2.  Preview
// ────────────────────────────────────────────────

#Preview { TimeCardView() }
