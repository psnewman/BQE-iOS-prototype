import SwiftUI
import FASwiftUI

struct TimeCardView: View {
  @State private var selectedWeek: Date = Date()
  @State private var selectedResource: String = "Steve Burns"

  var body: some View {
    NavigationStack {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                WeekPickerView(selectedWeek: $selectedWeek)
                WeekdaysHeaderView(selectedWeek: $selectedWeek)
            }
            ScrollView {
                VStack {
                    Menu {
                        Button("Steve Burns") { selectedResource = "Steve Burns" }
                        Button("John Doe") { selectedResource = "John Doe" }
                        Button("Jane Smith") { selectedResource = "Jane Smith" }
                    } label: {
                        HStack(spacing: 8) {
                            Text("Resource:")
                                .bodyStyle()
                                .foregroundColor(.typographySecondary)
                            Text(selectedResource)
                                .bodyStyle()
                                .foregroundColor(.typographyPrimary)
                            Spacer()
                            FAText(iconName: "chevron-down", size: 14, style: .solid)
                                .foregroundColor(.typographyPrimary)
                        }
                        .frame(height: 40)
                        .padding(.horizontal, 12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.border, lineWidth: 1)
                        )
                    }
                }
                .padding(16)
                VStack(spacing: 16) {
                    ForEach(0..<7) { i in
                        TimeCardRowView(entry: .sample(projectIndex: i))
                    }
                }
            }
            .background(.masterBackground)
            .navigationTitle("Time Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        Button(action: {
                            // Filter action
                        }) {
                            FAText(iconName: "filter", size: 16, style: .regular)
                            .foregroundColor(.white)            }
                        Button(action: {
                            // Add action
                        }) {
                            FAText(iconName: "plus", size: 16, style: .solid)
                            .foregroundColor(.white)            }
                        Button(action: {
                            // More action
                        }) {
                            FAText(iconName: "ellipsis", size: 16, style: .solid)
                            .foregroundColor(.white)            }
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                TimeCardTotalBarView()
            }
        }
    }
  }
}

#Preview {
    TimeCardView()
}
