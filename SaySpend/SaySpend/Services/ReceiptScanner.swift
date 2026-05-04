import Vision
import SwiftUI

@Observable
final class ReceiptScanner {
    var scannedExpense: ParsedExpense?
    var isProcessing: Bool = false
    
    func scan(image: UIImage) {
        isProcessing = true
        guard let cgImage = image.cgImage else {
            isProcessing = false
            return
        }
        
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let self, error == nil else { return }
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            let text = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
            DispatchQueue.main.async {
                let parser = ExpenseParser()
                self.scannedExpense = parser.parse(text)
                self.isProcessing = false
            }
        }
        
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(cgImage: cgImage)
            try? handler.perform([request])
        }
    }
}
