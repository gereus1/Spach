//
//  TrainerProfileView.swift
//  Spach
//
//  Created by Andrew Valivaha on 21.04.2025.
//


import SwiftUI

struct TrainerProfileView: View {
    @AppStorage("currentEmail") private var currentEmail = ""
    @State private var trainer: Trainer?
    private let service = RealmService()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let t = trainer {
                Text("Email: \(t.email)")
                Text("Вік: \(t.age) р.")
                Text("Досвід: \(t.experience) р.")
                Text("Рейтинг: \(t.rating, specifier: "%.1f")")
                Text("Ціна за сесію: \(t.pricePerSession, specifier: "%.0f")$")
                Text("Роки в категорії: \(t.yearsInCategory)")
                Text("Час у дорозі: \(t.travelTime, specifier: "%.0f") хв")
                Text("Мови: \(t.languages.joined(separator: ", "))")
                Toggle("Працює з дітьми", isOn: .constant(t.worksWithChildren))
                Toggle("Є сертифікати",   isOn: .constant(t.hasCertificates))
            } else {
                Text("Завантаження…")
            }
            Spacer()
            Button("Вийти") {
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
            }
            .foregroundColor(.red)
        }
        .padding()
        .onAppear { trainer = service.fetchCurrentTrainer(email: currentEmail) }
    }
}
