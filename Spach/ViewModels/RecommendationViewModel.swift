// ViewModels/RecommendationViewModel.swift
import Foundation
import RealmSwift

/// Відповідає за обчислення та завантаження відсортованого за cosine-similarity списку тренерів
class RecommendationViewModel: ObservableObject {
    @Published var recommendations: [Trainer] = []
    private let service = RealmService()

    /// Будує нормалізатор на всіх векторах (тренери + користувач),
    /// рахує cosine-similarity і зберігає відсортований список
    func loadRecommendations(for user: User) {
        let trainers = Array(service.fetchTrainers())
        // 1) беремо вектори всіх тренерів та додамо вектор очікувань користувача
        let allVectors = trainers.map { $0.featureVector() } + [ user.expectationVector() ]
        let normalizer = FeatureNormalizer(vectors: allVectors)

        // 2) нормалізуємо вектор користувача
        let userVecNorm = normalizer.normalize(user.expectationVector())

        // 3) для кожного тренера порахуємо score
        let scored: [(Trainer, Double)] = trainers.map { trainer in
            let tNorm = normalizer.normalize(trainer.featureVector())
            let score = normalizer.cosineSimilarity(tNorm, userVecNorm)
            return (trainer, score)
        }

        // 4) відсортуємо за спаданням і викинемо нічийних (score == 0 за бажанням)
        let sorted = scored
            .filter { $0.1 > 0 }           // прибрати тренерів зі score == 0
            .sorted  { $0.1 > $1.1 }       // сортування за спаданням score
            .map     { $0.0 }              // беремо лише Trainer

        // 5) оновлюємо Published-масив
        DispatchQueue.main.async {
            self.recommendations = sorted
        }
    }
}
