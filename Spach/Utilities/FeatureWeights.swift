import Foundation

struct FeatureWeights {
    /// Основні ваги, обраховані динамічно
    static var weights: [Double] {
        var result: [Double] = []

        // 🔹 Кількість елементів
        let categoryCount = SportCategory.allCases.count           // 20
        let districtCount = District.allCases.count                // 10
        let languageCount = allLanguages.count                     // 20


        // 🔹 Загальні пріоритети (ті самі, що ми узгодили раніше)
        let totalCategoryWeight = 0.20
        let totalDistrictWeight = 0.18
        let totalLanguageWeight = 0.03
        let binaryWeights = [0.05, 0.07]
        let numericWeights = [0.15, 0.10, 0.12, 0.10] // останнє — ціна

        // 🔸 Динамічно додаємо
        result += Array(repeating: totalCategoryWeight / Double(categoryCount), count: categoryCount)
        result += Array(repeating: totalDistrictWeight / Double(districtCount), count: districtCount)
        result += Array(repeating: totalLanguageWeight / Double(languageCount), count: languageCount)
        result += binaryWeights
        result += numericWeights

        return result
    }

    /// Індекси елементів у векторі, які треба інвертувати (чим менше — тим краще)
    static let inverseIndices: Set<Int> = [
        totalFeatureCount - 1 // лише pricePerSession
    ]

    /// Кількість усіх фіч (використовується для зручного підрахунку індексів)
    static var totalFeatureCount: Int {
        SportCategory.allCases.count +
        District.allCases.count +
        allLanguages.count +
        2 +  // бінарні
        4    // числові
    }

    /// Статичний список мов (потрібен для побудови one-hot)
    static let allLanguages: [String] = [
        "Англійська", "Іспанська", "Китайська", "Хінді", "Арабська",
        "Французька", "Бенгальська", "Португальська", "Російська", "Урду",
        "Індонезійська", "Німецька", "Японська", "Турецька", "Корейська",
        "Італійська", "Українська", "Польська", "Румунська", "Голландська"
    ]
}
