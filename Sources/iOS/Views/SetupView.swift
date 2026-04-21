import SwiftUI

struct SetupView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @State private var isRunning = false

    var body: some View {
        NavigationStack {
            Group {
                if sessionManager.intervals.isEmpty {
                    emptyState
                } else {
                    intervalList
                }
            }
            .navigationTitle("Interval Timer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        sessionManager.addInterval()
                    } label: {
                        Label("Add Interval", systemImage: "plus.circle.fill")
                            .labelStyle(.titleAndIcon)
                            .font(.subheadline.weight(.semibold))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .controlSize(.small)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    if sessionManager.canStart {
                        Button {
                            sessionManager.start()
                            isRunning = true
                        } label: {
                            Label("Start", systemImage: "play.fill")
                                .labelStyle(.titleAndIcon)
                                .font(.subheadline.weight(.semibold))
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                        .controlSize(.small)
                    }
                }
            }
            .navigationDestination(isPresented: $isRunning) {
                RunningView()
                    .environmentObject(sessionManager)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "timer")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            Text("Tap + Add Interval to get started")
                .font(.headline)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }

    private var intervalList: some View {
        List {
            ForEach(sessionManager.intervals) { interval in
                IntervalRowView(interval: interval)
            }
            .onDelete { sessionManager.removeInterval(at: $0) }

            HStack {
                Text("Loop duration")
                    .foregroundStyle(.secondary)
                Spacer()
                Text(formattedTotal)
                    .fontWeight(.semibold)
                    .monospacedDigit()
            }
            .listRowBackground(Color.clear)
        }
        .listStyle(.insetGrouped)
    }

    private var formattedTotal: String {
        let t = sessionManager.totalLoopDuration
        return String(format: "%d:%02d", t / 60, t % 60)
    }
}
