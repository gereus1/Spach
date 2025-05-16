import RealmSwift

extension Trainer {
    /// Вектор характеристик тренера
    func featureVector() -> [Double] {
            var vector: [Double] = []

            // Категорії спорту (one-hot)
            for category in SportCategory.allCases {
                vector.append(categories.contains(category) ? 1.0 : 0.0)
            }

            // Райони
            for district in District.allCases {
                vector.append(districts.contains(district) ? 1.0 : 0.0)
            }

            // Мови
            let allLanguages = [
                "Англійська",
                "Іспанська",
                "Китайська",
                "Хінді",
                "Арабська",
                "Французька",
                "Бенгальська",
                "Португальська",
                "Російська",
                "Урду",
                "Індонезійська",
                "Німецька",
                "Японська",
                "Турецька",
                "Корейська",
                "Італійська",
                "Українська",
                "Польська",
                "Румунська",
                "Голландська"
            ]
            for lang in allLanguages {
                vector.append(languages.contains(lang) ? 1.0 : 0.0)
            }

            // Бінарні
            vector.append(worksWithChildren ? 1.0 : 0.0)
            vector.append(hasCertificates ? 1.0 : 0.0)

            // Числові
            vector.append(Double(experience))
            vector.append(Double(yearsInCategory))
            vector.append(rating)
            vector.append(pricePerSession)

            return vector
        }
}

extension User {
    /// Вектор очікувань користувача
    func expectationVector() -> [Double] {
            var vector: [Double] = []

            // Категорії спорту (one-hot)
            for category in SportCategory.allCases {
                vector.append(expectedCategories.contains(category) ? 1.0 : 0.0)
            }

            // Райони
            for district in District.allCases {
                vector.append(districts.contains(district) ? 1.0 : 0.0)
            }

            // Мови
            let allLanguages = [
                "Англійська",
                "Іспанська",
                "Китайська",
                "Хінді",
                "Арабська",
                "Французька",
                "Бенгальська",
                "Португальська",
                "Російська",
                "Урду",
                "Індонезійська",
                "Німецька",
                "Японська",
                "Турецька",
                "Корейська",
                "Італійська",
                "Українська",
                "Польська",
                "Румунська",
                "Голландська"
            ]
            for lang in allLanguages {
                vector.append(languages.contains(lang) ? 1.0 : 0.0)
            }

            // Бінарні
            vector.append(worksWithChildren ? 1.0 : 0.0)
            vector.append(hasCertificates ? 1.0 : 0.0)

            // Числові
            vector.append(Double(expectedTrainerExperience))
            vector.append(0.0) // User не має yearsInCategory
            vector.append(expectedRating)
            vector.append(pricePerSession)

            return vector
        }
}
