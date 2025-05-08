import SwiftUI
import RealmSwift

@main
struct SpachApp: SwiftUI.App {
    @AppStorage("isLoggedIn")          private var isLoggedIn        = false
    @AppStorage("userRole")            private var userRole          = ""
    @AppStorage("currentEmail")        private var currentEmail      = ""
    @AppStorage("hasSeenOnboarding")   private var hasSeenOnboarding = false

    init() {
        // 🔼 Піднімаємо версію схеми — тепер 6
        let config = Realm.Configuration(
            schemaVersion: 7,
            migrationBlock: { migration, oldVersion in
                guard oldVersion < 7 else { return }

                // — Міграція для districts (User)
                migration.enumerateObjects(ofType: User.className()) { _, newObject in
                    guard let list = newObject?["districts"] as? RealmSwift.List<String> else { return }
                    list.append(District.shevchenkivskyi.rawValue)
                }

                // — Міграція для districts (Trainer)
                migration.enumerateObjects(ofType: Trainer.className()) { _, newObject in
                    guard let list = newObject?["districts"] as? RealmSwift.List<String> else { return }
                    list.append(District.shevchenkivskyi.rawValue)
                }

                // — Міграція для avatarData
//                migration.enumerateObjects(ofType: User.className()) { _, newObject in
//                    newObject?["avatarData"] = nil
//                }
//                migration.enumerateObjects(ofType: Trainer.className()) { _, newObject in
//                    newObject?["avatarData"] = nil
//                }

                // — Міграція ContactRequest
                migration.enumerateObjects(ofType: "ContactRequest") { _, newObject in
                    // Міграція до нової структури
                    // Старі поля вже недоступні, тому просто встановлюємо дефолти
                    newObject?["userRequested"] = true
                    newObject?["trainerConfirmed"] = false

                    // Нове поле
                    if newObject?["rejected"] == nil {
                        newObject?["rejected"] = false
                    }
                }
            },
            deleteRealmIfMigrationNeeded: false
        )

        // 2) Зберігаємо файл у Application Support
        var finalConfig = config
        if let supportURL = FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .first
        {
            try? FileManager.default.createDirectory(
                at: supportURL,
                withIntermediateDirectories: true
            )
            finalConfig.fileURL = supportURL
                .appendingPathComponent("default.realm")
        }

        // 3) Застосовуємо конфігурацію
        Realm.Configuration.defaultConfiguration = finalConfig
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
