import UIKit
import AudioToolbox

enum iOSAlertManager {
    static func playIntervalEnd() {
        AudioServicesPlayAlertSound(SystemSoundID(1052))
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }

    static func playLoopEnd() {
        AudioServicesPlayAlertSound(SystemSoundID(1052))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            AudioServicesPlayAlertSound(SystemSoundID(1052))
        }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
