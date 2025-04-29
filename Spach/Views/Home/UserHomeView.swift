import SwiftUI

struct UserHomeView: View {
    var body: some View {
        TabView {
            RecommendationsView()
              .tabItem {
                Label("Рекомендації", systemImage: "star.fill")
              }

            UserProfileView()
                .tabItem { Label("Профіль", systemImage: "person.circle") }
        }
    }
}
