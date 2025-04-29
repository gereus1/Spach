import SwiftUI
import RealmSwift

struct UserProfileView: View {
    @AppStorage("currentEmail") private var currentEmail = ""
    @State private var user: User?
    private let service = RealmService()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let u = user {
                Text("Email: \(u.email)")
                Text("Вік: \(u.age) р.")
                Text("Досвід тренера: \(u.expectedTrainerExperience) р.")
                Text("Рейтинг: \(u.rating, specifier: "%.1f")")
                Text("Ціна за сесію: \(u.pricePerSession, specifier: "%.0f")₴")
                Text("Роки в категорії: \(u.yearsInCategory)")

                // і тут теж:
                Text("Райони у яких може отримувати послуги: " +
                     u.districts.map { $0.rawValue }
                                 .joined(separator: ", "))

                Text("Мови: " +
                     Array(u.languages)
                        .joined(separator: ", "))

                Toggle("Працює з дітьми", isOn: .constant(u.worksWithChildren))
                Toggle("Є сертифікати",    isOn: .constant(u.hasCertificates))
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
            user = service.fetchCurrentUser(email: currentEmail)
        }
    }
}
