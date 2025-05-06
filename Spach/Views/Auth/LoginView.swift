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
            // 🔹 Світлий нейтральний фон
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(nsColor: .windowBackgroundColor),
                    Color.white
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                // 🔹 Профільна іконка
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray.opacity(0.7))

                // 🔹 Email
                TextField("Email", text: $email)
                    .textFieldStyle(.plain)
                    .padding()
                    .frame(width: 300)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)

                // 🔹 Пароль
                SecureField("Пароль", text: $password)
                    .textFieldStyle(.plain)
                    .padding()
                    .frame(width: 300)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)

                // 🔹 Кнопка входу
                Button(action: authenticate) {
                    Text("Увійти")
                        .font(.headline)
                        .padding(.vertical, 10)
                        .frame(width: 300)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                .disabled(email.isEmpty || password.isEmpty)
                .opacity(email.isEmpty || password.isEmpty ? 0.5 : 1.0)
                .alert("Помилка", isPresented: $showAlert) {
                    Button("OK") { }
                } message: {
                    Text("Невірні дані")
                }

                Spacer()
            }
            .padding()
        }
    }

    private func authenticate() {
        let realm = try! Realm()

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
