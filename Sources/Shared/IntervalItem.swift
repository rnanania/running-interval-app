import Foundation

struct IntervalItem: Identifiable, Codable, Equatable {
    var id = UUID()
    var durationSeconds: Int = 5

    var formattedDuration: String {
        String(format: "%d:%02d", durationSeconds / 60, durationSeconds % 60)
    }
}
