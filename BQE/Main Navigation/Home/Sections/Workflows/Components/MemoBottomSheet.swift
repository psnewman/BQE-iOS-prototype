//
//  MemoBottomSheet.swift
//  BQE
//
//  Created by Paul Newman on 12/23/24.
//

import SwiftUI

struct SheetNavigationBarModifier: ViewModifier {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.masterBackground)
        appearance.shadowColor = .clear
        
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    func body(content: Content) -> some View {
        content
    }
}

struct MemoBottomSheet: View {
    @Binding var isMemoSheetPresented: Bool
    @Binding var memo: String
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 4) {
//                ZStack(alignment: .top) {
                    TextEditor(text: $memo)
                        .frame(maxWidth: .infinity, minHeight: 80)
                        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                        .tint(.masterPrimary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isFocused ? .masterPrimary : .border, lineWidth: 1)
                        )
                        .focused($isFocused)
//                }
                .onAppear {
                    isFocused = true
                }
                
//                Spacer()
            }
            .padding(16)
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationTitle("Memo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isMemoSheetPresented = false
                        dismiss()
                    }
                    .foregroundColor(.masterPrimary)
                }
                
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Save") {
                        isFocused = false
                        isMemoSheetPresented = false
                        dismiss()
                    }
                    .foregroundColor(.masterPrimary)
                }
            }
            .toolbarBackground(.masterBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .modifier(SheetNavigationBarModifier())
    }
}

#Preview {
    @Previewable @State var memo = "Test memo"
    @Previewable @State var isMemoSheetPresented = true
    MemoBottomSheet(isMemoSheetPresented: $isMemoSheetPresented, memo: $memo)
}
