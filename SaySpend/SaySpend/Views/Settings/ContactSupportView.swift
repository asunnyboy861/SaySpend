import SwiftUI

struct ContactSupportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var feedbackService = FeedbackService()
    @State private var topic = "General"
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    
    private let topics = ["General", "Bug Report", "Feature Request", "Subscription", "Data Export", "Other"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Topic") {
                    Picker("Topic", selection: $topic) {
                        ForEach(topics, id: \.self) { Text($0) }
                    }
                }
                
                Section("Your Info") {
                    TextField("Name (optional)", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                }
                
                Section("Message") {
                    TextEditor(text: $message)
                        .frame(minHeight: 100)
                }
                
                Section {
                    Button(action: submitFeedback) {
                        if feedbackService.isSubmitting {
                            ProgressView()
                                .controlSize(.regular)
                        } else {
                            Text("Submit")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(email.isEmpty || message.isEmpty || feedbackService.isSubmitting)
                }
            }
            .navigationTitle("Contact Support")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
            .alert("Thank You!", isPresented: .constant(feedbackService.submitted)) {
                Button("OK") { dismiss() }
            } message: {
                Text("Your message has been sent. We'll get back to you soon.")
            }
            .alert("Error", isPresented: .constant(feedbackService.errorMessage != nil)) {
                Button("OK") { feedbackService.errorMessage = nil }
            } message: {
                Text(feedbackService.errorMessage ?? "")
            }
        }
    }
    
    private func submitFeedback() {
        Task {
            await feedbackService.submit(
                topic: topic,
                name: name.isEmpty ? nil : name,
                email: email,
                message: message
            )
        }
    }
}
