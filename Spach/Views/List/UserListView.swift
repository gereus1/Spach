import SwiftUI

struct UserListView: View {
    @AppStorage("currentEmail") private var currentEmail = ""
    @State private var users: [User] = []
    private let service = RealmService()
    private let contactService = ContactService()

    var body: some View {
        NavigationView {
            List(users) { user in
                if let trainer = service.fetchTrainer(byEmail: currentEmail) {
                    let contact = contactService.getRequest(
                        userId: user.id.stringValue,
                        trainerId: trainer.id.stringValue
                    )

                    NavigationLink(destination: UserDetailView(user: user, contact: contact)) {
                        UserRowView(user: user)
                    }
                }
            }
            .navigationTitle("Запити клієнтів")
            .onAppear {
                users = Array(service.fetchUsers())
            }
        }
    }
}
