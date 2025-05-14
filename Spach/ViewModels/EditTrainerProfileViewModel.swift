import Foundation
import RealmSwift

class EditTrainerProfileViewModel: ObservableObject {
    private var trainer: Trainer

    @Published var name: String
    @Published var surname: String
    @Published var email: String
    @Published var age: Int
    @Published var experience: Int
    @Published var pricePerSession: Double
    @Published var yearsInCategory: Int
    @Published var worksWithChildren: Bool
    @Published var hasCertificates: Bool
    @Published var languagesText: String
    @Published var districtsText: String
    @Published var categoriesText: String
    @Published var avatarData: Data?

    init(trainer: Trainer) {
        self.trainer = trainer
        self.name = trainer.name
        self.surname = trainer.surname
        self.email = trainer.email
        self.age = trainer.age
        self.experience = trainer.experience
        self.pricePerSession = trainer.pricePerSession
        self.yearsInCategory = trainer.yearsInCategory
        self.worksWithChildren = trainer.worksWithChildren
        self.hasCertificates = trainer.hasCertificates
        self.languagesText = trainer.languages.joined(separator: ", ")
        self.districtsText = trainer.districts.map { $0.rawValue }.joined(separator: ", ")
        self.categoriesText = trainer.categories.map { $0.rawValue }.joined(separator: ", ")
        self.avatarData = trainer.avatarData
    }

    func saveChanges() {
        let realm = try! Realm()
        try! realm.write {
            trainer.name = name
            trainer.surname = surname
            trainer.email = email
            trainer.age = age
            trainer.experience = experience
            trainer.pricePerSession = pricePerSession
            trainer.yearsInCategory = yearsInCategory
            trainer.worksWithChildren = worksWithChildren
            trainer.hasCertificates = hasCertificates
            trainer.avatarData = avatarData

            trainer.languages.removeAll()
            trainer.languages.append(objectsIn: languagesText
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) })

            trainer.districts.removeAll()
            trainer.districts.append(objectsIn: districtsText
                .split(separator: ",")
                .compactMap { District(rawValue: $0.trimmingCharacters(in: .whitespaces)) })
            
            trainer.categories.removeAll()
            trainer.categories.append(objectsIn: categoriesText
                .split(separator: ",")
                .compactMap { SportCategory(rawValue: $0.trimmingCharacters(in: .whitespaces)) })


            realm.add(trainer, update: .modified)
        }
    }
}
