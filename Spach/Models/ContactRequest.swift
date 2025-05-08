import RealmSwift

class ContactRequest: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var userId: String
    @Persisted var trainerId: String
    @Persisted var userRequested: Bool       // користувач натиснув "Звʼязатися"
    @Persisted var trainerConfirmed: Bool    // тренер натиснув "Звʼязатися" у відповідь
    @Persisted var rejected: Bool // за замовчуванням false
}
