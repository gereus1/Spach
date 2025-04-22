import Foundation    // brings in sqrt(_:)
import RealmSwift    // so `Trainer` is visible

extension Trainer {
    func featureVector() -> [Double] {
        [
            pricePerSession,
            rating,
            Double(experience),
            travelTime
        ]
    }
}

/// Косинусная мера схожести между двумя векторами
func cosine(_ a: [Double], _ b: [Double]) -> Double {
    let dot = zip(a, b).map(*).reduce(0, +)
    let normA = sqrt(a.map { $0 * $0 }.reduce(0, +))
    let normB = sqrt(b.map { $0 * $0 }.reduce(0, +))
    return (normA > 0 && normB > 0)
      ? dot / (normA * normB)
      : 0
}
