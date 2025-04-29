import SwiftUI
import RealmSwift

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
                Text("Ціна за сесію: \(t.pricePerSession, specifier: "%.0f")₴")
                Text("Роки в категорії: \(t.yearsInCategory)")

                // правка тут:
                Text("Райони у яких надає послуги: " +
                     t.districts.map { $0.rawValue }
                                .joined(separator: ", "))

                Text("Мови: " +
                     t.languages.map { String($0) }
                                .joined(separator: ", "))

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
        .onAppear {
            trainer = service.fetchCurrentTrainer(email: currentEmail)
        }
    }
}
