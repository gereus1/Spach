import Foundation
import RealmSwift

final class RealmService {
    private let realm = try! Realm()

    func fetchTrainers() -> Results<Trainer> {
        realm.objects(Trainer.self)
    }
    
    func fetchTrainer(byEmail email: String) -> Trainer? {
        return realm.objects(Trainer.self).filter("email == %@", email).first
    }
    
    func fetchUser(byEmail email: String) -> User? {
        return realm.objects(User.self).filter("email == %@", email).first
    }
    
    func fetchUser(byId idString: String) -> User? {
        guard let objectId = try? ObjectId(string: idString) else { return nil }
        return realm.object(ofType: User.self, forPrimaryKey: objectId)
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
    
    func fetchRatings(for trainerId: ObjectId) -> Results<TrainerRating> {
        realm.objects(TrainerRating.self).where { $0.trainerId == trainerId }
    }
    
    func fetchUserRating(for trainerId: ObjectId, userId: ObjectId) -> TrainerRating? {
        realm.objects(TrainerRating.self)
            .filter("trainerId == %@ AND userId == %@", trainerId, userId)
            .first
    }

    func add<T: Object>(_ object: T) {
        try! realm.write { realm.add(object) }
    }
    
    func updateTrainer(_ trainer: Trainer,
                           block: (Trainer) -> Void) {
            let realm = try! Realm()
            try! realm.write {
                block(trainer)
            }
        }

        func updateUser(_ user: User,
                        block: (User) -> Void) {
            let realm = try! Realm()
            try! realm.write {
                block(user)
            }
        }
    
    func submitRating(for trainerId: ObjectId, from userId: ObjectId, value: Int) {
        if realm.objects(TrainerRating.self)
            .filter("trainerId == %@ AND userId == %@", trainerId, userId)
            .first != nil {
                return
            }

        guard let trainer = realm.object(ofType: Trainer.self, forPrimaryKey: trainerId) else { return }

        let rating = TrainerRating()
        rating.trainerId = trainerId
        rating.userId = userId
        rating.rating = value

        try? realm.write {
            realm.add(rating)

            // Оновити рейтинг тренера
            let ratings = realm.objects(TrainerRating.self).where { $0.trainerId == trainerId }
            let average = Double(ratings.map(\.rating).reduce(0, +)) / Double(ratings.count)
            trainer.rating = average
        }
    }
    
    func upsertRating(for trainerId: ObjectId, from userId: ObjectId, value: Int) {
        guard let trainer = realm.object(ofType: Trainer.self, forPrimaryKey: trainerId) else { return }

        if let existing = realm.objects(TrainerRating.self)
            .filter("trainerId == %@ AND userId == %@", trainerId, userId)
            .first {
            try? realm.write {
                existing.rating = value
                existing.createdAt = Date()
            }
        } else {
            let newRating = TrainerRating()
            newRating.trainerId = trainerId
            newRating.userId = userId
            newRating.rating = value
            try? realm.write {
                realm.add(newRating)
            }
        }

        // Після оновлення — перерахунок середнього рейтингу
        let ratings = realm.objects(TrainerRating.self).where { $0.trainerId == trainerId }
        let average = Double(ratings.map(\.rating).reduce(0, +)) / Double(ratings.count)
        try? realm.write {
            trainer.rating = average
        }
    }

    
    func hasUserRated(trainerId: ObjectId, userId: ObjectId) -> Bool {
        return realm.objects(TrainerRating.self)
            .filter("trainerId == %@ AND userId == %@", trainerId, userId)
            .first != nil
    }
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

