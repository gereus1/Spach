import SwiftUI
import Kingfisher

struct TrainerDetailView: View {
    let trainer: Trainer

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let data = trainer.avatarData {
                                    #if os(iOS)
                                    if let ui = UIImage(data: data) {
                                        Image(uiImage: ui)
                                            .resizable()
                                            .scaledToFill()
                                            .clipShape(Circle())
                                            .frame(width: 200, height: 200)
                                    }
                                    #else
                                    if let ns = NSImage(data: data) {
                                        Image(nsImage: ns)
                                            .resizable()
                                            .scaledToFill()
                                            .clipShape(Circle())
                                            .frame(width: 200, height: 200)
                                    }
                                    #endif
                                } else if let urlString = trainer.avatarURL,
                                          let url = URL(string: urlString) {
                                    KFImage(url)
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(Circle())
                                        .frame(width: 200, height: 200)
                                } else {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.gray)
                                        .frame(width: 200, height: 200)
                                }
                // Основна інформація
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email: \(trainer.email)")
                    Text("Вік: \(trainer.age) р.")
                    Text("Досвід: \(trainer.experience) р.")
                    Text("Рейтинг: \(trainer.rating, specifier: "%.1f")")
                    Text("Ціна за сесію: \(trainer.pricePerSession, specifier: "%.0f")₴")
                    Text("Райони роботи: \(trainer.districts.map { $0.rawValue }.joined(separator: ", "))")
                    Text("Мови: \(trainer.languages.joined(separator: ", "))")
                }
                .font(.body)

                // Додаткові параметри
                Toggle("Працює з дітьми", isOn: .constant(trainer.worksWithChildren))
                    .toggleStyle(SwitchToggleStyle())
                Toggle("Має сертифікати", isOn: .constant(trainer.hasCertificates))
                    .toggleStyle(SwitchToggleStyle())

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Профіль тренера")
    }
}
