import SwiftUI
import RealmSwift

@main
struct SpachApp: SwiftUI.App {
    @AppStorage("isLoggedIn")          private var isLoggedIn        = false
    @AppStorage("userRole")            private var userRole          = ""
    @AppStorage("currentEmail")        private var currentEmail      = ""
    @AppStorage("hasSeenOnboarding")   private var hasSeenOnboarding = false

    init() {
        var config = RealmMigrationManager.configuration

        // Зберігаємо файл у Application Support
        if let supportURL = FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .first {
            try? FileManager.default.createDirectory(at: supportURL, withIntermediateDirectories: true)
            config.fileURL = supportURL.appendingPathComponent("default.realm")
        }

        Realm.Configuration.defaultConfiguration = config
    }

    var body: some Scene {
        WindowGroup {
            if !hasSeenOnboarding {
                OnboardingView()
            } else if isLoggedIn {
                userRole == "trainer" ? AnyView(TrainerHomeView()) : AnyView(MainTabView())
            } else {
                AuthRootView()
            }
        }
    }
}
