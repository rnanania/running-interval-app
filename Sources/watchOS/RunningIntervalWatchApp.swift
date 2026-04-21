import SwiftUI
import WatchKit

@main
struct RunningIntervalWatchApp: App {
    @StateObject private var sessionManager = SessionManager()

    var body: some Scene {
        WindowGroup {
            WatchSetupView()
                .environmentObject(sessionManager)
                .onAppear { setupAlerts() }
        }
    }

    private func setupAlerts() {
        sessionManager.onIntervalEnd = {
            WKInterfaceDevice.current().play(.notification)
        }
        sessionManager.onLoopEnd = {
            WKInterfaceDevice.current().play(.success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                WKInterfaceDevice.current().play(.success)
            }
        }
    }
}
