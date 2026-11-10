import SwiftUI

struct ContentView: View {
    @State private var viewModel = RemindersViewModel()

    var body: some View {
        VStack {
            Text(viewModel.progressMessage)
            ProgressView(value: viewModel.progress)
                .padding(.horizontal)

            List(viewModel.reminders) { reminder in
                HStack {
                    Image(systemName: reminder.isDone ? "checkmark.circle.fill" : "circle")
                    Text(reminder.plantName)
                }
                .onTapGesture { viewModel.toggle(reminder) }
            }
        }
    }
}
 #Preview {
    ContentView()
}

