import Foundation
import RealmSwift

class RecommendationViewModel: ObservableObject {
    @Published var recommendations: [Trainer] = []

    private let service = RealmService()
    private var currentUser: User? {
        guard let email = UserDefaults.standard.string(forKey: "currentEmail") else {
            return nil
        }
        return service.fetchCurrentUser(email: email)
    }

    init() {
        loadRecommendations()
    }

    func loadRecommendations() {
        guard let user = currentUser else { return }
        let trainers = Array(service.fetchTrainers())
        let userVec: [Double] = [
            user.pricePerSession,
            user.rating,
            Double(user.expectedTrainerExperience),
            Double(user.travelTime)
        ]

        let scored = trainers.map { trainer -> (Trainer, Double) in
            let score = cosine(trainer.featureVector(), userVec)
            return (trainer, score)
        }

        self.recommendations = scored
            .sorted { $0.1 > $1.1 }
            .map(\.0)
    }
}
