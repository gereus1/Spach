import SwiftUI
import RealmSwift

@main
struct SpachApp: SwiftUI.App {
    @AppStorage("isLoggedIn")    private var isLoggedIn    = false
    @AppStorage("userRole")      private var userRole      = ""
    @AppStorage("currentEmail")  private var currentEmail  = ""

    init() {
        Realm.Configuration.defaultConfiguration =
            Realm.Configuration(schemaVersion: 1)
        let config = Realm.Configuration(
          schemaVersion: 2,                              // інкремент — довільне більше число
          deleteRealmIfMigrationNeeded: true             // видалить старі дані і створить нову БД
        )
        Realm.Configuration.defaultConfiguration = config
    }

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                if userRole == "trainer" {
                    TrainerHomeView()
                } else {
                    UserHomeView()
                }
            } else {
                AuthRootView()
            }
        }
    }
}
