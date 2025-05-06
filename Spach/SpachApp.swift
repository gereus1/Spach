import SwiftUI
import RealmSwift

@main
struct SpachApp: SwiftUI.App {
    @AppStorage("isLoggedIn")          private var isLoggedIn        = false
    @AppStorage("userRole")            private var userRole          = ""
    @AppStorage("currentEmail")        private var currentEmail      = ""
    @AppStorage("hasSeenOnboarding")   private var hasSeenOnboarding = false

    init() {
        // 1) Піднімаємо версію схеми — тепер 4
        let config = Realm.Configuration(
            schemaVersion: 4,
            migrationBlock: { migration, oldVersion in
                guard oldVersion < 4 else { return }

                // — Міграція для districts
                migration.enumerateObjects(ofType: User.className()) { _, newObject in
                    guard let list = newObject?["districts"] as? RealmSwift.List<String> else { return }
                    list.append(District.shevchenkivskyi.rawValue)
                }
                // Для Trainer: додаємо дефолтний район
                migration.enumerateObjects(ofType: Trainer.className()) { _, newObject in
                    guard let list = newObject?["districts"] as? RealmSwift.List<String> else { return }
                    list.append(District.shevchenkivskyi.rawValue)
                }

                // — Міграція для avatarData: явно встановлюємо nil для старих записів
                migration.enumerateObjects(ofType: User.className()) { _, newObject in
                    newObject?["avatarData"] = nil
                }
                migration.enumerateObjects(ofType: Trainer.className()) { _, newObject in
                    newObject?["avatarData"] = nil
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

        //UserDefaults.standard.set(false, forKey: "hasSeenOnboarding")
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
