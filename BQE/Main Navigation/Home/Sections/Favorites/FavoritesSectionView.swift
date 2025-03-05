import SwiftUI

struct FavoriteItemView: View {
    @State private var icon: String
    @State private var label: String
    
    init(icon: String, label: String) {
        self.icon = icon
        self.label = label
    }

    var body: some View {
        VStack {
            Image(icon)
            
            HStack {
                Text(label)
                    .lineLimit(2)
                    .foregroundStyle(.typographyPrimary)
                    .font(.system(size: 12))
            }
            .frame(maxWidth: .infinity, maxHeight: 16)
        }
        .padding(.horizontal, 4)
        .frame(width: 96, height: 96)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .inset(by: 0.5)
                .strokeBorder(.border, lineWidth: 1)
        )
    }
}

// FavoritesView remains unchanged
struct FavoritesSectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    FavoriteItemView(icon: "icon-type-project", label: "Projects")
                    FavoriteItemView(icon: "icon-type-client", label: "Clients")
                    FavoriteItemView(icon: "icon-type-todo", label: "To-dos")
                    FavoriteItemView(icon: "icon-type-timeEntry", label: "Time Entries")
                    FavoriteItemView(icon: "icon-type-timeCard", label: "Time Card")
                }
                .scrollClipDisabled()
                .frame(maxWidth: .infinity) // Ensure HStack can expand
            }
        }
    }
}

#Preview {
    FavoritesSectionView()
}

// End of file. No additional code.
