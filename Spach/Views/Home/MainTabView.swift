import SwiftUI

struct MainTabView: View {
    @AppStorage("userRole") private var userRole: String = ""

    var body: some View {
        Group {
            if userRole == "trainer" {
                TrainerHomeView()
            } else {
                UserHomeView()
            }
        }
    }
}

