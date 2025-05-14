import RealmSwift

enum RealmMigrationManager {
    static let currentSchemaVersion: UInt64 = 9

    static var configuration: Realm.Configuration {
        Realm.Configuration(
            schemaVersion: currentSchemaVersion,
            migrationBlock: { migration, oldVersion in
                if oldVersion < 9 {
                    Migration_v9.perform(migration)
                }
            },
            deleteRealmIfMigrationNeeded: false
        )
    }
}
