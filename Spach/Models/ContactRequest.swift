import RealmSwift

class ContactRequest: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var userId: String
    @Persisted var trainerId: String
    @Persisted var userRequested: Bool
    @Persisted var trainerConfirmed: Bool
    @Persisted var rejected: Bool
}
