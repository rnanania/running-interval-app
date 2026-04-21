import SwiftUI

struct IntervalRowView: View {
    @EnvironmentObject var sessionManager: SessionManager
    let interval: IntervalItem

    private var index: Int {
        sessionManager.intervals.firstIndex(where: { $0.id == interval.id }) ?? 0
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Interval \(index + 1)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(interval.formattedDuration)
                    .font(.title2.monospacedDigit())
                    .fontWeight(.semibold)
            }

            Spacer()

            HStack(spacing: 16) {
                Button {
                    sessionManager.decrementDuration(for: interval.id)
                } label: {
                    VStack(spacing: 2) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title)
                            .foregroundStyle(interval.durationSeconds <= 5 ? Color.gray : Color.red)
                        Text("-5s")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .buttonStyle(.plain)
                .disabled(interval.durationSeconds <= 5)

                Button {
                    sessionManager.incrementDuration(for: interval.id)
                } label: {
                    VStack(spacing: 2) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundStyle(.blue)
                        Text("+5s")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .buttonStyle(.plain)

                Button {
                    sessionManager.removeInterval(id: interval.id)
                } label: {
                    VStack(spacing: 2) {
                        Image(systemName: "trash.circle.fill")
                            .font(.title)
                            .foregroundStyle(Color.red.opacity(0.8))
                        Text("Del")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 4)
    }
}
