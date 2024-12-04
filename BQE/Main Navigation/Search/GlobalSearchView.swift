import FASwiftUI
import SwiftUI

struct GlobalSearchView: View {
  @State private var searchText: String = ""
  @FocusState private var isFocused: Bool
  @State private var placeholder: String = "Search"
  @Environment(\.dismiss) private var dismiss

  private let recentSearches = ["Fount", "John", "Pasadena", "Spotlight", "PTO"]

  var body: some View {
    VStack(spacing: 0) {
      searchContainer
      if searchText.isEmpty {
        recentSearchesView
      }
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
      Color.masterBackground
        .onTapGesture {
          isFocused = false
        }
    )
    .onChange(of: isFocused) { oldValue, newValue in
      placeholder = newValue ? "" : "Search"
    }
  }

  private var searchContainer: some View {
    VStack(spacing: 4) {
      HStack(spacing: 8) {
        FAText(iconName: "magnifying-glass", size: 14)
          .foregroundColor(Color.typographySecondary)
        TextField(placeholder, text: $searchText)
          .foregroundColor(Color.typographyPrimary)
          .tint(Color.masterPrimary)
          .font(.system(size: 14))
          .focused($isFocused)
          .submitLabel(.search)
          .onSubmit {
            // Handle search submission here
            isFocused = false
          }
        if !searchText.isEmpty {
          Button(action: {
            searchText = ""
            isFocused = false
          }) {
            FAText(iconName: "circle-xmark", size: 14)
              .foregroundColor(Color.typographySecondary)
          }
        }
      }
      .padding(.horizontal, 12)
      .frame(height: 40)
      .background(Color.masterBackground)
      .cornerRadius(8)
      .overlay(
        RoundedRectangle(cornerRadius: 8)
          .stroke(isFocused ? Color.masterPrimary : Color.border, lineWidth: 1)
      )
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 16)
  }

  private var recentSearchesView: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Recent searches")
        .font(.system(size: 12, weight: .semibold))
        .foregroundColor(Color.typographySecondary)
        .padding(.horizontal, 16)

      VStack(spacing: 0) {
        ForEach(recentSearches, id: \.self) { search in
          HStack(spacing: 8) {
            FAText(iconName: "magnifying-glass", size: 14)
              .foregroundColor(Color.typographySecondary)
            Text(search)
              .font(.system(size: 14))
              .foregroundColor(Color.typographyPrimary)
            Spacer()
          }
          .frame(height: 40)
          .padding(.horizontal, 16)
          .background(Color.masterBackground)
          .onTapGesture {
            searchText = search
            isFocused = true
          }
        }
      }
    }
    .padding(.top, 8)
  }
}

#Preview {
  NavigationView {
    GlobalSearchView()
  }
}
