import SwiftUI
import Kingfisher

struct UserDetailView: View {
    let user: User

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // АВАТАР
                Group {
                    if let data = user.avatarData {
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
                    } else if let urlString = user.avatarURL,
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
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 16)

                // ОСНОВНА ІНФОРМАЦІЯ
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
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                // ДОДАТКОВІ ПАРАМЕТРИ
                Toggle("Працює з дітьми", isOn: .constant(user.worksWithChildren))
                    .toggleStyle(SwitchToggleStyle())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                Toggle("Має сертифікати", isOn: .constant(user.hasCertificates))
                    .toggleStyle(SwitchToggleStyle())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                Spacer(minLength: 20)
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("Профіль користувача")
    }
}
