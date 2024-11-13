//
//  RecentItemsView.swift
//  BQE
//
//  Created by Paul Newman on 23.04.2024.
//

import SwiftUI

// RecentItemView remains the same
struct RecentItemView: View {
    @State private var icon: String
    @State private var name: String
    @State private var type: String
    
    init(icon: String, name: String, type: String) {
        self.icon = icon
        self.name = name
        self.type = type
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            
            HStack(spacing: 0) {
                Image(icon)
                    .foregroundColor(Color(red: 0.58, green: 0.64, blue: 0.72))
            }
            .frame(width: 32, height: 32)
            .padding(4)
            .frame(width: 64, height: 64)
            .background(.cardSecondary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .bodyStyle()
                    .foregroundColor(.typographyPrimary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text(type)
                    .font(.custom("font-inter", size: 12))
                    .foregroundColor(.typographySecondary)
                
            }
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 64)
        .background(.masterBackground)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                        .inset(by: 1)
                        .stroke(.border)
                )
    }
}

// RecentItemsListView remains mostly the same, but renamed to RecentItemsView
struct RecentItemsSectionView: View {
    let items = ["20-08 - SPOTLIGHT: Construction Documents", "20-04 - BRADFORD: Design Development", "Client Meeting"]
    let types = ["Time Card", "Time Entry", "Timer"]
    let icons = ["icon-type-timeCard", "icon-type-timeEntry", "icon-type-timer"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(0..<3, id: \.self) { number in
                RecentItemView(icon: icons[number], name: items[number], type: types[number])
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
        }
    }
}

#Preview {
    RecentItemsSectionView()
}

// End of file. No additional code.
