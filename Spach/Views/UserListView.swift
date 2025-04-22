import SwiftUI

struct UserListView: View {
    @State private var users: [User] = []
    private let service = RealmService()

    var body: some View {
        NavigationView {
            List(users) { u in
                HStack {
                    Text(u.email)
                    Spacer()
                    Text("\(u.expectedTrainerExperience) р.")
                }
            }
            .navigationTitle("Запити клієнтів")
            .onAppear { users = Array(service.fetchUsers()) }
        }
    }
}
