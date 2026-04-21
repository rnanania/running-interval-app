import Foundation

enum RunState: Equatable {
    case idle, running, stopped
}

class SessionManager: ObservableObject {
    @Published var intervals: [IntervalItem] = []
    @Published var runState: RunState = .idle
    @Published var currentIntervalIndex: Int = 0
    @Published var loopCount: Int = 0
    @Published var timeRemainingInInterval: Int = 0
    @Published var totalElapsedSeconds: Int = 0

    var onIntervalEnd: (() -> Void)?
    var onLoopEnd: (() -> Void)?

    private var timer: Timer?

    var currentInterval: IntervalItem? {
        guard !intervals.isEmpty else { return nil }
        return intervals[currentIntervalIndex]
    }

    var totalLoopDuration: Int {
        intervals.reduce(0) { $0 + $1.durationSeconds }
    }

    var canStart: Bool {
        !intervals.isEmpty && intervals.allSatisfy { $0.durationSeconds > 0 }
    }

    func addInterval() {
        intervals.append(IntervalItem())
    }

    func removeInterval(at offsets: IndexSet) {
        intervals.remove(atOffsets: offsets)
    }

    func removeInterval(id: UUID) {
        intervals.removeAll { $0.id == id }
    }

    func incrementDuration(for id: UUID) {
        guard let index = intervals.firstIndex(where: { $0.id == id }) else { return }
        intervals[index].durationSeconds += 5
    }

    func decrementDuration(for id: UUID) {
        guard let index = intervals.firstIndex(where: { $0.id == id }) else { return }
        intervals[index].durationSeconds = max(5, intervals[index].durationSeconds - 5)
    }

    func start() {
        guard canStart else { return }
        currentIntervalIndex = 0
        loopCount = 1
        timeRemainingInInterval = intervals[0].durationSeconds
        totalElapsedSeconds = 0
        runState = .running
        startTimer()
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        runState = .stopped
    }

    func reset() {
        stop()
        runState = .idle
        currentIntervalIndex = 0
        loopCount = 0
        timeRemainingInInterval = 0
        totalElapsedSeconds = 0
    }

    private func startTimer() {
        timer?.invalidate()
        let t = Timer(timeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    private func tick() {
        totalElapsedSeconds += 1
        timeRemainingInInterval -= 1
        if timeRemainingInInterval <= 0 {
            advanceInterval()
        }
    }

    private func advanceInterval() {
        let nextIndex = currentIntervalIndex + 1
        if nextIndex >= intervals.count {
            currentIntervalIndex = 0
            loopCount += 1
            onLoopEnd?()
        } else {
            currentIntervalIndex = nextIndex
            onIntervalEnd?()
        }
        timeRemainingInInterval = intervals[currentIntervalIndex].durationSeconds
    }
}
