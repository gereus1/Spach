import SwiftUI
import RealmSwift

struct LoginView: View {
    @State private var email    = ""
    @State private var password = ""
    @State private var showAlert = false

    @AppStorage("isLoggedIn")   private var isLoggedIn   = false
    @AppStorage("userRole")     private var userRole     = ""
    @AppStorage("currentEmail") private var currentEmail = ""

    var body: some View {
        ZStack {
            LinearGradient(
              gradient: Gradient(colors: [Color.blue.opacity(0.8), .purple.opacity(0.6)]),
              startPoint: .topLeading, endPoint: .bottomTrailing
            ).ignoresSafeArea()

            VStack(spacing: 32) {
                Text("Увійти")
                  .font(.largeTitle).bold().foregroundColor(.white)

                CardContainer {
                    IconTextField(icon: "envelope.fill",
                                  placeholder: "Email",
                                  text: $email)
                    IconSecureField(icon: "lock.fill",
                                    placeholder: "Пароль",
                                    text: $password)
                }

                PrimaryButton(title: "Увійти") {
                    authenticate()
                }
                .disabled(email.isEmpty || password.isEmpty)
                .alert("Помилка", isPresented: $showAlert) {
                    Button("OK") { }
                } message: {
                    Text("Невірні дані")
                }

                Spacer()
            }
            .padding(.top, 40)
        }
    }

    private func authenticate() {
        let realm = try! Realm()
        print("🔍 Realm file path →", Realm.Configuration.defaultConfiguration.fileURL!.path)
        if let u = realm.objects(User.self)
                     .first(where: { $0.email == email && $0.passwordHash == password }) {
            userRole     = "user"
            currentEmail = u.email
            isLoggedIn   = true
        } else if let t = realm.objects(Trainer.self)
                         .first(where: { $0.email == email && $0.passwordHash == password }) {
            userRole     = "trainer"
            currentEmail = t.email
            isLoggedIn   = true
        } else {
            showAlert = true
        }
    }
}
