# Local Run Guide

## Device Compatibility

| Device | Model | OS | Target |
|---|---|---|---|
| iPhone 16 Pro | — | iOS 18 | iOS 17.0+ ✓ |
| Apple Watch Series 9 40mm | MU672LL/A | watchOS 10+ | watchOS 10.0+ ✓ |

---

## Running on iPhone Simulator

1. In Xcode toolbar, click the device selector next to the scheme name
2. Choose any **iPhone** simulator (e.g. iPhone 16)
3. Press `⌘R`

---

## Running on Apple Watch Simulator

**Watch only:**
- Click the scheme selector (left of device selector) → choose **RunningIntervalApp Watch App**
- Click the device selector → pick an Apple Watch simulator (e.g. Apple Watch Series 10 - 46mm)
- Press `⌘R`

**iPhone + Watch together (recommended):**
- Set scheme to **RunningIntervalApp** (the iOS app)
- Select any iPhone simulator as the destination
- Xcode automatically launches the paired Watch simulator alongside it
- Press `⌘R`

---

## Running on Physical Devices (iPhone 16 Pro + Apple Watch Series 9)

### Step 1 — Enable Developer Mode on iPhone
- Settings → Privacy & Security → Developer Mode → turn **ON**
- iPhone restarts — tap **Turn On** to confirm

### Step 2 — Enable Developer Mode on Apple Watch
- Watch app on iPhone → Privacy & Security → Developer Mode → turn **ON**
- Watch restarts automatically

### Step 3 — Connect iPhone to Mac
- Plug iPhone into Mac via USB
- If prompted on iPhone: tap **Trust** → enter passcode
- iPhone 16 Pro should appear in the Xcode device selector

### Step 4 — Sign both targets in Xcode
- Click the project (blue icon in sidebar) → select **RunningIntervalApp** target
- Go to **Signing & Capabilities** tab
- Check **Automatically manage signing**
- Set **Team** to your Apple ID (add via *Add an Account...* if needed)
- Repeat for **RunningIntervalApp Watch App** target

### Step 5 — Select destination
- In Xcode toolbar, set scheme to **RunningIntervalApp**
- Click the device selector → choose your **iPhone 16 Pro** (not a simulator)

### Step 6 — Build & Run
- Press `⌘R`
- Xcode installs the iPhone app first, then automatically pushes the Watch app to the paired Series 9 over Bluetooth

### Step 7 — Open on Watch
- Press the Digital Crown on the watch
- Find **RunningIntervalApp** in the app grid → tap to open

---

## Troubleshooting

**Xcode can't find the Apple Watch:**
- Make sure the watch is paired to the same iPhone (Watch app → My Watch tab)
- Both devices must be signed into the same Apple ID
- Watch must be unlocked and awake during install

**"Trust this computer" not appearing:**
- Unplug and replug the USB cable
- On iPhone: Settings → General → Transfer or Reset iPhone → Reset → Reset Location & Privacy

**xcodebuild tool error on first run:**
- Run in terminal: `! sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`
- Enter your Mac password when prompted
