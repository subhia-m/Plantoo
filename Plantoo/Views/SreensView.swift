//
//  SreensView.swift
//  Plantoo
//
//  Created by subhia  on 15/11/2026.
//

import SwiftUI

// MARK: - Empty state
struct EmptyStateView: View {
    var body: some View {
        Text("No reminders set yet...")
            .font(.system(size: 20))
            .foregroundStyle(Color.secondaryText)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - All done state
struct AllDoneView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image("PlantMascot2")
                .resizable()
                .scaledToFit()
                .frame(width: 140)
            Text("All Done! 🎉")
                .font(.system(size: 25, weight: .semibold))
                .foregroundStyle(.white)
            Text("All Reminders Completed")
                .font(.system(size: 16))
                .foregroundStyle(Color.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
// MARK: - Splash screen
struct SplashView: View {
    let onStart: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Image("PlantMascot")
                .resizable().scaledToFit()
                .frame(width: 164)
            Text("Start your plant journey!")
                .font(.system(size: 25, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.top, 28)
            Text("Now all your plants will be in one place and we will help you take care of them :)🪴")
                .font(.system(size: 16))
                .foregroundStyle(Color.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.top, 12)
                .padding(.horizontal, 30)
            Spacer()
            Button(action: onStart) {
                Text("Set Plant Reminder")
                    .font(.system(size: 17))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.capsule)
            .tint(Color.appGreen)
            .padding(.horizontal, 60)
            .padding(.bottom, 160)
        }
    }
}

#Preview {
    
    ContentView()
    
}
