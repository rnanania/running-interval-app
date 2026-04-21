import SwiftUI

struct RunningView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // Loop counter
            Text("Loop \(sessionManager.loopCount)")
                .font(.title3)
                .foregroundStyle(.secondary)

            // Interval progress
            Text("Interval \(sessionManager.currentIntervalIndex + 1) of \(sessionManager.intervals.count)")
                .font(.headline)

            // Progress dots
            HStack(spacing: 10) {
                ForEach(0..<sessionManager.intervals.count, id: \.self) { i in
                    Circle()
                        .fill(i == sessionManager.currentIntervalIndex ? Color.accentColor : Color.secondary.opacity(0.3))
                        .frame(width: 12, height: 12)
                        .animation(.easeInOut, value: sessionManager.currentIntervalIndex)
                }
            }

            // Countdown
            Text(formattedRemaining)
                .font(.system(size: 88, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(countdownColor)
                .animation(.easeInOut, value: countdownColor)
                .contentTransition(.numericText(countsDown: true))

            // Total elapsed
            Text("Elapsed: \(formattedElapsed)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .monospacedDigit()

            Spacer()

            Button {
                sessionManager.stop()
                dismiss()
            } label: {
                Text("Stop")
                    .font(.title2.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .padding(.horizontal)
            .padding(.bottom)
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

    private var formattedElapsed: String {
        let t = sessionManager.totalElapsedSeconds
        return String(format: "%d:%02d", t / 60, t % 60)
    }

    private var countdownColor: Color {
        let t = sessionManager.timeRemainingInInterval
        if t <= 3 { return .red }
        if t <= 8 { return .orange }
        return .primary
    }
}
