//
//  MyTimeEntryView.swift
//  BQE
//
//  Created by Paul Newman on 6/4/25.
//

import SwiftUI
import FASwiftUI

struct MyTimeEntryView: View {
    @State private var hours: Double = 1.0
    @State private var description: String = ""
    @State private var isBillable: Bool = true
    @State private var showDatePicker: Bool = false
    @State private var selectedDate: Date = Date()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with back button and title
            HStack {
                Button(action: {}) {
                    FAText(iconName: "chevron-left", size: 16, style: .solid)
                        .foregroundColor(Color("masterPrimary"))
                        .frame(width: 44, height: 44)
                }
                
                Spacer()
                
                Text("Time Entry")
                    .headlineStyle()
                    .foregroundColor(Color("typographyPrimary"))
                
                Spacer()
                
                // Invisible view to balance the layout
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 8)
            .frame(height: 44)
            .background(Color("masterBackground"))
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color("divider")),
                alignment: .bottom
            )
            
            // Main content
            ScrollView {
                VStack(spacing: 0) {
                    // Date row
                    Button(action: { showDatePicker = true }) {
                        HStack {
                            Text("Date")
                                .bodyStyle()
                                .foregroundColor(Color("typographyPrimary"))
                            
                            Spacer()
                            
                            HStack(spacing: 8) {
                                Text(dateFormatter.string(from: selectedDate))
                                    .bodyStyle()
                                    .foregroundColor(Color("typographyPrimary"))
                                
                                FAText(iconName: "calendar-days", size: 16, style: .solid)
                                    .foregroundColor(Color("typographySecondary"))
                                
                                FAText(iconName: "chevron-right", size: 12, style: .solid)
                                    .foregroundColor(Color("typographySecondary"))
                            }
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(Color("masterBackground"))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Divider()
                        .frame(height: 1)
                        .overlay(Color("divider"))
                        .padding(.leading, 16)
                    
                    // Hours row
                    HStack {
                        Text("Hours")
                            .bodyStyle()
                            .foregroundColor(Color("typographyPrimary"))
                        
                        Spacer()
                        
                        StepperView(value: $hours)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(Color("masterBackground"))
                    
                    Divider()
                        .frame(height: 1)
                        .overlay(Color("divider"))
                        .padding(.leading, 16)
                    
                    // Billable toggle
                    HStack {
                        HStack(spacing: 8) {
                            FAText(iconName: "dollar-sign", size: 16, style: .solid)
                                .foregroundColor(Color("typographyPrimary"))
                            
                            Text("Billable")
                                .bodyStyle()
                                .foregroundColor(Color("typographyPrimary"))
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: $isBillable)
                            .toggleStyle(SwitchToggleStyle(tint: Color("masterPrimary")))
                            .labelsHidden()
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(Color("masterBackground"))
                    
                    Divider()
                        .frame(height: 1)
                        .overlay(Color("divider"))
                        .padding(.leading, 16)
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .bodyStyle()
                            .foregroundColor(Color("typographyPrimary"))
                        
                        TextField("Add a description...", text: $description)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(12)
                            .frame(height: 40)
                            .background(Color("masterBackground"))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("border"), lineWidth: 1)
                            )
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(Color("masterBackground"))
                    
                    Spacer()
                    
                    // Save button
                    Button(action: {}) {
                        Text("Save")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color("masterPrimary"))
                            .cornerRadius(8)
                    }
                    .padding(16)
                    .background(Color("masterBackground"))
                }
                .background(Color("masterBackground"))
            }
            .background(Color("masterBackground"))
        }
        .background(Color("masterBackground"))
        .sheet(isPresented: $showDatePicker) {
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .presentationDetents([.medium])
        }
    }
}

struct StepperView: View {
    @Binding var value: Double
    var step: Double = 0.5
    var range: ClosedRange<Double> = 0...24
    
    private func increment() {
        withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
            value = min(value + step, range.upperBound)
        }
    }
    
    private func decrement() {
        withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
            value = max(value - step, range.lowerBound)
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // Decrement button
            Button(action: decrement) {
                ZStack {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 28, height: 28)
                    
                    Text("−") // Minus sign
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color("typographyPrimary"))
                        .offset(y: -1) // Optical alignment
                }
                .frame(width: 36, height: 36)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            
            // Divider
            Rectangle()
                .fill(Color("divider"))
                .frame(width: 1, height: 20)
            
            // Value display
            Text(String(format: "%.1f", value))
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color("typographyPrimary"))
                .frame(width: 44)
            
            // Divider
            Rectangle()
                .fill(Color("divider"))
                .frame(width: 1, height: 20)
            
            // Increment button
            Button(action: increment) {
                ZStack {
                    Circle()
                        .fill(Color("masterPrimary"))
                        .frame(width: 28, height: 28)
                    
                    Text("+")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(width: 36, height: 36)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
        }
        .background(Color("masterBackground"))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color("border"), lineWidth: 1)
        )
        .frame(width: 160, height: 40)
    }
}

#Preview {
    MyTimeEntryView()
}
