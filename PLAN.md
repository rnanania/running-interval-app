# Running Interval Timer — App Plan

## Overview
A simple iPhone + Apple Watch app for runners to configure repeating time intervals. Intervals loop continuously, ringing/vibrating at each boundary, until the user stops the session.

---

## Platform & Tech Stack

| Layer | Choice |
|---|---|
| Language | Swift + SwiftUI |
| Targets | iOS app + watchOS app (single Xcode project) |
| Phone ↔ Watch sync | WatchConnectivity |
| Audio alerts | AVFoundation (system sound / custom ring) |
| Haptics | UIImpactFeedbackGenerator (iOS) + WKInterfaceDevice (watchOS) |

---

## Screens & Flow

### 1. Setup Screen (iPhone & Watch)

- A large **"+ Interval"** button — each tap appends one interval to the list
- Each interval row shows:
  - Label: "Interval 1", "Interval 2", etc.
  - Duration display: starts at **0:05**, increments by **5 seconds** per tap on the row
  - Long-press or swipe to **delete** an interval
- **Total time** displayed at the bottom (sum of all intervals = one full loop)
- **"Start"** button — enabled only when at least one interval has duration > 0

### 2. Running Screen (iPhone & Watch)

- Current interval label (e.g., "Interval 2 of 3 — Loop 4")
- Large **countdown timer** for time remaining in current interval
- Loop counter: how many full loops have completed
- Total elapsed time since start
- At each interval boundary: **ring sound + haptic vibration**
- At the end of each full loop: **double ring** to signal loop restart
- **"Stop"** button — ends session, returns to Setup Screen

### 3. Session Complete / Stopped Screen
- Brief summary: total time elapsed, total loops completed
- **"Done"** button back to Setup

---

## Interval Loop Behavior

- Intervals play in order: 1 → 2 → 3 → 1 → 2 → 3 → ... indefinitely
- User taps **Stop** at any point to end the session
- There is no fixed total duration — the loop runs until stopped
- Each interval boundary triggers: **1 ring + haptic**
- Each full loop completion triggers: **2 rings + haptic** (instead of the single ring)

---

## Data Model

```swift
struct IntervalItem: Identifiable {
    var id: UUID
    var durationSeconds: Int   // multiples of 5, minimum 5
}

struct SessionConfig {
    var intervals: [IntervalItem]
    var totalLoopDuration: Int { intervals.reduce(0) { $0 + $1.durationSeconds } }
}

enum SessionState {
    case idle
    case running
    case finished
}

struct SessionState {
    var config: SessionConfig
    var currentIntervalIndex: Int
    var loopCount: Int
    var elapsedSeconds: Int
    var state: RunState
}
```

---

## Watch Sync Strategy

- User configures intervals on **iPhone**
- Tapping **"Start"** sends the `SessionConfig` to Apple Watch via WatchConnectivity
- Watch runs its **own independent countdown** — no need to stay connected mid-run
- Both phone and watch ring/vibrate at each interval and loop boundary
- If watch is not paired/reachable, iPhone runs the session solo

---

## Key Design Decisions

| Decision | Choice | Reason |
|---|---|---|
| Increment unit | 5 seconds per tap | No keyboard needed, thumb-friendly |
| Minimum interval duration | 5 seconds | Avoids zero-duration intervals |
| Loop behavior | Infinite loop until Stop | Supports any run length without pre-planning |
| End-of-loop signal | Double ring | Distinguishes interval vs. loop boundary |
| Pause support | No (v1) | Keeps the UX simple |
| Watch independence | Yes, once started | Runner may pocket phone mid-run |
| Interval config on Watch | No (v1) | Configure on phone, run on watch |

---

## File Structure (Xcode Project)

```
RunningIntervalApp/
├── Shared/
│   ├── Models/
│   │   └── IntervalItem.swift
│   ├── SessionConfig.swift
│   └── WatchConnectivityManager.swift
├── iOS/
│   ├── Views/
│   │   ├── SetupView.swift
│   │   ├── IntervalRowView.swift
│   │   └── RunningView.swift
│   └── RunningIntervalApp.swift
└── watchOS/
    ├── Views/
    │   ├── WatchSetupView.swift
    │   └── WatchRunningView.swift
    └── RunningIntervalWatchApp.swift
```

---

## Implementation Phases

### Phase 1 — iOS Core
- [ ] Xcode project setup (iOS + watchOS targets)
- [ ] `IntervalItem` + `SessionConfig` models
- [ ] Setup screen: add/remove intervals, tap to increment duration
- [ ] Running screen: countdown timer, loop logic, ring + haptic on boundary

### Phase 2 — watchOS
- [ ] Watch app UI mirroring running screen
- [ ] WatchConnectivity: send config from phone on Start
- [ ] Independent timer + alert logic on watch

### Phase 3 — Polish
- [ ] End-of-session summary screen
- [ ] Double-ring at loop boundary
- [ ] Edge cases: app backgrounded, watch disconnected mid-run
