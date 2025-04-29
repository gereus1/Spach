import SwiftUI

struct MainTabView: View {
    @AppStorage("userRole") private var userRole: String = ""

    var body: some View {
        Group {
            if userRole == "trainer" {
                TrainerHomeView()
            } else {
                TabView {
                    RecommendationsView()
                        .tabItem { Label("Рекомендації", systemImage: "star.fill") }
                    UserProfileView()
                        .tabItem { Label("Профіль", systemImage: "person.crop.circle") }
                }
            }
        }
    }
}

