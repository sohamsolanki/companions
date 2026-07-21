import SwiftUI

@main
struct CompanionsApp: App {
    init() {
        Self.resetStateIfRequestedByUITests()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    /// Clears persisted onboarding state when launched with `-UITestResetState`.
    ///
    /// UI tests need a known starting point, and launch arguments alone can't provide one:
    /// `UserDefaults` reads its argument domain ahead of the standard domain, so a value
    /// passed that way would also block the app from writing over it during the test.
    private static func resetStateIfRequestedByUITests() {
        guard ProcessInfo.processInfo.arguments.contains("-UITestResetState") else { return }
        for key in ["userName", "hasOnboarded"] {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}
