import SwiftUI

struct UserListView: View {
    @State private var users: [User] = []
    private let service = RealmService()

    var body: some View {
        NavigationView {
            List(users) { u in
                NavigationLink(destination: UserDetailView(user: u)) {
                    HStack {
                        Text(u.email)
                        Spacer()
                        Text("\(u.expectedTrainerExperience) р.")
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Запити клієнтів")
            .onAppear {
                users = Array(service.fetchUsers())
            }
        }
    }
}
