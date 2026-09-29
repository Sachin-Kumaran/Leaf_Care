import SwiftUI

/// Adds the top-right user icon with Login / FAQ / Settings options to any screen.
struct UserMenuToolbar: ViewModifier {
    @State private var showingLogin = false
    @State private var showingFAQ = false
    @State private var showingSettings = false

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Login", systemImage: "person.badge.key.fill") { showingLogin = true }
                        Button("FAQ", systemImage: "questionmark.circle") { showingFAQ = true }
                        Button("Settings", systemImage: "gearshape") { showingSettings = true }
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .foregroundColor(.white)
                    }
                }
            }
            .sheet(isPresented: $showingLogin) { LoginView() }
            .sheet(isPresented: $showingFAQ) { NavigationStack { FAQView() } }
            .sheet(isPresented: $showingSettings) { SettingsView() }
    }
}

extension View {
    /// Attaches the standard top-right user menu (Login / FAQ / Settings).
    func userMenu() -> some View {
        modifier(UserMenuToolbar())
    }
}
