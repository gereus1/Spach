import Foundation
import RealmSwift

final class RealmService {
    private let realm = try! Realm()

    func fetchTrainers() -> Results<Trainer> {
        realm.objects(Trainer.self)
    }

    func fetchUsers() -> Results<User> {
        realm.objects(User.self)
    }

    func fetchCurrentTrainer(email: String) -> Trainer? {
        realm.objects(Trainer.self)
             .first(where: { $0.email == email })
    }

    func fetchCurrentUser(email: String) -> User? {
        realm.objects(User.self)
             .first(where: { $0.email == email })
    }

    func add<T: Object>(_ object: T) {
        try! realm.write { realm.add(object) }
    }
    
    func addReview(user: User, trainer: Trainer, score: Double) {
      let realm = try! Realm()
      let r = Review()
      r.userId = user.id
      r.trainerId = trainer.id
      r.score     = score

      try! realm.write {
        realm.add(r)
        // Обчислюємо новий середній рейтинг
        let all = realm.objects(Review.self)
                       .filter("trainerId == %@", trainer.id)
                       .map(\.score)
        trainer.rating = all.reduce(0, +) / Double(all.count)
      }
    }

}
