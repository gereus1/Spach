import SwiftUI
import RealmSwift

struct RegisterUserView: View {
    @State private var email     = ""
    @State private var password  = ""
    @State private var age       = 25.0
    @State private var experience = 1.0
    @State private var travelTime = 15.0
    @State private var showAlert = false

    @AppStorage("isLoggedIn")   private var isLoggedIn   = false
    @AppStorage("userRole")     private var userRole     = ""
    @AppStorage("currentEmail") private var currentEmail = ""

    var body: some View {
        ZStack {
            LinearGradient(
              gradient: Gradient(colors: [Color.orange.opacity(0.8), .red.opacity(0.6)]),
              startPoint: .topTrailing, endPoint: .bottomLeading
            ).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Text("Реєстрація (User)")
                      .font(.largeTitle).bold().foregroundColor(.white)

                    CardContainer {
                        IconTextField(icon: "envelope.fill",
                                      placeholder: "Email",
                                      text: $email)
                        IconSecureField(icon: "lock.fill",
                                        placeholder: "Пароль",
                                        text: $password)

                        LabeledSlider(title: "Вік", value: $age, range: 10...100)
                        LabeledSlider(title: "Exp (р)", value: $experience, range: 0...50)
                        LabeledSlider(title: "Час у дорозі (хв)", value: $travelTime, range: 0...120)
                    }

                    PrimaryButton(title: "Зареєструватися") {
                        registerUser()
                    }
                    .disabled(email.isEmpty || password.isEmpty)
                    .alert("Готово!", isPresented: $showAlert) {
                        Button("OK") { isLoggedIn = true }
                    } message: {
                        Text("Користувача створено.")
                    }

                    Spacer(minLength: 40)
                }
                .padding(.top, 40)
            }
        }
    }

    private func registerUser() {
        let realm = try! Realm()
        let u = User()
        u.email = email
        u.passwordHash = password
        u.age = Int(age)
        u.expectedTrainerExperience = Int(experience)
        u.travelTime = travelTime
        try! realm.write { realm.add(u) }

        userRole     = "user"
        currentEmail = u.email
        showAlert    = true
    }
}
