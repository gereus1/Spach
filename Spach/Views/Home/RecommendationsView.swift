import SwiftUI
import Kingfisher

struct RecommendationsView: View {
    @StateObject private var vm = RecommendationViewModel()

    var body: some View {
        NavigationView {
            List(vm.recommendations, id: \.id) { trainer in
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
            .navigationTitle("Рекомендації")
        }
    }
}
