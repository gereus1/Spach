import SwiftUI

struct AuthRootView: View {
  var body: some View {
    NavigationView {
      List {
        NavigationLink {
          LoginView()
        } label: {
          Label("Увійти", systemImage: "lock.open")
        }

        NavigationLink {
          RegisterUserView()
        } label: {
          Label("Реєстрація користувача", systemImage: "person.crop.circle.badge.plus")
        }

        NavigationLink {
          RegisterTrainerView()
        } label: {
          Label("Реєстрація тренера", systemImage: "person.3.fill")
        }
      }
      .navigationTitle("Вхід / Реєстрація")
    }
  }
}
