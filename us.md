# SaySpend - iOS Development Guide

## Executive Summary

SaySpend is a voice-first expense tracker designed for the US market, targeting 18-30 year olds who find existing finance apps too complex. The core differentiator is voice input: users simply say "5 bucks on coffee" and the app logs, categorizes, and tracks the expense in under 3 seconds. Combined with receipt OCR scanning and traditional manual entry, SaySpend offers three input modes in one minimalist interface. Privacy-first: all data stored locally with optional iCloud sync. No ads, no bank connections, no subscriptions required for core features.

**Product Vision**: "Just Say It. We Track It." — Eliminate the 45-second friction of manual expense logging that causes 80% of users to abandon tracking apps within 2 weeks.

**Key Differentiators**:
- Voice input as primary input method (not a premium add-on)
- 3-second expense logging vs industry average of 45 seconds
- Privacy-first: local storage, no bank connections, no data collection
- Zero ads, zero tracking, zero complexity
- Free core features with optional premium upgrade

**Target Audience**: US young adults (18-30), privacy-conscious minimalists, subscription-fatigued users

## Competitive Analysis

| App | Strengths | Weaknesses | Our Advantage |
|-----|-----------|------------|---------------|
| YNAB | Powerful budgeting, bank sync | $99/year, steep learning curve, complex | Free core, 3-sec voice input, zero learning curve |
| Copilot | Apple Design Award, auto-categorize | Subscription only, US banks only, no voice | Voice-first, no bank required, privacy-first |
| XpendAI | AI receipt + voice, privacy-first | Voice is premium ($39), limited free tier | Voice is free core feature, simpler UX |
| Expenses (Blue Comet) | iCloud sync, Apple platforms, clean UI | No voice input, no receipt scan | Voice + receipt + manual three-in-one |
| Talkie Spendy | Voice-powered tracking | New app, limited features, unknown quality | More mature feature set, better NLP parsing |

## Apple Design Guidelines Compliance

- **HIG Finance Apps**: No investment advice, clear disclaimers, no misleading financial claims
- **Privacy**: All data local by default, no personal data collection, no third-party sharing
- **Speech Recognition**: Must request user permission with clear explanation; support on-device recognition
- **Camera/Photo**: Must request permission for receipt scanning; explain usage clearly
- **Haptic Feedback**: Use CoreHaptics for voice recording feedback, button presses
- **Accessibility**: VoiceOver support, Dynamic Type, sufficient color contrast
- **Dark Mode**: Full support required for finance apps
- **Widgets**: Provide today's spending summary widget
- **App Intents**: Siri shortcuts for quick expense logging

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary)
- **Data**: SwiftData with @Model macro
- **Cloud Sync**: NSPersistentCloudKitContainer (optional, user-controlled)
- **Speech**: SFSpeechRecognizer (on-device preferred)
- **NLP**: Natural Language framework (NLTagger)
- **OCR**: Vision Framework (VNRecognizeTextRequest)
- **Charts**: Swift Charts (iOS 16+)
- **Widgets**: WidgetKit
- **Siri**: AppIntents framework
- **Haptics**: CoreHaptics
- **Build**: Xcode 16+, iOS 17.0+

## Module Structure

```
SaySpend/
├── SaySpendApp.swift
├── Views/
│   ├── Main/
│   │   └── MainTabView.swift
│   ├── Home/
│   │   ├── HomeView.swift
│   │   └── HomeViewModel.swift
│   ├── VoiceInput/
│   │   ├── VoiceInputView.swift
│   │   ├── VoiceInputButton.swift
│   │   └── ExpenseConfirmationCard.swift
│   ├── Expenses/
│   │   ├── ExpenseListView.swift
│   │   ├── ExpenseRowView.swift
│   │   ├── AddExpenseView.swift
│   │   └── ExpenseDetailViewModel.swift
│   ├── Statistics/
│   │   ├── StatisticsView.swift
│   │   └── StatisticsViewModel.swift
│   ├── Budget/
│   │   ├── BudgetView.swift
│   │   └── BudgetViewModel.swift
│   ├── Settings/
│   │   ├── SettingsView.swift
│   │   ├── ContactSupportView.swift
│   │   └── PaywallView.swift
│   └── Components/
│       ├── CategoryIcon.swift
│       ├── AmountTextField.swift
│       └── EmptyStateView.swift
├── Models/
│   ├── Expense.swift
│   ├── Category.swift
│   └── Budget.swift
├── Services/
│   ├── VoiceInputManager.swift
│   ├── ExpenseParser.swift
│   ├── ReceiptScanner.swift
│   ├── DataManager.swift
│   ├── PurchaseManager.swift
│   └── FeedbackService.swift
├── Extensions/
│   ├── Color+Theme.swift
│   ├── Date+Extensions.swift
│   └── Decimal+Extensions.swift
└── Resources/
    └── Assets.xcassets/
```

## Implementation Flow

1. Create SwiftData models (Expense, Category, Budget)
2. Build DataManager with SwiftData + optional CloudKit
3. Implement VoiceInputManager with SFSpeechRecognizer
4. Implement ExpenseParser with NLP for amount/category/merchant extraction
5. Implement ReceiptScanner with Vision Framework OCR
6. Build MainTabView with 4 tabs (Home, Expenses, Statistics, Settings)
7. Build HomeView with voice input button + today's summary
8. Build ExpenseListView with search, filter, grouping by date
9. Build AddExpenseView with manual entry form
10. Build StatisticsView with Swift Charts (trend + category breakdown)
11. Build BudgetView with progress bars and overspend alerts
12. Build SettingsView with iCloud toggle, export, support, privacy links
13. Implement PurchaseManager with StoreKit 2
14. Build PaywallView for premium features
15. Build ContactSupportView with feedback backend
16. Add WidgetKit support for today's spending
17. Add AppIntents for Siri shortcuts
18. Polish UI with animations, haptics, and dark mode

## UI/UX Design Specifications

- **Color Scheme**: 
  - Primary: #007AFF (Blue) — trust, finance
  - Accent: #34C759 (Green) — income, positive
  - Danger: #FF3B30 (Red) — overspend, expense
  - Background: #F2F2F7 (Light) / #000000 (Dark)
  - Card: #FFFFFF (Light) / #1C1C1E (Dark)
  
- **Typography**: 
  - SF Pro Rounded for headings (friendly, approachable)
  - SF Pro for body text (readable, professional)
  - Large title: 34pt bold
  - Amount display: 28pt monospaced
  
- **Layout**: 
  - Bottom tab bar with 4 tabs
  - Floating voice input button (FAB) on Home screen
  - Card-based expense list with date grouping
  - Max content width 720pt for iPad
  - 16pt horizontal padding, 12pt vertical spacing
  
- **Animations**: 
  - Voice button: pulsing ring animation while listening
  - Expense card: slide-in from bottom on add
  - Category icons: spring animation on selection
  - Tab transitions: fade + slide
  - Haptic feedback on voice start/stop, expense save
  
- **Voice Input UX**:
  - Large centered microphone button (80pt circle)
  - Pulsing red ring while listening
  - Real-time transcription display
  - Confirmation card with parsed amount/category/merchant
  - One-tap confirm or edit before save

## Code Generation Rules

- Use SwiftData @Model for all data models
- All model attributes must be optional or have default values
- Use MVVM pattern with @Observable ViewModels
- Use @Environment for dependency injection
- No third-party dependencies — Apple native only
- No code comments unless explicitly requested
- Support both iPhone and iPad layouts
- All strings in English (US market)
- Use sensoryFeedback for haptics
- Use #Preview macros for SwiftUI previews

## Build & Deployment Checklist

- [ ] Bundle ID: com.zzoutuo.SaySpend
- [ ] Deployment Target: iOS 17.0
- [ ] App Icon configured (1024x1024)
- [ ] Capabilities: Speech Recognition, Camera, Photo Library, iCloud (optional)
- [ ] Info.plist: Microphone usage description, Speech recognition description, Camera usage description
- [ ] Privacy Policy page deployed
- [ ] Support page deployed
- [ ] App Store metadata prepared
- [ ] Test on iPhone XS Max simulator
- [ ] Test on iPad Pro 13-inch (M4) simulator
- [ ] Push to GitHub repository
