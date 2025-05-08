import SwiftUI
import Kingfisher

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

struct UserDetailView: View {
    let user: User
    let contact: ContactRequest?
    
    @State private var showConfirmationAlert = false
    private let contactService = ContactService()
    
    private var cardBackground: Color {
#if os(macOS)
        Color(nsColor: .windowBackgroundColor)
#else
        Color(uiColor: .systemBackground)
#endif
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // MARK: — Avatar
                HStack {
                    Spacer()
                    Group {
                        if let data = user.avatarData {
#if os(iOS)
                            if let ui = UIImage(data: data) {
                                Image(uiImage: ui).resizable()
                            }
#elseif os(macOS)
                            if let ns = NSImage(data: data) {
                                Image(nsImage: ns).resizable()
                            }
#endif
                        } else if let urlString = user.avatarURL,
                                  let url = URL(string: urlString) {
                            KFImage(url).resizable()
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .foregroundColor(.gray)
                        }
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .shadow(radius: 6)
                    Spacer()
                }
                .padding(.top, 16)
                
                // MARK: — Основна інформація
                VStack(alignment: .leading, spacing: 12) {
                    Text("Основна інформація")
                        .font(.title2).bold()
                        .padding(.bottom, 4)
                    
                    Group {
                        Label("Email: \(user.email)", systemImage: "envelope")
                        Label("Ім’я: \(user.name)", systemImage: "person.circle")
                        Label("Прізвище: \(user.surname)", systemImage: "person.circle.fill")
                        Label("Вік: \(user.age) р.", systemImage: "calendar")
                        Label("Очікуваний досвід тренера: \(user.expectedTrainerExperience) р.", systemImage: "figure.walk")
                        Label("Рейтинг: \(user.rating, specifier: "%.1f")", systemImage: "star.fill")
                        Label("Ціна за сесію: \(user.pricePerSession, specifier: "%.0f")₴", systemImage: "creditcard")
                        Label("Роки в категорії: \(user.yearsInCategory)", systemImage: "clock")
                        Label("Райони проживання: \(user.districts.map { $0.rawValue }.joined(separator: ", "))", systemImage: "map")
                        Label("Мови: \(user.languages.joined(separator: ", "))", systemImage: "globe")
                    }
                    .font(.body)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(cardBackground)
                )
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                // MARK: — Додаткові параметри
                VStack(alignment: .leading, spacing: 12) {
                    Text("Додатково")
                        .font(.title2).bold()
                        .padding(.bottom, 4)
                    
                    HStack {
                        Toggle("Працює з дітьми", isOn: .constant(user.worksWithChildren))
                        Toggle("Має сертифікати", isOn: .constant(user.hasCertificates))
                    }
                    .toggleStyle(SwitchToggleStyle())
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(cardBackground)
                )
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                // MARK: — Кнопка “Зв’язатися”
                if contact == nil {
                    Text("Запит не знайдено.")
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, 8)
                } else if let contact = contact, !contact.trainerConfirmed && !contact.rejected {
                    HStack(spacing: 16) {
                        Button(action: {
                            contactService.confirmRequest(byTrainer: contact.trainerId, forUser: contact.userId)
                            showConfirmationAlert = true
                        }) {
                            Text("Зв’язатися")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            contactService.rejectRequest(userId: contact.userId, trainerId: contact.trainerId)
                            showConfirmationAlert = true
                        }) {
                            Text("Відхилити")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.top, 16)
                }
                
                
                Spacer(minLength: 20)
            }
            .padding()
#if os(macOS)
            .frame(maxWidth: 600)
#endif
            .navigationTitle("Профіль користувача")
            .alert(isPresented: $showConfirmationAlert) {
                Alert(
                    title: Text("Дія виконана"),
                    message: Text("Ви оновили статус запиту. Клієнт буде повідомлений."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}
