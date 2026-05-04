import SwiftUI
import SwiftData
import PhotosUI

struct ReceiptScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var scanner = ReceiptScanner()
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showCamera = false
    @State private var cameraImage: UIImage?
    @State private var confirmAmount = ""
    @State private var confirmCategory = "Other"
    @State private var confirmMerchant = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                if scanner.isProcessing {
                    ProgressView("Scanning receipt...")
                        .padding(40)
                } else if scanner.scannedExpense != nil {
                    scannedResultView
                } else {
                    pickImageView
                }
            }
            .padding()
            .navigationTitle("Scan Receipt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onChange(of: selectedPhoto) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        scanner.scan(image: image)
                    }
                }
            }
            .onChange(of: cameraImage) { _, newImage in
                if let image = newImage {
                    scanner.scan(image: image)
                }
            }
        }
    }
    
    private var pickImageView: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text.viewfinder")
                .font(.system(size: 64))
                .foregroundColor(.appPrimary)
            
            Text("Scan a receipt to auto-fill expense details")
                .font(.subheadline)
                .foregroundColor(.appTextSecondary)
                .multilineTextAlignment(.center)
            
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                Label("Choose Photo", systemImage: "photo.on.rectangle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            Button(action: { showCamera = true }) {
                Label("Take Photo", systemImage: "camera")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
        .padding(32)
        .sheet(isPresented: $showCamera) {
            CameraView(image: $cameraImage)
        }
    }
    
    private var scannedResultView: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 48))
                .foregroundColor(.appGreen)
            
            Text("Receipt Scanned")
                .font(.headline)
            
            ExpenseConfirmationCard(
                amount: $confirmAmount,
                category: $confirmCategory,
                merchant: $confirmMerchant
            )
            
            Button("Save Expense") {
                saveExpense()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .onAppear {
            if let expense = scanner.scannedExpense {
                confirmAmount = (expense.amount ?? 0).description
                confirmCategory = expense.category ?? "Other"
                confirmMerchant = expense.merchant ?? ""
            }
        }
    }
    
    private func saveExpense() {
        guard let amount = Decimal(string: confirmAmount), amount > 0 else { return }
        let expense = Expense(
            amount: amount,
            category: confirmCategory,
            merchant: confirmMerchant,
            note: "Scanned receipt",
            date: Date(),
            inputMethod: "receipt"
        )
        modelContext.insert(expense)
        dismiss()
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        init(_ parent: CameraView) { self.parent = parent }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            parent.image = info[.originalImage] as? UIImage
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
