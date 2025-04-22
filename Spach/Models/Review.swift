import RealmSwift

class Review: Object, Identifiable {
  @Persisted(primaryKey: true) var id: ObjectId
  @Persisted var userId: ObjectId
  @Persisted var trainerId: ObjectId
  @Persisted var score: Double
  @Persisted var comment: String?
}
