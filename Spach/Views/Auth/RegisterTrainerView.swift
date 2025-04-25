import SwiftUI
import RealmSwift

struct RegisterTrainerView: View {
    @State private var email             = ""
    @State private var password          = ""
    @State private var age               = 30.0
    @State private var experience        = 5.0
    @State private var travelTime        = 20.0
    @State private var pricePerSession   = 500
    @State private var yearsInCategory   = 2
    @State private var languagesText     = ""
    @State private var worksWithChildren = false
    @State private var hasCertificates   = false
    @State private var showAlert         = false

    @AppStorage("isLoggedIn")   private var isLoggedIn   = false
    @AppStorage("userRole")     private var userRole     = ""
    @AppStorage("currentEmail") private var currentEmail = ""

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.8), .blue.opacity(0.6)]),
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Text("Реєстрація (Trainer)")
                        .font(.largeTitle).bold()
                        .foregroundColor(.white)

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

                        // Ось вони, додаткові поля:
                        LabeledStepper(title: "Ціна за сесію", value: $pricePerSession, range: 0...10000, step: 50, unit: "₴")
                        LabeledStepper(title: "Роки в категорії", value: $yearsInCategory, range: 0...50, unit: "")
                        IconTextField(icon: "globe",
                                      placeholder: "Мови (через кому)",
                                      text: $languagesText)
                        Toggle("Працює з дітьми", isOn: $worksWithChildren)
                        Toggle("Має сертифікати/ліцензії", isOn: $hasCertificates)
                    }

                    PrimaryButton(title: "Зареєструватися") {
                        registerTrainer()
                    }
                    .disabled(email.isEmpty || password.isEmpty)
                    .alert("Тренера створено!", isPresented: $showAlert) {
                        Button("OK") { isLoggedIn = true }
                    } message: {
                        Text("Ласкаво просимо, тренере!")
                    }

                    Spacer(minLength: 40)
                }
                .padding(.top, 40)
            }
        }
    }

    private func registerTrainer() {
        // тут можна додати валідацію email/password
        let realm = try! Realm()
        let t = Trainer()
        t.email              = email
        t.passwordHash       = password
        t.age                = Int(age)
        t.experience         = Int(experience)
        t.travelTime         = travelTime
        t.pricePerSession    = Double(pricePerSession)
        t.yearsInCategory    = yearsInCategory
        let langs = languagesText
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
        t.languages.append(objectsIn: langs)
        t.worksWithChildren  = worksWithChildren
        t.hasCertificates    = hasCertificates

        try! realm.write { realm.add(t) }

        userRole     = "trainer"
        currentEmail = t.email
        showAlert    = true
    }
}
