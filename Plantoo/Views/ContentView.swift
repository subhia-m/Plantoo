import SwiftUI

// MARK: - Main screen

struct ContentView: View {
    
    @State private var viewModel = RemindersViewModel()
    
    // Purely visual state, so it lives in the view, not the ViewModel
    @State private var showingSetReminder = false
    
    // nil = nothing is being edited, has a value = editing that plant
    @State private var reminderToEdit: Reminder?
    
    // Saved on the device, so it survives closing the app. false = new user.
    @AppStorage("hasSeenSplash") private var hasSeenSplash = false
    
    // The splash shows only until the user has tapped its button once
    private var showSplash: Bool { !hasSeenSplash }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                VStack(spacing: 5) {
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 1)
                    if showSplash {
                        SplashView {
                            hasSeenSplash = true// never show it again
                            showingSetReminder = true// open the form right away
                        }
                    }else if viewModel.isEmpty {
                        EmptyStateView()
                    }else if viewModel.allDone {
                        AllDoneView()
                    } else {
                        
                        Text(viewModel.progressMessage)
                            .font(.system(size: 18))
                            .foregroundStyle(Color.white)
                            .padding(.top, 20)
                        
                        ProgressView(value: viewModel.progress)
                            .tint(Color.appGreen)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                        
                        List(viewModel.reminders) { reminder in
                            PlantRowView(reminder: reminder) {
                                viewModel.toggle(reminder)
                            }
                            .contentShape(Rectangle())   // makes the whole row tappable
                            .onTapGesture { reminderToEdit = reminder }
                            
                            .listRowBackground(Color.clear)
                            
                            .listRowSeparatorTint(Color.white.opacity(0.15))
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    viewModel.delete(reminder)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationTitle("My Plants 🌱")
            
            .toolbarColorScheme(.dark, for: .navigationBar)
            
            // The button floats above the content, in the bottom right corner.
            // Hidden on the splash screen.
            .overlay(alignment: .bottomTrailing) {
                if !showSplash { addButton }
            }
        }
        .sheet(isPresented: $showingSetReminder) {
            SetReminderView(viewModel: viewModel)
        }
        .sheet(item: $reminderToEdit) { reminder in
            SetReminderView(viewModel: viewModel, reminder: reminder)
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
                    .font(.system(size: 28))
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
            
            Spacer()
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
                .foregroundStyle(color) // only the icon is colored
            
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
