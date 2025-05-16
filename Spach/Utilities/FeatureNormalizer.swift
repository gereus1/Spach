import Foundation

struct FeatureNormalizer {
    private var mins: [Double]
    private var maxs: [Double]

    init(vectors: [[Double]]) {
        let dimension = vectors.first?.count ?? 0
        mins = Array(repeating: 0.0, count: dimension)
        maxs = Array(repeating: 1.0, count: dimension)

        for i in 0..<dimension {
            let values = vectors.map { $0[i] }
            mins[i] = values.min() ?? 0.0
            maxs[i] = values.max() ?? 1.0
        }
    }

    func normalize(_ vector: [Double]) -> [Double] {
        assert(vector.count == FeatureWeights.weights.count, "❌ Вектор і ваги мають різну довжину!")

        return zip(vector.indices, vector).map { (index, value) in
            let minVal = mins[index]
            let maxVal = maxs[index]
            let weight = FeatureWeights.weights[index]

            let normalized: Double
            if maxVal - minVal != 0 {
                normalized = (value - minVal) / (maxVal - minVal)
            } else {
                normalized = 0.0
            }

            // Інверсія: якщо чим менше — тим краще, то беремо (1 - normalized)
            let adjusted = FeatureWeights.inverseIndices.contains(index) ? (1.0 - normalized) : normalized

            return adjusted * weight
        }
    }

    func cosineSimilarity(_ a: [Double], _ b: [Double]) -> Double {
        let dot = zip(a, b).map(*).reduce(0.0, +)
        let normA = sqrt(a.map { $0 * $0 }.reduce(0.0, +))
        let normB = sqrt(b.map { $0 * $0 }.reduce(0.0, +))
        return (normA * normB != 0) ? dot / (normA * normB) : 0
    }
}

