import Foundation

struct FeatureNormalizer {
    let mins: [Double]
    let maxs: [Double]

    init(vectors: [[Double]]) {
        guard let first = vectors.first else {
            mins = []; maxs = []
            return
        }
        let count = first.count
        mins = (0..<count).map { i in vectors.map { $0[i] }.min() ?? 0 }
        maxs = (0..<count).map { i in vectors.map { $0[i] }.max() ?? 0 }
    }

    func normalize(_ vector: [Double]) -> [Double] {
        zip(vector, zip(mins, maxs)).map { value, mm in
            let (minVal, maxVal) = mm
            guard maxVal > minVal else { return 0 }
            return (value - minVal) / (maxVal - minVal)
        }
    }
    
    func cosineSimilarity(_ a: [Double], _ b: [Double]) -> Double {
      let dot = zip(a,b).map(*).reduce(0, +)
      let normA = sqrt(a.map { $0*$0 }.reduce(0, +))
      let normB = sqrt(b.map { $0*$0 }.reduce(0, +))
      guard normA > 0, normB > 0 else { return 0 }
      return dot / (normA * normB)
    }

}
