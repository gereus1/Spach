import SwiftUI
import RealmSwift

struct RegisterTrainerView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var surname = ""
    @State private var age = 30.0
    @State private var experience = 5.0
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
                    Text("Реєстрація тренера")
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
                        LabeledSlider(title: "Вік", value: $age, range: 18...80)
                        LabeledSlider(title: "Досвід (р)", value: $experience, range: 0...50)
                        LabeledStepper(title: "Ціна за сесію", value: $pricePerSession, range: 0...10000, step: 50, unit: "₴")
                        LabeledStepper(title: "Роки в категорії", value: $yearsInCategory, range: 0...50, unit: "р.")
                        IconTextField(icon: "globe", placeholder: "Мови (через кому)", text: $languagesText)
                        Toggle("Працює з дітьми", isOn: $worksWithChildren)
                        Toggle("Є сертифікати", isOn: $hasCertificates)
                    }

                    // 🔷 Райони
                    GlassCard {
                        Text("Райони, в яких працює").font(.headline)
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
                        registerTrainer()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(email.isEmpty || password.isEmpty)
                    .alert("Успіх", isPresented: $showAlert) {
                        Button("Ок") { isLoggedIn = true }
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

    private func registerTrainer() {
        let realm = try! Realm()
        let t = Trainer()
        t.email        = email
        t.passwordHash = password
        t.name         = name
        t.surname      = surname
        t.age          = Int(age)
        t.experience   = Int(experience)

        if let img = avatarImage {
            #if os(iOS)
            t.avatarData = img.jpegData(compressionQuality: 0.8)
            #else
            if let tiff = img.tiffRepresentation,
               let rep = NSBitmapImageRep(data: tiff),
               let data = rep.representation(using: .jpeg, properties: [:]) {
                t.avatarData = data
            }
            #endif
        }

        t.districts.append(objectsIn: selectedDistricts)
        t.pricePerSession = Double(pricePerSession)
        t.yearsInCategory = yearsInCategory
        let langs = languagesText
            .split(separator: ",")
            .map { String($0).trimmingCharacters(in: .whitespaces) }
        t.languages.append(objectsIn: langs)
        t.worksWithChildren = worksWithChildren
        t.hasCertificates   = hasCertificates

        try! realm.write { realm.add(t) }
        userRole = "trainer"
        currentEmail = t.email
        showAlert = true
    }
}
