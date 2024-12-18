import SwiftUI
import FASwiftUI
import RiveRuntime


class HomeSectionsState: ObservableObject {
  private let defaults = UserDefaults.standard
  private let storageKey = "HomeExpandedSections"

  private let defaultSections = [
    "favorites",
    "recent-items",
    "my-timers",
    "workflows",
    "weekly-timecard",
    "upcoming-events",
  ]

  @Published var expandedSections: Set<String> {
    didSet {
      defaults.set(Array(expandedSections), forKey: storageKey)
    }
  }

  init() {
    if let savedSections = defaults.array(forKey: storageKey) as? [String] {
      self.expandedSections = Set(savedSections)
    } else {
      self.expandedSections = Set(defaultSections)
    }
  }
}

struct HomeView: View {
  @Binding var selectedOption: String
  @Binding var isShowingSheet: Bool
  @StateObject private var sectionsState = HomeSectionsState()

  private struct Section: Identifiable {
    let id: String
    let label: String
    let content: AnyView

    init<V: View>(_ label: String, id: String, @ViewBuilder content: () -> V) {
      self.label = label
      self.id = id
      self.content = AnyView(content())
    }
  }

  private var sections: [Section] {
    [
      Section("Favorites", id: "favorites") { FavoritesSectionView() },
      Section("Recent Items", id: "recent-items") { RecentItemsSectionView() },
      Section("My timers", id: "my-timers") { MyTimersSectionView() },
      Section("Workflows", id: "workflows") { CardStackView() },
      Section("Weekly Timecard", id: "weekly-timecard") { TimeCardSectionView() },
      Section("Upcoming Events", id: "upcoming-events") { EventsSectionView() },
    ]
  }

  var body: some View {
    ScrollView {
      VStack(spacing: 8) {
        ForEach(sections) { section in
          HomeSectionView(section.label, isExpanded: expandedBinding(for: section.id), showViewAll: section.id == "recent-items" || section.id == "workflows" ? false : true) {
            section.content
          }
        }
      }
      .padding(.vertical)
    }
    .background(.masterBackground)
  }

  private func expandedBinding(for id: String) -> Binding<Bool> {
    Binding(
      get: { sectionsState.expandedSections.contains(id) },
      set: { isExpanded in
        if isExpanded {
          sectionsState.expandedSections.insert(id)
        } else {
          sectionsState.expandedSections.remove(id)
        }
      }
    )
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
