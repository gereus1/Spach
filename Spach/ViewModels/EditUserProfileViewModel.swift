import Foundation
import RealmSwift

class EditUserProfileViewModel: ObservableObject {
    private var user: User

    @Published var name: String
    @Published var surname: String
    @Published var email: String
    @Published var age: Int
    @Published var expectedTrainerExperience: Int
    @Published var worksWithChildren: Bool
    @Published var hasCertificates: Bool
    @Published var languagesText: String
    @Published var districtsText: String
    @Published var categoriesText: String
    @Published var avatarData: Data?

    private let service = RealmService()

    init(user: User) {
        self.user = user
        self.name = user.name
        self.surname = user.surname
        self.email = user.email
        self.age = user.age
        self.expectedTrainerExperience = user.expectedTrainerExperience
        self.worksWithChildren = user.worksWithChildren
        self.hasCertificates = user.hasCertificates
        self.languagesText = user.languages.joined(separator: ", ")
        self.districtsText = user.districts.map { $0.rawValue }.joined(separator: ", ")
        self.categoriesText = user.expectedCategories.map { $0.rawValue }.joined(separator: ", ")
        self.avatarData = user.avatarData
    }

    func saveChanges() {
        let realm = try! Realm()
        try! realm.write {
            user.name = name
            user.surname = surname
            user.email = email
            user.age = age
            user.expectedTrainerExperience = expectedTrainerExperience
            user.worksWithChildren = worksWithChildren
            user.hasCertificates = hasCertificates
            user.avatarData = avatarData

            user.languages.removeAll()
            let parsedLanguages = languagesText
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
            user.languages.append(objectsIn: parsedLanguages)

            user.districts.removeAll()
            let parsedDistricts = districtsText
                .split(separator: ",")
                .compactMap { District(rawValue: $0.trimmingCharacters(in: .whitespaces)) }
            user.districts.append(objectsIn: parsedDistricts)

            user.expectedCategories.removeAll()
            let parsedCategories = categoriesText
                .split(separator: ",")
                .compactMap { SportCategory(rawValue: $0.trimmingCharacters(in: .whitespaces)) }
            user.expectedCategories.append(objectsIn: parsedCategories)

            
            realm.add(user, update: .modified)
        }
    }
}
