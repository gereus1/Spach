// Extensions/Trainer+Features.swift
import RealmSwift

extension Trainer {
    /// Вектор характеристик тренера
    func featureVector() -> [Double] {
        [
            Double(experience),
            Double(age),
            rating,
            pricePerSession,
            Double(yearsInCategory),
            travelTime,
            worksWithChildren ? 1 : 0,
            hasCertificates   ? 1 : 0
        ]
    }
}

extension User {
    /// Вектор очікувань користувача
    func expectationVector() -> [Double] {
        [
            Double(expectedTrainerExperience),
            Double(age),
            rating,
            pricePerSession,
            Double(yearsInCategory),
            travelTime,
            worksWithChildren ? 1 : 0,
            hasCertificates   ? 1 : 0
        ]
    }
}
