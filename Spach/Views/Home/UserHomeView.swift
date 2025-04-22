import SwiftUI

struct UserHomeView: View {
    var body: some View {
        TabView {
            TrainerListView()
                .tabItem { Label("Тренери", systemImage: "person.3") }
            UserProfileView()
                .tabItem { Label("Профіль", systemImage: "person.circle") }
        }
    }
}
