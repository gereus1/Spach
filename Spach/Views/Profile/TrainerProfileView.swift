// TrainerProfileView.swift

import SwiftUI
import RealmSwift

struct TrainerProfileView: View {
    @AppStorage("currentEmail") private var currentEmail = ""
    @State private var trainer: Trainer?
    @State private var isEditing = false
    private let service = RealmService()

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .center, spacing: 16) {
                    if let t = trainer {
                        // АВАТАР
                        Group {
                            if let data = t.avatarData {
                                #if os(iOS)
                                if let ui = UIImage(data: data) {
                                    Image(uiImage: ui)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                        .clipped()
                                }
                                #else
                                if let ns = NSImage(data: data) {
                                    Image(nsImage: ns)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                        .clipped()
                                }
                                #endif
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 16)

                        // ОСНОВНА ІНФОРМАЦІЯ
                        Group {
                            Text("Email: \(t.email)")
                            Text("Імʼя: \(t.name)")
                            Text("Вік: \(t.age, specifier: "%.0f") р.")
                            Text("Досвід: \(t.experience, specifier: "%.0f") р.")
                            Text("Рейтинг: \(t.rating, specifier: "%.1f")")
                            Text("Ціна за сесію: \(t.pricePerSession, specifier: "%.0f")₴")
                            Text("Роки в категорії: \(t.yearsInCategory)")
                            Text("Райони у яких надає послуги: " +
                                 t.district.map { $0.rawValue }.joined(separator: ", "))
                            Text("Мови: " +
                                 t.languages.joined(separator: ", "))
                        }
                        .multilineTextAlignment(.center)

                        // ДОДАТКОВІ ПАРАМЕТРИ
                        Toggle("Працює з дітьми", isOn: .constant(t.worksWithChildren))
                            .toggleStyle(SwitchToggleStyle())
                            .frame(maxWidth: .infinity, alignment: .center)
                        Toggle("Є сертифікати", isOn: .constant(t.hasCertificates))
                            .toggleStyle(SwitchToggleStyle())
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        Text("Завантаження…")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 40)
                    }

                    Spacer(minLength: 20)

                    // Кнопка ВИЙТИ
                    Button("Вийти") {
                        UserDefaults.standard.set(false, forKey: "isLoggedIn")
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 16)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Профіль тренера")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Редагувати") {
                        isEditing = true
                    }
                }
            }
            .sheet(isPresented: $isEditing, onDismiss: reloadTrainer) {
                // force‐unwrap, бо isEditing = true лише коли trainer != nil
                EditTrainerProfileView(trainer: trainer!)
            }
        }
        .onAppear(perform: loadTrainer)
    }

    private func loadTrainer() {
        trainer = service.fetchCurrentTrainer(email: currentEmail)
    }

    private func reloadTrainer() {
        if let t = trainer { currentEmail = t.email }
        loadTrainer()
    }
}
