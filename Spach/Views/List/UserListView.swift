import SwiftUI

struct UserListView: View {
    @State private var users: [User] = []
    private let service = RealmService()

    var body: some View {
        NavigationView {
            List(users) { u in
                NavigationLink(destination: UserDetailView(user: u)) {
                    UserRowView(user: u)
                }
            }
            .navigationTitle("Запити клієнтів")
            .onAppear {
                users = Array(service.fetchUsers())
            }
        }
    }
}
