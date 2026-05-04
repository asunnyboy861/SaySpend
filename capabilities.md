# Capabilities Configuration

## Analysis
Based on operation guide analysis:
- Voice input (SFSpeechRecognizer) → Speech Recognition capability
- Receipt scanning (Vision OCR) → Camera + Photo Library access
- iCloud sync (optional) → iCloud capability
- Siri shortcuts → Siri capability
- Widget support → No special capability needed

## Auto-Configured Capabilities
| Capability | Status | Method |
|------------|--------|--------|
| Speech Recognition | ✅ Configured | Info.plist key |
| Microphone Access | ✅ Configured | Info.plist key |
| Camera Access | ✅ Configured | Info.plist key |
| Photo Library Access | ✅ Configured | Info.plist key |

## Manual Configuration Required
| Capability | Status | Steps |
|------------|--------|-------|
| iCloud / CloudKit | ⏳ Pending | Enable in Xcode Signing & Capabilities, add CloudKit container |
| Siri / AppIntents | ⏳ Pending | Enable in Xcode Signing & Capabilities |

## No Configuration Needed
- WidgetKit (no special capability required)
- Vision Framework (no permission needed, camera access covers it)
- Natural Language framework (no permission needed)
- SwiftData (no permission needed)
- CoreHaptics (no permission needed)

## Info.plist Keys Required
- NSSpeechRecognitionUsageDescription: "SaySpend needs speech recognition to log your expenses by voice."
- NSMicrophoneUsageDescription: "SaySpend needs microphone access to hear your voice for expense logging."
- NSCameraUsageDescription: "SaySpend needs camera access to scan receipts for expense tracking."
- NSPhotoLibraryUsageDescription: "SaySpend needs photo library access to import receipts for expense tracking."

## Verification
- Build succeeded after configuration: ✅
- All entitlements correct: ✅
