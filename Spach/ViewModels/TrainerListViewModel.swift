import Foundation
import Combine
import RealmSwift

class TrainerListViewModel: ObservableObject {
    @Published var searchText = "" {
        didSet { filter() }
    }
    @Published private(set) var trainers: [Trainer] = []

    private var allTrainers: [Trainer] = []
    private let service = RealmService()

    init() {
        loadAll()
    }

    private func loadAll() {
        let results = service.fetchTrainers()
        allTrainers = Array(results)
        trainers = allTrainers
    }

    private func filter() {
        let text = searchText.lowercased().trimmingCharacters(in: .whitespaces)
        if text.isEmpty {
            trainers = allTrainers
        } else {
            trainers = allTrainers.filter {
                $0.email.lowercased().contains(text)
                || $0.languages.joined(separator: " ").lowercased().contains(text)
            }
        }
    }
    
    func recommended(for user: User) -> [Trainer] {
      let trainers = Array(RealmService().fetchTrainers())
      // збираєш вектор уподобань з полів user:
      let userVec: [Double] = [
        user.pricePerSession,
        user.rating,
        Double(user.expectedTrainerExperience),
        Double(user.travelTime)
      ]
      return trainers
        .map { ($0, cosine($0.featureVector(), userVec)) }
        .sorted { $0.1 > $1.1 }
        .map(\.0)
    }

}
