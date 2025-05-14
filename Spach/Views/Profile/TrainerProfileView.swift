import SwiftUI
import RealmSwift

struct TrainerProfileView: View {
    @AppStorage("currentEmail") private var currentEmail = ""
    @State private var trainer: Trainer?
    @State private var isEditing = false
    @State private var refreshTrigger = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var ratingCount = 0

    private let service = RealmService()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let t = trainer {
                    // Аватар
                    if let data = t.avatarData {
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
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray.opacity(0.4))
                            .clipShape(Circle())
                            .shadow(radius: 8)
                    }

                    // Імʼя та пошта
                    Text(t.name + " " + t.surname)
                        .font(.title2.bold())

                    Text(t.email)
                        .foregroundColor(.secondary)

                    Divider()

                    // Основна інформація
                    GroupBox(label: Label("Інформація", systemImage: "person.fill")) {
                        ProfileRow(title: "Вік", value: "\(t.age) р.")
                        ProfileRow(title: "Досвід", value: "\(t.experience) р.")
                        ProfileRow(
                            title: "Рейтинг",
                            value: String(format: "%.1f", t.rating) + " (\(ratingCount))"
                        )
                        ProfileRow(title: "Ціна за сесію", value: "\(Int(t.pricePerSession))₴")
                        ProfileRow(title: "Роки в категорії", value: "\(t.yearsInCategory)")
                    }

                    // Послуги
                    GroupBox(label: Label("Послуги", systemImage: "globe")) {
                        ProfileRow(title: "Райони", value: t.districts.map { $0.rawValue }.joined(separator: ", "))
                        ProfileRow(title: "Категорії спорту", value: t.categories.map { $0.rawValue }.joined(separator: ", "))
                        ProfileRow(title: "Мови", value: t.languages.joined(separator: ", "))
                        Toggle("Працює з дітьми", isOn: .constant(t.worksWithChildren)).disabled(true)
                        Toggle("Є сертифікати", isOn: .constant(t.hasCertificates)).disabled(true)
                    }

                    // Кнопки
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
            let result = service.fetchCurrentTrainer(email: currentEmail)
            if let trainer = result {
                self.trainer = trainer
                self.ratingCount = service.fetchRatings(for: trainer.id).count
            } else {
                currentEmail = ""
                isLoggedIn = false
            }
        }
        .sheet(isPresented: $isEditing) {
            if let trainer = trainer {
                EditTrainerProfileView(trainer: trainer, refreshTrigger: $refreshTrigger)
            }
        }
        .onChange(of: refreshTrigger) {
            trainer = service.fetchCurrentTrainer(email: currentEmail)
            if let trainer = trainer {
                self.ratingCount = service.fetchRatings(for: trainer.id).count
            }
        }
    }
}

// Підтримка стрічки профілю
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
