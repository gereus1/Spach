import Foundation
import RealmSwift

/// Відповідає за обчислення та завантаження відсортованого за cosine-similarity списку тренерів
class RecommendationViewModel: ObservableObject {
    @Published var recommendations: [Trainer] = []
    @Published var searchText: String = "" // ✅ додано поле для пошуку

    private let service = RealmService()

    /// Будує нормалізатор на всіх векторах (тренери + користувач),
    /// рахує cosine-similarity і зберігає відсортований список
    func loadRecommendations(for user: User) {
        let trainers = Array(service.fetchTrainers())

        // 1) будуємо нормалізатор
        let allVectors = trainers.map { $0.featureVector() } + [ user.expectationVector() ]
        let normalizer = FeatureNormalizer(vectors: allVectors)

        // 3) порахуємо score
        let userVec = user.expectationVector()

        // Перевірка довжин
        for trainer in trainers {
            let trainerVec = trainer.featureVector()
            
            assert(userVec.count == trainerVec.count, "❌ Кількість елементів у векторах не збігається!")
            assert(userVec.count == FeatureWeights.weights.count, "❌ Кількість ваг не збігається з векторами!")
        }

        let userVecNorm = normalizer.normalize(userVec)

        let scored: [(Trainer, Double)] = trainers.map { trainer in
            let tVec = trainer.featureVector()
            let tNorm = normalizer.normalize(tVec)
            let score = normalizer.cosineSimilarity(tNorm, userVecNorm)
            
            print("⚖️ \(trainer.email): cosine = \(String(format: "%.4f", score))")
            
            print("User normalized vector:")
            print(userVecNorm)

            print("Trainer: \(trainer.email)")
            print("Trainer normalized vector:")
            print(tNorm)
            print("→ Cosine score:", score)

            return (trainer, score)
        }
        

        // 4) сортуємо і фільтруємо
        let sorted = scored
            .filter { $0.1 > 0 }
            .sorted { $0.1 > $1.1 }
            .map { $0.0 }

        // 5) зберігаємо
        DispatchQueue.main.async {
            self.recommendations = sorted
        }
    }

    /// ✅ Фільтрований список тренерів за `searchText`
    var filteredRecommendations: [Trainer] {
        guard !searchText.isEmpty else {
            return recommendations
        }
        return recommendations.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.surname.localizedCaseInsensitiveContains(searchText) ||
            $0.email.localizedCaseInsensitiveContains(searchText)
        }
    }
}
