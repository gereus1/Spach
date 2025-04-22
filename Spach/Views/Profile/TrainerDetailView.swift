// Views/TrainerDetailView.swift

import SwiftUI
import Kingfisher

struct TrainerDetailView: View {
    let trainer: Trainer

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Аватар
                if let urlString = trainer.avatarURL,
                   let url = URL(string: urlString) {
                    KFImage(url)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    Image(systemName: "person.crop.square.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .foregroundColor(.gray)
                }

                // Основна інформація
                Group {
                    Text("Email: \(trainer.email)")
                    Text("Вік: \(trainer.age) р.")
                    Text("Досвід: \(trainer.experience) р.")
                    Text(String(format: "Рейтинг: %.1f", trainer.rating))
                    Text(String(format: "Ціна за сесію: %.0f$", trainer.pricePerSession))
                    Text("Роки в категорії: \(trainer.yearsInCategory)")
                    Text(String(format: "Час у дорозі: %.0f хв", trainer.travelTime))
                    Text("Мови: \(trainer.languages.joined(separator: ", "))")
                }
                .font(.body)

                // Параметри
                Toggle(isOn: .constant(trainer.worksWithChildren)) {
                    Text("Працює з дітьми")
                }
                .toggleStyle(SwitchToggleStyle())

                Toggle(isOn: .constant(trainer.hasCertificates)) {
                    Text("Має сертифікати")
                }
                .toggleStyle(SwitchToggleStyle())

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Профіль тренера")
    }
}
