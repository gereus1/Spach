import Foundation
import RealmSwift

class TrainerRating: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var trainerId: ObjectId
    @Persisted var userId: ObjectId
    @Persisted var rating: Int
    @Persisted var createdAt = Date()
}
