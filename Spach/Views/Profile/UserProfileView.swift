import SwiftUI
import RealmSwift

struct UserProfileView: View {
    @AppStorage("currentEmail") private var currentEmail = ""
    @State private var user: User?
    @State private var isEditing = false
    @State private var refreshTrigger = false // 🔁 Тригер для оновлення

    private let service = RealmService()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let u = user {
                    // 🔷 Аватар
                    if let data = u.avatarData {
                        #if os(iOS)
                        if let ui = UIImage(data: data) {
                            Image(uiImage: ui)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .shadow(radius: 8)
                        }
                        #else
                        if let ns = NSImage(data: data) {
                            Image(nsImage: ns)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .shadow(radius: 8)
                        }
                        #endif
                    }

                    // 🔷 Ім'я та email
                    Text(u.name + " " + u.surname)
                        .font(.title2.bold())

                    Text(u.email)
                        .foregroundColor(.secondary)

                    Divider()

                    // 🔷 Основна інформація
                    GroupBox(label: Label("Особисті дані", systemImage: "person.crop.circle")) {
                        ProfileRow(title: "Вік", value: "\(u.age) р.")
                        ProfileRow(title: "Очікуваний досвід тренера", value: "\(u.expectedTrainerExperience) р.")
                        ProfileRow(title: "Рейтинг", value: String(format: "%.1f", u.rating))
                        ProfileRow(title: "Ціна за сесію", value: "\(Int(u.pricePerSession))₴")
                        ProfileRow(title: "Роки в категорії", value: "\(u.yearsInCategory)")
                    }

                    // 🔷 Уподобання
                    GroupBox(label: Label("Уподобання", systemImage: "slider.horizontal.3")) {
                        ProfileRow(title: "Райони", value: u.districts.map { $0.rawValue }.joined(separator: ", "))
                        ProfileRow(title: "Мови", value: u.languages.joined(separator: ", "))
                        Toggle("Працює з дітьми", isOn: .constant(u.worksWithChildren)).disabled(true)
                        Toggle("Є сертифікати", isOn: .constant(u.hasCertificates)).disabled(true)
                    }

                    // 🔷 Кнопки
                    HStack(spacing: 16) {
                        Button("Редагувати") {
                            isEditing = true
                        }
                        .buttonStyle(.bordered)

                        Button("Вийти") {
                            UserDefaults.standard.set(false, forKey: "isLoggedIn")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                    .padding(.top, 20)

                } else {
                    ProgressView("Завантаження…")
                        .padding(.top, 40)
                }
            }
            .padding()
            .frame(maxWidth: 500)
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            user = service.fetchCurrentUser(email: currentEmail)
        }
        // 🔁 Оновлення профілю після редагування
        .sheet(isPresented: $isEditing) {
            if let user = user {
                EditUserProfileView(user: user, refreshTrigger: $refreshTrigger)
            }
        }
        .onChange(of: refreshTrigger) {
            user = service.fetchCurrentUser(email: currentEmail)
        }
    }
}

// 🔸 Підтримувальна вʼюшка для стрічки профілю
private struct ProfileRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
        }
        .padding(.vertical, 4)
    }
}
