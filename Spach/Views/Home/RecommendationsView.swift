import SwiftUI
import Kingfisher

struct RecommendationsView: View {
    @StateObject private var vm = RecommendationViewModel()
    @AppStorage("currentEmail") private var currentEmail: String = ""
    @State private var searchText: String = ""      // 1. Додали змінну для пошуку
    private let service = RealmService()

    // 2. Фільтрація рекомендацій за текстом пошуку
    private var filteredRecommendations: [Trainer] {
        guard !searchText.isEmpty else {
            return vm.recommendations
        }
        return vm.recommendations.filter { trainer in
            // можна фільтрувати за будь-яким полем: тут за email
            trainer.email.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationView {
            List(filteredRecommendations, id: \.id) { trainer in
                NavigationLink {
                    TrainerDetailView(trainer: trainer)
                } label: {
                    HStack(spacing: 12) {
                        if let urlString = trainer.avatarURL,
                           let url = URL(string: urlString) {
                            KFImage(url)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.gray)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(trainer.email)
                            Text(String(format: "Рейтинг: %.1f", trainer.rating))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .searchable(text: $searchText, prompt: "Шукати тренера…") // 3. Додали поле пошуку
            .navigationTitle("Рекомендації")
            .onAppear {
                // 1) За e-mail з AppStorage знаходимо User у Realm
                let allUsers = Array(service.fetchUsers())
                guard let user = allUsers.first(where: { $0.email == currentEmail }) else {
                    return
                }
                // 2) Завантажуємо відсортований список
                vm.loadRecommendations(for: user)
            }
        }
    }
}
