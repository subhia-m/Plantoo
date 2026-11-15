import SwiftUI

@main struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            //forse the app to be on dark mode always
                .preferredColorScheme(.dark)
        }
    }
}
