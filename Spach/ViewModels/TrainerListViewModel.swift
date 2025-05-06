//// ViewModels/TrainerListViewModel.swift
//import Foundation
//import RealmSwift
//
//class TrainerListViewModel: ObservableObject {
//    // MARK: – дані
//    @Published var trainers: [Trainer] = []
//    @Published var searchText = ""             // ← додаємо пошук
//
//    private let service = RealmService()
//
//    // MARK: – ініціалізація
//    init() {
//        load()
//    }
//
//    // MARK: – завантажити всіх тренерів
//    func load() {
//        let results = service.fetchTrainers()
//    }
//
//    // MARK: – фільтрований список для List + .searchable
//    var filteredTrainers: [Trainer] {
//        guard !searchText.isEmpty else {
//            return trainers
//        }
//        return trainers.filter {
//            $0.name.localizedCaseInsensitiveContains(searchText)
//        }
//    }
//
//    // MARK: – рекомендації для конкретного користувача
//    func recommended(for user: User) -> [Trainer] {
//        let allTrainers = trainers  // вже підвантажено в load()
//
//        // 1) будуємо нормалізатор на основі всіх векторів
//        let allVectors = allTrainers.map { $0.featureVector() }
//        let normalizer = FeatureNormalizer(vectors: allVectors)
//
//        // 2) нормалізуємо вектор користувача
//        let userVecNorm = normalizer.normalize(user.expectationVector())
//
//        // 3) порахуємо косинусну схожість
//        let scored: [(Trainer, Double)] = allTrainers.map { trainer in
//            let tNorm = normalizer.normalize(trainer.featureVector())
//            let score = normalizer.cosineSimilarity(tNorm, userVecNorm)
//            return (trainer, score)
//        }
//
//        // 4) фільтруємо й сортуємо
//        return scored
//            .filter { $0.1 > 0 }            // прибираємо “порожніх”
//            .sorted { $0.1 > $1.1 }         // за спаданням score
//            .map { $0.0 }                   // лишаємо тільки Trainer
//    }
//}
