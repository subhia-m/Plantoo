import SwiftUI

// MARK: - Main screen

struct ContentView: View {
    
    @State private var viewModel = RemindersViewModel()
    
    // Purely visual state, so it lives in the view, not the ViewModel
    @State private var showingSetReminder = false
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Color.appBackground.ignoresSafeArea()
                
                VStack(spacing: 5) {
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 1)
                    
                    Text(viewModel.progressMessage)
                    
                        .font(.system(size: 18))
                    
                        .foregroundStyle(Color.secondaryText)
                        .padding(.top, 20)
                    
                    ProgressView(value: viewModel.progress)
                        .tint(Color.appGreen)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                    
                    List(viewModel.reminders) { reminder in
                        
                        PlantRowView(reminder: reminder) {
                            
                            viewModel.toggle(reminder)
                            
                        }
                        
                        .listRowBackground(Color.clear)
                        
                        .listRowSeparatorTint(Color.white.opacity(0.15))
                        
                    }
                    
                    .listStyle(.plain)
                    
                    .scrollContentBackground(.hidden)
                    
                }
                
            }
            
            .navigationTitle("My Plants 🌱")
        
            .toolbarColorScheme(.dark, for: .navigationBar)
            
            // The button floats above the content, in the bottom right corner
            .overlay(alignment: .bottomTrailing) {
                
                addButton
                
            }
            
            .sheet(isPresented: $showingSetReminder) {
                
                SetReminderView(viewModel: viewModel)
                
            }
            
        }
        
    }
    
    // MARK: - Set Reminder form
    
    private struct SetReminderView: View {
        
        @Environment(\.dismiss) private var dismiss
        
        // Same ViewModel as the list, passed in from ContentView
        let viewModel: RemindersViewModel
        
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
                            .tint(Color.appGreen)    // the green cursor from the design
                            
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
                            
                            let reminder = Reminder(plantName: plantName, room: room, light: light,
                                                    
                                                    wateringDays: wateringDays, water: water)
                            
                            viewModel.add(reminder)
                            
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
    
    // MARK: - Pieces of the screen
    
    private var addButton: some View {
        
        Button {
            
            showingSetReminder = true
            
        } label: {
            
            Image(systemName: "plus")
            
                .font(.system(size: 20, weight: .semibold))
            
                .frame(width: 32, height: 32)
            
        }
        
        .buttonStyle(.glassProminent)   // Liquid Glass (iOS 26)
        
        .buttonBorderShape(.circle)
        
        .tint(Color.appGreen)
        
        .padding(.trailing, 20)
        
        .padding(.bottom, 12)
        
    }
    
}

// MARK: - One row of the list

private struct PlantRowView: View {
    
    let reminder: Reminder
    
    let onToggle: () -> Void
    
    var body: some View {
        
        HStack(spacing: 12) {
            
            Button(action: onToggle) {
                
                Image(systemName: reminder.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundStyle(reminder.isDone
                                     
                                     ? Color.appGreen
                                     
                                     : Color.white)
                
            }
            
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 4) {
                
                HStack(spacing: 3) {
                    
                    Image(systemName: "location")
                    
                    Text("in \(reminder.room.rawValue)")
                    
                }
                
                .font(.system(size: 11))
                
                .foregroundStyle(Color.secondaryText)
                
                Text(reminder.plantName)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(.white)
                
                HStack(spacing: 8) {
                    
                    TagView(icon: "sun.max", text: reminder.light.rawValue,color: Color(red: 204 / 255, green: 199 / 255, blue: 133 / 255, opacity: 0.68))
                    
                    TagView(icon: "drop", text: reminder.water.rawValue, color: Color(red: 202 / 255, green: 243 / 255, blue: 251 / 255, opacity: 1.00))
                    
                }
                
            }
            
            //Grey when selected
            
            .opacity(reminder.isDone ? 0.55 : 1)
            
            .animation(.easeInOut(duration: 0.2), value: reminder.isDone)
            
            //Spacer()
            
        }
        
        .padding(.vertical, 8)
        
    }
    
}

// MARK: - Small tag (light / water)

private struct TagView: View {
    
    let icon: String
    
    let text: String
    
    let color: Color   // each tag brings its own color
    
    var body: some View {
        
        HStack(spacing: 4) {
            
            Image(systemName: icon)
                .foregroundStyle(color)   // only the icon is colored
            
            Text(text)
                .foregroundStyle(color)
            
        }
        
        .font(.system(size: 10))
        
        .padding(.horizontal, 8)
        
        .padding(.vertical, 4)
        
        .background(Color.cardBackground, in: Capsule())
        
    }
    
}

#Preview {
    
    ContentView()
    
}
