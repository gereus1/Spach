import SwiftUI

struct TrainerHomeView: View {
    var body: some View {
        TabView {
            UserListView()
                .tabItem { Label("Клієнти", systemImage: "person.2") }
            TrainerProfileView()
                .tabItem { Label("Профіль", systemImage: "person.crop.circle") }
        }
    }
}
