import SwiftUI

struct WatchRunningView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 4) {
            Text("Loop \(sessionManager.loopCount)")
                .font(.caption2)
                .foregroundStyle(.secondary)

            Text("\(sessionManager.currentIntervalIndex + 1) / \(sessionManager.intervals.count)")
                .font(.caption)

            Text(formattedRemaining)
                .font(.system(size: 52, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(countdownColor)
                .contentTransition(.numericText(countsDown: true))

            Button("Stop") {
                sessionManager.stop()
                dismiss()
            }
            .foregroundStyle(.red)
            .padding(.top, 4)
        }
        .navigationBarBackButtonHidden()
        .onDisappear {
            if sessionManager.runState == .running {
                sessionManager.stop()
            }
        }
    }

    private var formattedRemaining: String {
        let t = sessionManager.timeRemainingInInterval
        return String(format: "%d:%02d", t / 60, t % 60)
    }

    private var countdownColor: Color {
        sessionManager.timeRemainingInInterval <= 3 ? .red : .primary
    }
}
