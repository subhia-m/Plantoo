//
//  SetReminderView.swift
//  Plantoo
//
//  Created by subhia  on 15/11/2026.

import SwiftUI
// MARK: - Set Reminder form

struct SetReminderView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    // Same ViewModel as the list, passed in from ContentView
    let viewModel: RemindersViewModel
    // nil = adding a new plant, has a value = editing that plant
    let reminder: Reminder?
    //An initializer is a special function that prepares an object when it's created.
    init(viewModel: RemindersViewModel, reminder: Reminder? = nil) {
        self.viewModel = viewModel
        self.reminder = reminder
        
        // Start the draft fields from the plant being edited, or from defaults
        _plantName = State(initialValue: reminder?.plantName ?? "")
        _room = State(initialValue: reminder?.room ?? .bedroom)
        _light = State(initialValue: reminder?.light ?? .fullSun)
        _wateringDays = State(initialValue: reminder?.wateringDays ?? .daily)
        _water = State(initialValue: reminder?.water ?? .low)
    }
    
    // The form's own draft values, until the user taps save
    @State private var plantName = ""
    
    @State private var room: Room = .bedroom
    
    @State private var light: Light = .fullSun
    
    @State private var wateringDays: WateringDays = .daily
    
    @State private var water: Water = .low
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                Color.addCard.ignoresSafeArea()
                VStack(spacing: 40) {
                    
                    HStack(spacing: 8) {
                        
                        Text("Plant Name")
                            .foregroundStyle(.white)
                        
                        TextField(
                            
                            "Plant Name",
                            
                            text: $plantName,
                            
                            prompt: Text("Pothos").foregroundStyle(Color.secondaryText.opacity(0.6))
                            
                        )
                        
                        .foregroundStyle(.white)
                        .tint(Color.appGreen) // the green cursor
                        
                    }
                    
                    .padding()
                    
                    .background(Color.textfield.opacity(0.4),
                                
                                in: RoundedRectangle(cornerRadius: 30))
                    
                    // Group 1
                    
                    VStack (spacing: 0){
                        
                        pickerRow(title: "Room", icon: "location", selection: $room, options: Room.allCases)
                        
                        Divider().overlay(Color.white.opacity(0.2)).padding(.horizontal)
                        
                        pickerRow(title: "Light", icon: "sun.max", selection: $light, options: Light.allCases)
                        
                    }
                    
                    .background(Color.textfield.opacity(0.4), in: RoundedRectangle(cornerRadius: 30))
                    
                    // Group 2
                    
                    VStack (spacing: 0) {
                        
                        pickerRow(title: "Watering Days", icon: "drop", selection: $wateringDays,
                                  
                                  options: WateringDays.allCases)
                        
                        Divider().overlay(Color.white.opacity(0.2)).padding(.horizontal)
                        
                        pickerRow(title: "Water", icon: "drop", selection: $water, options: Water.allCases)
                        
                    }
                    
                    .background(Color.textfield.opacity(0.4),
                                
                                in: RoundedRectangle(cornerRadius: 30))
                    
                    // Only shown when editing an existing plant
                    if reminder != nil {
                        Button(role: .destructive) {
                            if let reminder {
                                viewModel.delete(reminder)
                            }
                            dismiss()
                        } label: {
                            Text("Delete Reminder")
                                .font(.system(size: 17))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                        }
                        .foregroundStyle(.red)
                        .background(Color.textfield.opacity(0.4),
                                    in: RoundedRectangle(cornerRadius: 30))
                    }
                    Spacer()
                    
                }
                
                .padding(.horizontal).padding(.vertical, 20)
                
            }
            
            .navigationTitle("Set Reminder")
            
            .navigationBarTitleDisplayMode(.inline)   // small title, centered between the buttons
            
            .toolbarColorScheme(.dark, for: .navigationBar)
            
            .toolbar {
                
                ToolbarItem(placement: .cancellationAction) {
                    
                    Button {dismiss() }
                    
                    label: {
                        
                        Image(systemName: "xmark")
                        
                    }
                    
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    
                    Button {
                        var newReminder = Reminder(plantName: plantName, room: room, light: light,
                                                   wateringDays: wateringDays, water: water)
                        
                        if let reminder {
                            // Editing: keep the same id and done state, then update
                            newReminder.id = reminder.id
                            newReminder.lastCompletedDate = reminder.lastCompletedDate
                            newReminder.isArchived = reminder.isArchived
                            viewModel.update(newReminder)
                        }else {
                            viewModel.add(newReminder)
                        }
                        dismiss()
                        
                    } label: { Image(systemName: "checkmark")
                        
                        .foregroundColor(Color.white)}
                    
                    .disabled(plantName.isEmpty)   // an empty name can't be saved
                    
                    .buttonStyle(.glassProminent)   // Liquid Glass (iOS 26)
                    
                    .buttonBorderShape(.circle)
                    
                    .tint(Color.appGreen)
                }
            }
        }
    }
    // One reusable row: icon + label on the left, a picker on the right
    
    private func pickerRow<T: Hashable & Identifiable & RawRepresentable>(
        title: String, icon: String, selection: Binding<T>, options: [T]
        
    ) -> some View where T.RawValue == String {
        
        HStack {
            
            Label(title, systemImage: icon)
                .foregroundStyle(.white)
            
            Spacer()
            
            Picker(title, selection: selection) {
                
                ForEach(options) { option in
                    
                    Text(option.rawValue).tag(option)
                }
            }
            .tint(Color.secondaryText)
        }
        .padding(.horizontal, 16)
        
        .padding(.vertical, 8)
    }
}
#Preview {
    
    ContentView()
    
}
