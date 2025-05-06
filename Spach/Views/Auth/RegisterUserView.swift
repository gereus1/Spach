import SwiftUI
import RealmSwift

struct RegisterUserView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var surname = ""
    @State private var age = 25.0
    @State private var experience = 1.0
    @State private var selectedDistricts: [District] = []
    @State private var pricePerSession = 500
    @State private var yearsInCategory = 2
    @State private var languagesText = ""
    @State private var worksWithChildren = false
    @State private var hasCertificates = false

    @State private var avatarImage: PlatformImage? = nil
    @State private var showImagePicker = false
    @State private var showAlert = false

    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("userRole") private var userRole = ""
    @AppStorage("currentEmail") private var currentEmail = ""

    var body: some View {
        ZStack {
            Color(nsColor: .windowBackgroundColor).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Text("Реєстрація користувача")
                        .font(.largeTitle.bold())

                    // 🔷 Аватар
                    VStack(spacing: 8) {
                        if let img = avatarImage {
                            #if os(iOS)
                            Image(uiImage: img)
                            #else
                            Image(nsImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                            #endif

                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.gray)
                                )
                        }
                        Button("Обрати аватар") {
                            showImagePicker = true
                        }
                    }

                    // 🔷 Форма
                    GlassCard {
                        IconTextField(icon: "envelope", placeholder: "Email", text: $email)
                        IconSecureField(icon: "lock", placeholder: "Пароль", text: $password)
                        IconTextField(icon: "person", placeholder: "Імʼя", text: $name)
                        IconTextField(icon: "person", placeholder: "Прізвище", text: $surname)
                        LabeledSlider(title: "Вік", value: $age, range: 10...100)
                        LabeledSlider(title: "Очікуваний досвід тренера", value: $experience, range: 0...50)
                        LabeledStepper(title: "Ціна за сесію", value: $pricePerSession, range: 0...10000, step: 50, unit: "₴")
                        LabeledStepper(title: "Роки в категорії", value: $yearsInCategory, range: 0...50, unit: "р.")
                        IconTextField(icon: "globe", placeholder: "Мови (через кому)", text: $languagesText)
                        Toggle("Працює з дітьми", isOn: $worksWithChildren)
                        Toggle("Є сертифікати", isOn: $hasCertificates)
                    }

                    // 🔷 Райони
                    GlassCard {
                        Text("Райони, де хочете тренуватись").font(.headline)
                        ForEach(District.allCases, id: \.self) { district in
                            Toggle(district.rawValue, isOn: Binding(
                                get: { selectedDistricts.contains(district) },
                                set: { isOn in
                                    if isOn { selectedDistricts.append(district) }
                                    else { selectedDistricts.removeAll { $0 == district } }
                                }
                            ))
                        }
                    }

                    // 🔷 Кнопка
                    Button("Зареєструватися") {
                        registerUser()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(email.isEmpty || password.isEmpty)
                    .alert("Користувача створено!", isPresented: $showAlert) {
                        Button("OK") { isLoggedIn = true }
                    } message: {
                        Text("Ласкаво просимо!")
                    }

                    Spacer(minLength: 40)
                }
                .padding()
                .frame(maxWidth: 500)
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $avatarImage)
        }
    }

    private func registerUser() {
        let realm = try! Realm()
        let u = User()
        u.email = email
        u.name = name
        u.surname = surname
        u.passwordHash = password
        u.age = Int(age)
        u.expectedTrainerExperience = Int(experience)

        if let img = avatarImage {
            #if os(iOS)
            u.avatarData = img.jpegData(compressionQuality: 0.8)
            #else
            if let tiff = img.tiffRepresentation,
               let rep = NSBitmapImageRep(data: tiff),
               let data = rep.representation(using: .jpeg, properties: [:]) {
                u.avatarData = data
            }
            #endif
        }

        u.districts.append(objectsIn: selectedDistricts)
        u.pricePerSession = Double(pricePerSession)
        u.yearsInCategory = yearsInCategory
        let langs = languagesText
            .split(separator: ",")
            .map { String($0).trimmingCharacters(in: .whitespaces) }
        u.languages.append(objectsIn: langs)
        u.worksWithChildren = worksWithChildren
        u.hasCertificates = hasCertificates

        try! realm.write { realm.add(u) }
        userRole = "user"
        currentEmail = u.email
        showAlert = true
    }
}
