import SwiftUI

struct WatchSetupView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @State private var isRunning = false

    var body: some View {
        NavigationStack {
            List {
                if sessionManager.intervals.isEmpty {
                    Text("Tap + to add intervals")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                } else {
                    ForEach(sessionManager.intervals) { interval in
                        WatchIntervalRowView(interval: interval)
                    }
                    .onDelete { sessionManager.removeInterval(at: $0) }
                }

                Button {
                    sessionManager.addInterval()
                } label: {
                    Label("Add Interval", systemImage: "plus")
                }

                if sessionManager.canStart {
                    Button {
                        sessionManager.start()
                        isRunning = true
                    } label: {
                        Label("Start", systemImage: "play.fill")
                    }
                    .foregroundStyle(.green)
                }
            }
            .navigationTitle("Intervals")
            .navigationDestination(isPresented: $isRunning) {
                WatchRunningView()
                    .environmentObject(sessionManager)
            }
        }
    }
}

struct WatchIntervalRowView: View {
    @EnvironmentObject var sessionManager: SessionManager
    let interval: IntervalItem

    private var index: Int {
        sessionManager.intervals.firstIndex(where: { $0.id == interval.id }) ?? 0
    }

    var body: some View {
        VStack(spacing: 4) {
            Text("#\(index + 1)")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 0) {
                Button {
                    sessionManager.decrementDuration(for: interval.id)
                } label: {
                    Image(systemName: "minus")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(interval.durationSeconds <= 5 ? Color.gray : Color.red)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.red.opacity(interval.durationSeconds <= 5 ? 0.08 : 0.2))
                }
                .buttonStyle(.plain)
                .disabled(interval.durationSeconds <= 5)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                Text(interval.formattedDuration)
                    .font(.title3.monospacedDigit())
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)

                Button {
                    sessionManager.incrementDuration(for: interval.id)
                } label: {
                    Image(systemName: "plus")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(Color.blue)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.blue.opacity(0.2))
                }
                .buttonStyle(.plain)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .frame(height: 36)
        }
        .padding(.vertical, 4)
    }
}
