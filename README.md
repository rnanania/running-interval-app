# Cadence — Running Interval Timer

A minimal iPhone + Apple Watch app for runners who train with time-based intervals. Configure multiple intervals, tap Start, and the app rings at every boundary — looping indefinitely until you stop.

---

## Features

- **Add up to any number of intervals** — each tap of Add Interval creates a new one
- **+5s / −5s buttons** on every interval for quick, no-keyboard configuration
- **Infinite loop** — intervals repeat in order until you tap Stop
- **Audio + haptic alerts** at every interval boundary
- **Double alert** at the end of each full loop so you always know where you are
- **Countdown turns orange → red** in the final seconds of each interval
- **Apple Watch support** — runs independently on the watch once started
- **Swipe to delete** intervals on both iPhone and Watch

---

## How It Works

1. Tap **+ Add Interval** to add intervals to your session
2. Tap **+5s** or **−5s** on each row to set the duration (increments of 5 seconds)
3. Tap **Start** — the countdown begins
4. The app rings and vibrates at the end of each interval, moving to the next automatically
5. At the end of a full loop it double-rings and starts over from interval 1
6. Tap **Stop** at any time to end the session

### Example — 60 min run
| Interval | Duration | Purpose |
|---|---|---|
| 1 | 1:30 | Run |
| 2 | 0:30 | Walk |

Set these two intervals once. The app loops them for as long as you run.

---

## Requirements

| Target | Minimum OS |
|---|---|
| iPhone | iOS 17.0+ |
| Apple Watch | watchOS 10.0+ |

Tested on **iPhone 16 Pro** and **Apple Watch Series 9 40mm (MU672LL/A)**.

---

## Project Structure

```
Sources/
├── Shared/
│   ├── IntervalItem.swift       — data model
│   └── SessionManager.swift     — timer engine, loop logic, alert callbacks
├── iOS/
│   ├── RunningIntervalApp.swift — app entry, wires audio + haptic alerts
│   ├── iOSAlertManager.swift    — system sound + UINotificationFeedbackGenerator
│   └── Views/
│       ├── SetupView.swift      — interval list, add/start controls in toolbar
│       ├── IntervalRowView.swift — +5s / −5s / delete per row
│       └── RunningView.swift    — countdown, loop counter, progress dots
└── watchOS/
    ├── RunningIntervalWatchApp.swift — watch entry, WKInterfaceDevice haptics
    └── Views/
        ├── WatchSetupView.swift  — stepper cards, swipe-to-delete
        └── WatchRunningView.swift — compact countdown for wrist
```

---

## Running Locally

See [LOCAL_RUN.md](LOCAL_RUN.md) for full instructions covering:
- iPhone + Watch simulator setup
- Physical device setup (Developer Mode, signing, deploy to watch)
- Troubleshooting common issues

**Quick start (simulator):**
1. Open `RunningIntervalApp.xcodeproj` in Xcode
2. Select any iPhone simulator
3. Press `⌘R`

---

## Architecture

The app is split into three clean layers:

**`SessionManager`** (shared) owns all timer and loop logic. It exposes `@Published` properties that drive both UIs, and two callbacks (`onIntervalEnd`, `onLoopEnd`) that are set by each platform's entry point to trigger platform-specific alerts.

**Views** (iOS + watchOS) are purely reactive — they read `@Published` state from `SessionManager` via `@EnvironmentObject` and re-render automatically every second.

**Alert layer** is platform-specific. iOS uses `AudioToolbox` + `UINotificationFeedbackGenerator`. watchOS uses `WKInterfaceDevice.play()`. Neither leaks into shared code.

---

## License

MIT
