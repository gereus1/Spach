// UserProfileView.swift

import SwiftUI
import RealmSwift

struct UserProfileView: View {
    @AppStorage("currentEmail") private var currentEmail = ""
    @State private var user: User?
    @State private var isEditing = false
    private let service = RealmService()

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .center, spacing: 16) {
                    if let u = user {
                        // АВАТАР
                        Group {
                            if let data = u.avatarData {
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
                            Text("Email: \(u.email)")
                            Text("Імʼя: \(u.name)")
                            Text("Вік: \(u.age, specifier: "%.0f") р.")
                            Text("Очікуваний досвід тренера: \(u.expectedTrainerExperience, specifier: "%.0f") р.")
                            Text("Рейтинг: \(u.rating, specifier: "%.1f")")
                            Text("Ціна за сесію: \(u.pricePerSession, specifier: "%.0f")₴")
                            Text("Роки в категорії: \(u.yearsInCategory)")
                            Text("Райони у яких може отримувати послуги: " +
                                 u.district.map { $0.rawValue }.joined(separator: ", "))
                            Text("Мови: " +
                                 u.languages.joined(separator: ", "))
                        }
                        .multilineTextAlignment(.center)

                        // ДОДАТКОВІ ПАРАМЕТРИ
                        Toggle("Працює з дітьми", isOn: .constant(u.worksWithChildren))
                            .toggleStyle(SwitchToggleStyle())
                            .frame(maxWidth: .infinity, alignment: .center)
                        Toggle("Є сертифікати", isOn: .constant(u.hasCertificates))
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
            .navigationTitle("Профіль користувача")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Редагувати") {
                        isEditing = true
                    }
                }
            }
            .sheet(isPresented: $isEditing, onDismiss: reloadUser) {
                // force‐unwrap без if-let, бо isEditing ставимо = true лише коли user != nil
                EditUserProfileView(user: user!)
            }
        }
        .onAppear(perform: loadUser)
    }

    private func loadUser() {
        user = service.fetchCurrentUser(email: currentEmail)
    }

    private func reloadUser() {
        if let u = user { currentEmail = u.email }
        loadUser()
    }
}
