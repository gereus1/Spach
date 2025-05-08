import SwiftUI

struct TrainerHomeView: View {
    var body: some View {
        TabView {
            NavigationStack {
                ClientRequestsView()
            }
            .tabItem {
                Label("Клієнти", systemImage: "person.2")
            }
                UserListView()
                    .tabItem {
                        Label("Користувачі", systemImage: "person.2")
                }
            NavigationStack {
                TrainerProfileView()
            }
            .tabItem {
                Label("Профіль", systemImage: "person.crop.circle")
            }
        }
    }
}
