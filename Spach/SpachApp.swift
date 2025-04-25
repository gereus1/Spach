import SwiftUI
import RealmSwift

@main
struct SpachApp: SwiftUI.App {
  @AppStorage("isLoggedIn")   private var isLoggedIn   = false
  @AppStorage("userRole")     private var userRole     = ""
  @AppStorage("currentEmail") private var currentEmail = ""

  init() {
    // 1) Задаємо конфігурацію Realm
    var config = Realm.Configuration(schemaVersion: 2,
                                     deleteRealmIfMigrationNeeded: true)

    // 2) Замість .documents — беремо .applicationSupport
    if let appSupportURL = FileManager.default
        .urls(for: .applicationSupportDirectory, in: .userDomainMask)
        .first
    {
      // створюємо папку, якщо нема
      try? FileManager.default.createDirectory(
        at: appSupportURL,
        withIntermediateDirectories: true
      )
      config.fileURL = appSupportURL
        .appendingPathComponent("default.realm")
    }

    // 3) Встановлюємо як default
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
