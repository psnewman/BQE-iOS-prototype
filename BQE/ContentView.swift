import SwiftUI
import FASwiftUI
import RiveRuntime


struct ContentView: View {
    @State private var selectedOption = "My Company 1"
    @State private var isShowingSheet = false
    @State private var selectedTab = 0
        
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                NavigationStack {
                    HomeView(selectedOption: $selectedOption, isShowingSheet: $isShowingSheet)
                        .bqeBackground()
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                NavbarDropdownView(selectedOption: $selectedOption, isShowingSheet: $isShowingSheet)
                            }
                        }
                        .navigationTitle("")
                }
                .tint(.white)
                .tag(0)
                .tabItem {
                    Label("Home", image: selectedTab == 0 ? "homeActive" : "home")
                }
                
                NavigationStack {
                    FavoritesTabView()
                        .bqeBackground()
                        .navigationTitle("Favorites")
                        .navigationBarTitleDisplayMode(.inline)
                }
                .tint(.white)
                .tag(1)
                .tabItem {
                    Label("Favorites", image: selectedTab == 1 ? "favoritesActive" : "favorites")
                }
                
                NavigationStack {
                    Text("Create screen")
                        .bqeBackground()
                        .navigationTitle("Create")
                        .navigationBarTitleDisplayMode(.inline)
                }
                .tint(.white)
                .tag(2)
                .tabItem {
                    Label("Create", image: selectedTab == 2 ? "createActive" : "create")
                }
                
                NavigationStack {
                    GlobalSearchView()
                        .bqeBackground()
                        .navigationTitle("Search")
                        .navigationBarTitleDisplayMode(.inline)
                        
                }
                .tint(.white)
                .tag(3)
                .tabItem {
                    Label("Search", image: selectedTab == 3 ? "searchActive" : "search")
                }
                
                NavigationStack {
                    MenuView()
                        .bqeBackground()
                        .navigationTitle("Menu")
                        .navigationBarTitleDisplayMode(.inline)
                }
                .tint(.white)
                .tag(4)
                .tabItem {
                    Label("Menu", image: selectedTab == 4 ? "menuActive" : "menu")
                }
            }
            .background(.masterBackground)
            .tint(.masterPrimary)
        }
    }
}

struct BQEBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color.masterBackground
                .ignoresSafeArea()
            VStack {
                Rectangle()
                    .frame(height: 0)
                    .background(LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.02, green: 0.08, blue: 0.23), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.35, green: 0.23, blue: 0.25), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0, y: 0),
                        endPoint: UnitPoint(x: 1, y: 1)
                    ))
                content
            }
        }
    }
}

extension View {
    func bqeBackground() -> some View {
        modifier(BQEBackgroundModifier())
    }
}

#Preview {
    ContentView()
}
