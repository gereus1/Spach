import SwiftUI
import RealmSwift

struct RegisterTrainerView: View {
    @State private var email       = ""
    @State private var password    = ""
    @State private var age         = 30.0
    @State private var experience  = 5.0
    @State private var travelTime  = 20.0
    @State private var showAlert   = false

    @AppStorage("isLoggedIn")   private var isLoggedIn   = false
    @AppStorage("userRole")     private var userRole     = ""
    @AppStorage("currentEmail") private var currentEmail = ""

    var body: some View {
        ZStack {
            LinearGradient(
              gradient: Gradient(colors: [Color.purple.opacity(0.8), .blue.opacity(0.6)]),
              startPoint: .top, endPoint: .bottom
            ).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Text("Реєстрація (Trainer)")
                      .font(.largeTitle).bold().foregroundColor(.white)

                    CardContainer {
                        IconTextField(icon: "envelope.fill",
                                      placeholder: "Email",
                                      text: $email)
                        IconSecureField(icon: "lock.fill",
                                        placeholder: "Пароль",
                                        text: $password)

                        LabeledSlider(title: "Вік", value: $age, range: 18...80)
                        LabeledSlider(title: "Exp (р)", value: $experience, range: 0...50)
                        LabeledSlider(title: "Час у дорозі (хв)", value: $travelTime, range: 0...120)
                    }

                    PrimaryButton(title: "Зареєструватися") {
                        registerTrainer()
                    }
                    .disabled(email.isEmpty || password.isEmpty)
                    .alert("Готово!", isPresented: $showAlert) {
                        Button("OK") { isLoggedIn = true }
                    } message: {
                        Text("Тренера створено.")
                    }

                    Spacer(minLength: 40)
                }
                .padding(.top, 40)
            }
        }
    }

    private func registerTrainer() {
        let realm = try! Realm()
        let t = Trainer()
        t.email = email
        t.passwordHash = password
        t.age = Int(age)
        t.experience = Int(experience)
        t.travelTime = travelTime
        try! realm.write { realm.add(t) }

        userRole     = "trainer"
        currentEmail = t.email
        showAlert    = true
    }
}
