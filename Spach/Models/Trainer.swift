import RealmSwift
import Foundation

class Trainer: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var email: String = ""
    @Persisted var passwordHash: String = ""
    @Persisted var name: String = ""
    @Persisted var surname: String = ""
    @Persisted var avatarURL: String? = nil
    @Persisted var avatarData: Data?
    @Persisted var age: Int = 0
    @Persisted var experience: Int = 0
    @Persisted var districts: List<District>
    @Persisted var languages: List<String>
    @Persisted var worksWithChildren: Bool = false
    @Persisted var hasCertificates: Bool = false
    @Persisted var rating: Double = 0.0
    @Persisted var pricePerSession: Double = 0.0
    @Persisted var categories: List<SportCategory>
    @Persisted var yearsInCategory: Int = 0
}
