import Foundation

@Observable
final class FeedbackService {
    var isSubmitting: Bool = false
    var submitted: Bool = false
    var errorMessage: String?
    
    private let backendURL: String
    
    init(backendURL: String = "https://feedback-board.iocompile67692.workers.dev") {
        self.backendURL = backendURL
    }
    
    func submit(topic: String?, name: String?, email: String, message: String) async {
        isSubmitting = true
        errorMessage = nil
        submitted = false
        
        let body: [String: Any?] = [
            "topic": topic,
            "name": name,
            "email": email,
            "message": message,
            "app": "SaySpend"
        ]
        
        guard let url = URL(string: backendURL) else {
            errorMessage = "Invalid URL"
            isSubmitting = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body.compactMapValues { $0 })
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                submitted = true
            } else {
                errorMessage = "Failed to submit. Please try again."
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isSubmitting = false
    }
}
