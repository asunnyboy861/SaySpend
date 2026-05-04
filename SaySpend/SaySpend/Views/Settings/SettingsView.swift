import SwiftUI
import SwiftData

struct SettingsView: View {
    @AppStorage("useCloudKit") private var useCloudKit = false
    @State private var showPaywall = false
    @State private var showContact = false
    @State private var purchaseManager = PurchaseManager.shared
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Premium") {
                    if purchaseManager.isPremium {
                        HStack {
                            Image(systemName: "crown.fill")
                                .foregroundStyle(.yellow)
                            Text("Premium Active")
                                .foregroundColor(.appGreen)
                        }
                    } else {
                        Button(action: { showPaywall = true }) {
                            HStack {
                                Image(systemName: "crown.fill")
                                    .foregroundStyle(.yellow)
                                Text("Upgrade to Premium")
                                    .foregroundColor(.appPrimary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.appTextSecondary)
                            }
                        }
                    }
                }
                
                Section("Sync") {
                    Toggle("iCloud Sync", isOn: $useCloudKit)
                    Text("Sync your expenses across all devices")
                        .font(.caption)
                        .foregroundColor(.appTextSecondary)
                }
                
                Section("Data") {
                    NavigationLink {
                        BudgetView()
                    } label: {
                        Label("Budgets", systemImage: "target")
                    }
                    
                    Button(action: exportData) {
                        Label("Export CSV", systemImage: "square.and.arrow.up")
                    }
                }
                
                Section("Support") {
                    Button(action: { showContact = true }) {
                        Label("Contact Support", systemImage: "envelope")
                    }
                    
                    Link(destination: URL(string: "https://asunnyboy861.github.io/SaySpend/support.html")!) {
                        Label("Support Page", systemImage: "questionmark.circle")
                    }
                    
                    Link(destination: URL(string: "https://asunnyboy861.github.io/SaySpend/privacy.html")!) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }
                    
                    Link(destination: URL(string: "https://asunnyboy861.github.io/SaySpend/terms.html")!) {
                        Label("Terms of Use", systemImage: "doc.text")
                    }
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                            .foregroundColor(.appTextSecondary)
                    }
                }
                
                if !purchaseManager.isPremium {
                    Section {
                        Button("Restore Purchases") {
                            Task {
                                await purchaseManager.restorePurchases()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .sheet(isPresented: $showContact) {
                ContactSupportView()
            }
        }
    }
    
    private func exportData() {
    }
}
