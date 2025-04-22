//
//  Trainer.swift
//  
//
//  Created by Andrew Valivaha on 22.04.2025.
//


import RealmSwift

class Trainer: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var email: String = ""
    @Persisted var passwordHash: String = ""
    @Persisted var age: Int = 0
    @Persisted var experience: Int = 0
    @Persisted var travelTime: Double = 0.0
    @Persisted var languages: List<String>
    @Persisted var worksWithChildren: Bool = false
    @Persisted var hasCertificates: Bool = false
    @Persisted var rating: Double = 0.0
    @Persisted var pricePerSession: Double = 0.0
    @Persisted var yearsInCategory: Int = 0
    @Persisted var avatarURL: String? = nil
}
