// ViewModels/RecommendationViewModel.swift
import SwiftUI       // для ObservableObject, @Published
import RealmSwift    // для Realm(), Object тощо

class RecommendationViewModel: ObservableObject {
  @Published var recommendations: [Trainer] = []

  private let service = RealmService()
  private let normalizer: FeatureNormalizer

  init() {
    // збираємо всіх тренерів та готуємо нормалізатор на стартах
    let trainers = Array(service.fetchTrainers())
    let allVectors = trainers.map { $0.featureVector() }
    normalizer = FeatureNormalizer(vectors: allVectors)
  }

  func loadRecommendations(for user: User) {
    // якщо юзер не знайдений — вилітаємо
    let trainers = Array(service.fetchTrainers())

    // нормалізований вектор очікувань користувача
    let userVecNorm = normalizer.normalize(user.expectationVector())

    // для кожного тренера обчислюємо схожість
    let scored: [(Trainer, Double)] = trainers.map { trainer in
      let tNorm = normalizer.normalize(trainer.featureVector())
      // тут викликаємо correct ім’я:
      let score = normalizer.cosineSimilarity(tNorm, userVecNorm)
      return (trainer, score)
    }

    // фільтруємо тих, у кого score > 0, сортуємо та беремо тільки Trainer
    recommendations = scored
      .filter { $0.1 > 0 }
      .sorted { $0.1 > $1.1 }
      .map { $0.0 }
  }
}
