//
//  SettingsView.swift
//  BQE
//
//  Created by Paul Newman on 03.05.2024.
//

import SwiftUI

struct SettingsView: View {
    @State private var ratePerKm: Double = 0.50 // Initial rate per km
    @State private var taxPercentage: Double = 15.0 // Initial tax percentage
    @State private var enforceWorkHours: Bool = true
    @State private var enableWeekendTracking: Bool = false
    @State private var distanceUnit: DistanceUnit = .km
    @State private var saveAttachmentAsPDF: Bool = false // State variable for the toggle
    @State private var syncWithCalendarApp: Bool = false // State variable for the sync toggle
    
    enum DistanceUnit: String, CaseIterable {
        case km = "km"
        case mi = "mi"
    }
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Time & Expense Tracking").bodyStyle()) {
                    NavigationLink(destination: Text("Time & Expense Details").bodyStyle()) {
                        Text("Time & Expense").bodyStyle()
                    }
                    NavigationLink(destination: Text("Visits & Trips Details").bodyStyle()) {
                        Text("Visits & Trips").bodyStyle()
                    }
                }
                
                Section(header: Text("General").bodyStyle()) {
                    NavigationLink(destination: Text("Notifications Settings").bodyStyle()) {
                        Text("Notifications").bodyStyle()
                    }
                    NavigationLink(destination: Text("Home Screen Settings").bodyStyle()) {
                        Text("Home Screen").bodyStyle()
                    }
                    Toggle("Save Attachment as PDF", isOn: $saveAttachmentAsPDF)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .bodyStyle()
                    Toggle("Sync With Calendar App", isOn: $syncWithCalendarApp)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .bodyStyle()
                }
                
                Section(header: Text("Human Resources").bodyStyle()) {
                    NavigationLink(destination: Text("Review Templates Details").bodyStyle()) {
                        Text("Review Templates").bodyStyle()
                    }
                    NavigationLink(destination: Text("About Details").bodyStyle()) {
                        Text("About").bodyStyle()
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingsView()
}
