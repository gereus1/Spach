import SwiftUI
import Kingfisher

struct RecommendationsView: View {
    @StateObject private var vm = RecommendationViewModel()
    @AppStorage("currentEmail") private var currentEmail: String = ""
    @State private var searchText: String = ""
    
    private let service = RealmService()
    private let contactService = ContactService()

    private var filteredRecommendations: [Trainer] {
        guard !searchText.isEmpty else {
            return vm.recommendations
        }
        return vm.recommendations.filter { trainer in
            trainer.email.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationView {
            List(filteredRecommendations, id: \.id) { trainer in
                if let user = service.fetchUser(byEmail: currentEmail) {
                    let contact = contactService.getRequest(
                        userId: user.id.stringValue,
                        trainerId: trainer.id.stringValue
                    )

                    NavigationLink(destination: TrainerDetailView(trainer: trainer, user: user, contact: contact)) {
                        HStack(spacing: 12) {
                            if let data = trainer.avatarData {
                                #if os(iOS)
                                if let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                }
                                #else
                                if let nsImage = NSImage(data: data) {
                                    Image(nsImage: nsImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                }
                                #endif
                            } else if let urlString = trainer.avatarURL,
                                      let url = URL(string: urlString) {
                                KFImage(url)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray)
                                    .clipShape(Circle())
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
            }
            .searchable(text: $searchText, prompt: "Шукати тренера…")
            .navigationTitle("Рекомендації")
            .onAppear {
                let allUsers = Array(service.fetchUsers())
                guard let user = allUsers.first(where: { $0.email == currentEmail }) else {
                    return
                }
                vm.loadRecommendations(for: user)
            }
        }
    }
}
