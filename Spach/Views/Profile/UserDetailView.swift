import SwiftUI
import Kingfisher

struct UserDetailView: View {
    let user: User

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Аватар користувача
                if let urlString = user.avatarURL,
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
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email: \(user.email)")
                    Text("Вік: \(user.age) р.")
                    Text("Очікуваний досвід тренера: \(user.expectedTrainerExperience) р.")
                    Text("Рейтинг: \(user.rating, specifier: "%.1f")")
                    Text("Ціна за сесію: \(user.pricePerSession, specifier: "%.0f")₴")
                    Text("Роки в категорії: \(user.yearsInCategory)")
                    Text("Райони проживання: \(user.districts.map { $0.rawValue }.joined(separator: ", "))")
                    Text("Мови: \(user.languages.joined(separator: ", "))")
                }
                .font(.body)

                // Додаткові параметри
                Toggle("Працює з дітьми", isOn: .constant(user.worksWithChildren))
                    .toggleStyle(SwitchToggleStyle())
                Toggle("Має сертифікати", isOn: .constant(user.hasCertificates))
                    .toggleStyle(SwitchToggleStyle())

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Профіль користувача")
    }
}
