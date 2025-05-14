import SwiftUI
import Kingfisher

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

struct TrainerDetailView: View {
    let trainer: Trainer
    let user: User
    let contact: ContactRequest?

    @AppStorage("currentEmail") private var currentEmail = ""
    @State private var showAlert = false
    private let contactService = ContactService()

    private var isContactEstablished: Bool {
        contact?.userRequested == true && contact?.trainerConfirmed == true
    }

    private var cardBackground: Color {
        #if os(macOS)
        Color(nsColor: .windowBackgroundColor)
        #else
        Color(uiColor: .systemBackground)
        #endif
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // MARK: – Avatar
                HStack {
                    Spacer()
                    Group {
                        if let data = trainer.avatarData {
                            #if os(iOS)
                            if let ui = UIImage(data: data) {
                                Image(uiImage: ui).resizable()
                            }
                            #elseif os(macOS)
                            if let ns = NSImage(data: data) {
                                Image(nsImage: ns).resizable()
                            }
                            #endif
                        } else if let urlString = trainer.avatarURL,
                                  let url = URL(string: urlString) {
                            KFImage(url).resizable()
                        } else {
                            Image(systemName: "person.crop.square.fill")
                                .resizable()
                                .foregroundColor(.gray)
                        }
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160, height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(radius: 4)
                    Spacer()
                }

                // MARK: – Основна інформація
                VStack(alignment: .leading, spacing: 12) {
                    Text("Основна інформація")
                        .font(.title2).bold()
                        .padding(.bottom, 4)

                    Group {
                        if isContactEstablished {
                            Label("Email: \(trainer.email)", systemImage: "envelope")
                            Label("Імʼя: \(trainer.name)", systemImage: "person.circle")
                            Label("Прізвище: \(trainer.surname)", systemImage: "person.circle")
                        } else {
                            Label("Email: — приховано —", systemImage: "envelope")
                            Label("Імʼя: — приховано —", systemImage: "person.circle")
                            Label("Прізвище: — приховано —", systemImage: "person.circle")
                        }

                        Label("Вік: \(trainer.age) р.", systemImage: "calendar")
                        Label("Досвід: \(trainer.experience) р.", systemImage: "figure.walk")
                        Label("Рейтинг: \(trainer.rating, specifier: "%.1f")", systemImage: "star.fill")
                        Label("Ціна за сесію: \(trainer.pricePerSession, specifier: "%.0f")₴", systemImage: "creditcard")
                        Label("Райони роботи: \(trainer.districts.map { $0.rawValue }.joined(separator: ", "))", systemImage: "map")
                        Label("Категорії спорту: \(trainer.categories.map { $0.rawValue }.joined(separator: ", "))", systemImage: "figure.walk.circle")
                        Label("Мови: \(trainer.languages.joined(separator: ", "))", systemImage: "globe")
                    }
                    .font(.body)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(cardBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)

                // MARK: – Додатково
                VStack(alignment: .leading, spacing: 12) {
                    Text("Додатково")
                        .font(.title2).bold()
                        .padding(.bottom, 4)

                    HStack {
                        Toggle("Працює з дітьми", isOn: .constant(trainer.worksWithChildren))
                        Toggle("Має сертифікати", isOn: .constant(trainer.hasCertificates))
                    }
                    .toggleStyle(SwitchToggleStyle())
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(cardBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)

                // MARK: – Кнопка “Зв’язатися”
                if contact?.userRequested != true {
                    Button(action: {
                        contactService.createRequest(fromUser: user.id.stringValue, toTrainer: trainer.id.stringValue)
                        showAlert = true
                    }) {
                        Text("Зв’язатися")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }

                Spacer()
            }
            .padding()
            #if os(macOS)
            .frame(maxWidth: 600)
            #endif
            .navigationTitle("Профіль тренера")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Запит надіслано!"),
                      message: Text("Ми надіслали запит тренеру."),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}
