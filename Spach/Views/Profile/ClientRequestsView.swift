import SwiftUI

struct IndexedRequest: Identifiable {
    let id = UUID()
    let user: User
    let request: ContactRequest
}

struct ClientRequestsView: View {
    @AppStorage("currentEmail") private var currentEmail = ""
    @State private var indexedRequests: [IndexedRequest] = []
    private let service = RealmService()
    private let contactService = ContactService()

    var body: some View {
        VStack {
            if indexedRequests.isEmpty {
                Text("Поки що немає запитів від клієнтів")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(indexedRequests) { item in
                    NavigationLink(destination: UserDetailView(user: item.user, contact: item.request)) {
                        ClientRowView(user: item.user, request: item.request)
                    }
                }
            }
        }
        .navigationTitle("Мої клієнти")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: reloadData) {
                    Label("Оновити", systemImage: "arrow.clockwise")
                }
            }
        }
        .onAppear {
            reloadData()
        }
    }

    private func reloadData() {
        if let trainer = service.fetchTrainer(byEmail: currentEmail) {
            let requests = contactService.getRequestsForTrainer(trainer.id.stringValue)
            let users = requests.compactMap { service.fetchUser(byId: $0.userId) }
            self.indexedRequests = zip(users, requests).map {
                IndexedRequest(user: $0.0, request: $0.1)
            }
        }
    }
}
