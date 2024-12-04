import FASwiftUI
import SwiftUI
import UniformTypeIdentifiers

struct FavoriteItem: Identifiable, Hashable, Transferable, Codable {
  var id: UUID = UUID()
  let iconName: String
  let label: String
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: FavoriteItem, rhs: FavoriteItem) -> Bool {
    lhs.id == rhs.id
  }

  // Transferable conformance
  static var transferRepresentation: some TransferRepresentation {
    CodableRepresentation(contentType: .item)
  }
}

// Define a custom UTType for our FavoriteItem
extension UTType {
  static var item: UTType {
    UTType(exportedAs: "com.bqe.favoriteItem")
  }
}

struct FavoriteGridItemView: View {
  let item: FavoriteItem

  var body: some View {
    VStack(spacing: 16) {
      FAText(iconName: item.iconName, size: 24)
        .foregroundColor(.typographySecondary)

      Text(item.label)
        .bodyStyle()
        .foregroundColor(.typographyPrimary)
        .multilineTextAlignment(.center)
    }
    .frame(maxWidth: .infinity, minHeight: 120, maxHeight: 120, alignment: .center)
    .background(Color.masterBackground)
    .cornerRadius(12)
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .strokeBorder(Color.border, lineWidth: 1)
    )
  }
}

struct DraggableGridItemView: View {
  let item: FavoriteItem
  let onDrop: (FavoriteItem) -> Void
  @State private var itemWidth: CGFloat = 0
  
  var body: some View {
    FavoriteGridItemView(item: item)
      .background(
        GeometryReader { geometry in
          Color.clear
            .onAppear {
              itemWidth = geometry.size.width
            }
        }
      )
      .draggable(item) {
        FavoriteGridItemView(item: item)
          .frame(width: itemWidth)
          .opacity(0.7)
      }
      .dropDestination(for: FavoriteItem.self) { items, _ in
        guard let droppedItem = items.first else { return false }
        onDrop(droppedItem)
        return true
      }
  }
}

struct FavoritesTabView: View {
  let columns: [GridItem] = [
    GridItem(.flexible(), spacing: 16),
    GridItem(.flexible(), spacing: 16)
  ]

  @State private var favoriteItems: [FavoriteItem] = [
    FavoriteItem(iconName: "fa-gauge", label: "Dashboard"),
    FavoriteItem(iconName: "user-crown", label: "Clients"),
    FavoriteItem(iconName: "stopwatch", label: "Timers"),
    FavoriteItem(iconName: "calendar-clock", label: "Time Entries"),
    FavoriteItem(iconName: "fa-briefcase", label: "Projects"),
    FavoriteItem(iconName: "magnifying-glass-dollar", label: "Review T&E"),
  ]
  
  private func moveItem(_ draggedItem: FavoriteItem, to targetItem: FavoriteItem) {
    guard let sourceIndex = favoriteItems.firstIndex(where: { $0.id == draggedItem.id }),
          let destinationIndex = favoriteItems.firstIndex(where: { $0.id == targetItem.id })
    else { return }
    
    withAnimation {
      let item = favoriteItems.remove(at: sourceIndex)
      favoriteItems.insert(item, at: destinationIndex)
    }
  }

  var gridContent: some View {
    LazyVGrid(columns: columns, spacing: 16) {
      ForEach(favoriteItems) { item in
        DraggableGridItemView(item: item) { draggedItem in
          moveItem(draggedItem, to: item)
        }
      }
    }
    .padding(16)
  }

  var body: some View {
    ScrollView {
      gridContent
    }
    .background(Color.masterBackgroundSecondary)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        HStack(spacing: 16) {
          Button(action: {}) {
            FAText(iconName: "fa-plus", size: 16)
              .foregroundColor(.white)
          }
          Button(action: {}) {
            FAText(iconName: "pen-to-square", size: 16)
              .foregroundColor(.white)
          }
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    FavoritesTabView()
      .navigationTitle("Favorites")
      .navigationBarTitleDisplayMode(.inline)
  }
}
