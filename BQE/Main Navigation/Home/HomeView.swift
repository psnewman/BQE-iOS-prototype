import FASwiftUI
import SwiftUI

class HomeSectionsState: ObservableObject {
  @Published var expandedSections: Set<String>

  init() {
    // Initialize with all sections expanded
    self.expandedSections = Set([
      "favorites",
      "recent-items",
      "my-timers",
      "catch-up",
      "weekly-timecard",
      "upcoming-events",
    ])
  }

  func toggleSection(_ label: String) {
    if expandedSections.contains(label) {
      expandedSections.remove(label)
    } else {
      expandedSections.insert(label)
    }
  }

  func isExpanded(_ label: String) -> Bool {
    expandedSections.contains(label)
  }
}

struct HomeView: View {
  @Binding var selectedOption: String
  @Binding var isShowingSheet: Bool

  var body: some View {
    ScrollView {
      VStack(spacing: 8) {
        HomeSectionView(label: "Favorites", id: "favorites") {
          FavoritesSectionView()
        }
        
        HomeSectionView(label: "Recent Items", id: "recent-items") {
          RecentItemsSectionView()
        }
        
        HomeSectionView(label: "My timers", id: "my-timers") {
          MyTimersSectionView()
        }
        
        HomeSectionView(label: "Catch Up", id: "catch-up") {
          CardStackView()
        }
        
        HomeSectionView(label: "Weekly Timecard", id: "weekly-timecard") {
          TimeCardSectionView()
        }
        
        HomeSectionView(label: "Upcoming Events", id: "upcoming-events") {
          EventsSectionView()
        }
      }
      .padding(.vertical)
    }
    .background(.masterBackground)
  }
}

struct DropdownView: View {
  @Binding var selectedOption: String
  @Binding var isShowingSheet: Bool

  var body: some View {
    Menu {
      Button("Company 1") {
        selectedOption = "Company 1"
      }
      Button("Company 2") {
        selectedOption = "Company 2"
      }
      Divider()
      Button("Try Sample Company") {
        isShowingSheet = true
      }
      Divider()
      NavigationLink(destination: SettingsView()) {
        Text("Settings")
      }
      Divider()
      Button("Sign Out") {
        // Handle Sign Out action
      }
    } label: {
      HStack(alignment: .center, spacing: 8) {
        Image("avatar")
          .resizable()
          .frame(width: 32, height: 32)

        ZStack(alignment: .leading) {
          RoundedRectangle(cornerRadius: 8)
            .fill(Color(red: 0.88, green: 0.91, blue: 0.94))
            .frame(minWidth: 160, maxWidth: 260, minHeight: 32, maxHeight: 32)

          HStack(spacing: 4) {
            Text(selectedOption)
              .bodyStyle()
              .foregroundColor(Color(red: 0.12, green: 0.16, blue: 0.23))
              .frame(minWidth: 120, maxWidth: 220, alignment: .leading)
            Spacer()
            FAText(iconName: "chevron-down", size: 12)
              .foregroundColor(.black)
          }
          .padding(.horizontal, 12)
        }
      }
    }
  }
}

#Preview {
  HomeView(selectedOption: .constant("My Company 1"), isShowingSheet: .constant(false))
}
