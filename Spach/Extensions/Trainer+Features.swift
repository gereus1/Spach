import RealmSwift

extension Trainer {
    /// Вектор характеристик тренера
    func featureVector() -> [Double] {
        // Базові числові показники
        var vector: [Double] = [
            Double(experience),
            Double(age),
            rating,
            pricePerSession,
            Double(yearsInCategory)
        ]
        
        // Оne‑hot кодування районів
        let districtFeatures = District.allCases.map { district in
            self.districts.contains(district) ? 1.0 : 0.0
        }
        vector.append(contentsOf: districtFeatures)

        // Додаткові бінарні показники
        vector.append(worksWithChildren ? 1.0 : 0.0)
        vector.append(hasCertificates   ? 1.0 : 0.0)

        return vector
    }
}

extension User {
    /// Вектор очікувань користувача
    func expectationVector() -> [Double] {
        var vector: [Double] = [
            Double(expectedTrainerExperience),
            Double(age),
            rating,
            pricePerSession,
            Double(yearsInCategory)
        ]
        
        // Оne‑hot кодування районів
        let districtFeatures = District.allCases.map { district in
            self.districts.contains(district) ? 1.0 : 0.0
        }
        vector.append(contentsOf: districtFeatures)

        vector.append(worksWithChildren ? 1.0 : 0.0)
        vector.append(hasCertificates   ? 1.0 : 0.0)

        return vector
    }
}
