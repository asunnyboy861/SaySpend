import SwiftUI
import SwiftData

struct VoiceInputView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var voiceManager = VoiceInputManager()
    @State private var parsedExpense: ParsedExpense?
    @State private var confirmAmount: String = ""
    @State private var confirmCategory: String = "Other"
    @State private var confirmMerchant: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Text("Just say it")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.appTextPrimary)
                
                Text(voiceManager.isListening ? "Listening..." : "Tap to speak")
                    .font(.subheadline)
                    .foregroundColor(.appTextSecondary)
                
                Button {
                    if voiceManager.isListening {
                        voiceManager.stopListening()
                    } else {
                        Task {
                            let speechAuth = await voiceManager.requestAuthorization()
                            let micAuth = await voiceManager.requestMicrophonePermission()
                            if speechAuth && micAuth {
                                voiceManager.startListening()
                            }
                        }
                    }
                } label: {
                    ZStack {
                        if voiceManager.isListening {
                            Circle()
                                .fill(Color.appRed.opacity(0.15))
                                .frame(width: 140, height: 140)
                                .scaleEffect(voiceManager.isListening ? 1.1 : 1.0)
                                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: voiceManager.isListening)
                        }
                        Circle()
                            .fill(voiceManager.isListening ? Color.appRed.opacity(0.15) : Color.appPrimary.opacity(0.1))
                            .frame(width: 120, height: 120)
                        Circle()
                            .fill(voiceManager.isListening ? Color.appRed : Color.appPrimary)
                            .frame(width: 80, height: 80)
                        Image(systemName: voiceManager.isListening ? "waveform" : "mic.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(.white)
                    }
                }
                .sensoryFeedback(.impact(weight: .heavy), trigger: voiceManager.isListening)
                
                if !voiceManager.transcribedText.isEmpty {
                    Text("\"\(voiceManager.transcribedText)\"")
                        .font(.body)
                        .foregroundColor(.appTextSecondary)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                }
                
                if let expense = parsedExpense {
                    ExpenseConfirmationCard(
                        amount: $confirmAmount,
                        category: $confirmCategory,
                        merchant: $confirmMerchant
                    )
                    .transition(.scale.combined(with: .opacity))
                    
                    Button("Save Expense") {
                        saveExpense()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Voice Input")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onChange(of: voiceManager.isListening) { _, isListening in
                if !isListening && !voiceManager.transcribedText.isEmpty {
                    let parser = ExpenseParser()
                    let result = parser.parse(voiceManager.transcribedText)
                    parsedExpense = result
                    confirmAmount = (result.amount ?? 0).description
                    confirmCategory = result.category ?? "Other"
                    confirmMerchant = result.merchant ?? ""
                }
            }
        }
    }
    
    private func saveExpense() {
        guard let amount = Decimal(string: confirmAmount), amount > 0 else { return }
        let expense = Expense(
            amount: amount,
            category: confirmCategory,
            merchant: confirmMerchant,
            note: voiceManager.transcribedText,
            date: Date(),
            inputMethod: "voice"
        )
        modelContext.insert(expense)
        dismiss()
    }
}
