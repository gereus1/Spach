import SwiftUI
import RealmSwift

@main
struct SpachApp: SwiftUI.App {
    @AppStorage("isLoggedIn")   private var isLoggedIn   = false
    @AppStorage("userRole")     private var userRole     = ""
    @AppStorage("currentEmail") private var currentEmail = ""
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    init() {
        // Конфігурація Realm з міграцією
        let config: Realm.Configuration = Realm.Configuration(
            schemaVersion: 3,  // Оновлено версію схеми
            migrationBlock: { (migration: Migration, oldSchemaVersion: UInt64) in
                if oldSchemaVersion < 3 {
                    // Для User: додаємо дефолтний район
                    migration.enumerateObjects(ofType: User.className()) { _, newObject in
                        guard let list = newObject?["districts"] as? RealmSwift.List<String> else { return }
                        list.append(District.shevchenkivskyi.rawValue)
                    }
                    // Для Trainer: додаємо дефолтний район
                    migration.enumerateObjects(ofType: Trainer.className()) { _, newObject in
                        guard let list = newObject?["districts"] as? RealmSwift.List<String> else { return }
                        list.append(District.shevchenkivskyi.rawValue)
                    }
                }
            },
            deleteRealmIfMigrationNeeded: false  // Не видаляти БД при міграції
        )

        // Вказуємо збереження файлу в Application Support
        var finalConfig = config
        if let appSupportURL = FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .first
        {
            try? FileManager.default.createDirectory(
                at: appSupportURL,
                withIntermediateDirectories: true
            )
            finalConfig.fileURL = appSupportURL
                .appendingPathComponent("default.realm")
        }

        Realm.Configuration.defaultConfiguration = finalConfig
        
        UserDefaults.standard.set(false, forKey: "hasSeenOnboarding")
        
    }

    var body: some Scene {
        WindowGroup {
        if !hasSeenOnboarding {
                    OnboardingView()
                } else if isLoggedIn {
                    if userRole == "trainer" {
                    TrainerHomeView()
                } else {
                    MainTabView()
                }
            } else {
                AuthRootView()
            }
        }
    }
}
