import SwiftUI

@main
struct RunningIntervalApp: App {
    @StateObject private var sessionManager = SessionManager()

    var body: some Scene {
        WindowGroup {
            SetupView()
                .environmentObject(sessionManager)
                .onAppear { setupAlerts() }
        }
    }

    private func setupAlerts() {
        sessionManager.onIntervalEnd = {
            iOSAlertManager.playIntervalEnd()
        }
        sessionManager.onLoopEnd = {
            iOSAlertManager.playLoopEnd()
        }
    }
}
