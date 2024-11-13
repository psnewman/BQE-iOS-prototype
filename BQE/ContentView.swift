import SVGView
import FASwiftUI
import SwiftUI


struct ContentView: View {
    @State private var selectedOption = "My Company 1"
    @State private var isShowingSheet = false
    
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView {
                // Home tab with toolbar and no title
                NavigationStack {
                    HomeView(selectedOption: $selectedOption, isShowingSheet: $isShowingSheet)
                        .toolbar {
                            // Toolbar only on Home tab
                            ToolbarItem(placement: .topBarLeading) {
                                DropdownView(selectedOption: $selectedOption, isShowingSheet: $isShowingSheet)
                            }
                        }
                        .navigationTitle("") // No title for Home tab
                }
                .tabItem {
                    Label {
                        Text("Home")
                    } icon: {
                        Image("home")
                    }
                }
                
                // Other tabs with navigation titles
                NavigationStack {
                    FavoritesSectionView()
                        .navigationTitle("Favorites")
                        .navigationBarTitleDisplayMode(.inline)
                }
                .tabItem {
                    Label{
                        Text("Favorites")
                    } icon: {
                        Image("favorites")
                    }
                }
                
                NavigationStack {
                    Text("Create screen")
                        .navigationTitle("Create")
                        .navigationBarTitleDisplayMode(.inline)
                }
                .tabItem {
                    Label{
                        Text("Create")
                    } icon: {
                        Image("create")
                    }
                }
                
                NavigationStack {
                    Text("Search screen")
                        .navigationTitle("Search")
                        .navigationBarTitleDisplayMode(.inline)
                }
                .tabItem {
                    Label{
                        Text("Search")
                    } icon: {
                        Image("search")
                    }
                }
                
                NavigationStack {
                    MenuView()
                        .navigationTitle("Menu")
                        .navigationBarTitleDisplayMode(.inline)
                }
                .tabItem {
                    Label {
                        Text("Menu")
                    } icon: {
                        Image("menu")
                    }
                }
            }
            .background(.masterBackground)
            .tint(.masterPrimary)
            
            // Add this divider at the top of the tab bar
            Divider().background(.divider)
                .padding(.bottom, 49) // Adjust this value to match your tab bar height
        }
    }
}
