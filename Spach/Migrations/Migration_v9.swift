import RealmSwift

enum Migration_v9 {
    static func perform(_ migration: Migration) {
        // rating → expectedRating
        migration.enumerateObjects(ofType: User.className()) { oldObject, newObject in
            // Копіюємо старий рейтинг в нове поле, якщо потрібно
            if let oldRating = oldObject?["rating"] as? Double {
                newObject?["expectedRating"] = oldRating
            }
        }
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
        
        migration.enumerateObjects(ofType: User.className()) { _, newObject in
            guard let list = newObject?["expectedCategories"] as? RealmSwift.List<String> else { return }
            list.append(SportCategory.bodybuilding.rawValue)
        }

        // — Міграція для districts (Trainer)
        migration.enumerateObjects(ofType: Trainer.className()) { _, newObject in
            guard let list = newObject?["categories"] as? RealmSwift.List<String> else { return }
            list.append(SportCategory.bodybuilding.rawValue)
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
    }
}
