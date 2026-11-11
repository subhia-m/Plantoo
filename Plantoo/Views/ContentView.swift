import SwiftUI

// MARK: - Main screen
struct ContentView: View {
    @State private var viewModel = RemindersViewModel()
    // Purely visual state, so it lives in the view, not the ViewModel
    @State private var showingSetReminder = false

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                header

                Text(viewModel.progressMessage)
                    .font(.system(size: 18))
                    .foregroundStyle(Color.secondaryText)
                    .padding(.top, 12)
                ProgressView(value: viewModel.progress)
                    .tint(Color.appGreen)
                    .padding(.horizontal)
                    .padding(.vertical, 8)

                List(viewModel.reminders) { reminder in
                    PlantRowView(reminder: reminder) {
                        viewModel.toggle(reminder)
                    }
                    .listRowBackground(Color.clear)
                }
                .scrollContentBackground(.hidden)
            }
        }
        // The button floats above the content, in the bottom right corner
        .overlay(alignment: .bottomTrailing) {
            addButton
        }
        .sheet(isPresented: $showingSetReminder) {
            Text("Set Reminder form comes next")   // TODO: replace with the real form
        }
    }

    // MARK: - Pieces of the screen
    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("My Plants 🌱")
                .font(.largeTitle.bold())
                .tracking(0.37)
                .foregroundStyle(.white)
                .padding(.horizontal)
            Rectangle()
                .fill(Color.white.opacity(0.2))
                .frame(height: 1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var addButton: some View {
        Button {
            showingSetReminder = true
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .semibold))
                .frame(width: 32, height: 32)
        }
        .buttonStyle(.glassProminent)       // Liquid Glass (iOS 26)
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
                    .foregroundStyle(Color.appGreen)
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
                    TagView(icon: "sun.max", text: reminder.light.rawValue)
                        .foregroundStyle(.orange)
                    
                    TagView(icon: "drop", text: reminder.water.rawValue)
                }
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Small tag (light / water)
private struct TagView: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
            Text(text)
        }
        .font(.system(size: 10))
        .foregroundStyle(Color.secondaryText)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.cardBackground, in: Capsule())
    }
}
#Preview {
    ContentView()
}
