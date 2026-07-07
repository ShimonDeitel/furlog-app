import SwiftUI

@main
struct FurlogApp: App {
    @StateObject private var store = FurlogStore()
    @StateObject private var purchases = PurchaseManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(purchases)
                .tint(Theme.accent)
        }
    }
}
