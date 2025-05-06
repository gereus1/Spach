// RegisterTrainerView.swift

import SwiftUI
import RealmSwift

struct RegisterTrainerView: View {
    // MARK: — Поля реєстрації
    @State private var email             = ""
    @State private var password          = ""
    @State private var age               = 30.0
    @State private var experience        = 5.0
    @State private var selectedDistricts: [District] = []
    @State private var pricePerSession   = 500
    @State private var yearsInCategory   = 2
    @State private var languagesText     = ""
    @State private var worksWithChildren = false
    @State private var hasCertificates   = false

    // MARK: — Аватар
    @State private var avatarImage: PlatformImage? = nil
    @State private var showImagePicker = false

    @State private var showAlert = false
    @AppStorage("isLoggedIn")   private var isLoggedIn   = false
    @AppStorage("userRole")     private var userRole     = ""
    @AppStorage("currentEmail") private var currentEmail = ""

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.8), .blue.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Text("Реєстрація (Trainer)")
                        .font(.largeTitle).bold()
                        .foregroundColor(.white)

                    // — Аватар
                    VStack {
                        if let img = avatarImage {
                            #if os(iOS)
                            Image(uiImage: img)
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 100, height: 100)
                            #else
                            Image(nsImage: img)
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 100, height: 100)
                            #endif
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Image(systemName: "camera.fill")
                                        .foregroundColor(.white)
                                        .font(.largeTitle)
                                )
                        }
                        Button("Обрати аватар") {
                            showImagePicker = true
                        }
                    }
                    .padding(.top, 20)

                    CardContainer {
                        IconTextField(icon: "envelope.fill", placeholder: "Email", text: $email)
                        IconSecureField(icon: "lock.fill", placeholder: "Пароль", text: $password)
                        LabeledSlider(title: "Вік", value: $age, range: 18...80)
                        LabeledSlider(title: "Exp (р)", value: $experience, range: 0...50)

                        Section(header: Text("Райони у яких працює").font(.headline)) {
                            List(District.allCases, id: \.self) { district in
                                Toggle(district.rawValue, isOn: Binding(
                                    get: { selectedDistricts.contains(district) },
                                    set: { isOn in
                                        if isOn { selectedDistricts.append(district) }
                                        else   { selectedDistricts.removeAll { $0 == district } }
                                    }
                                ))
                            }
                            .frame(height: 200)
                        }

                        LabeledStepper(title: "Ціна за сесію", value: $pricePerSession, range: 0...10000, step: 50, unit: "₴")
                        LabeledStepper(title: "Роки в категорії", value: $yearsInCategory, range: 0...50, unit: "")
                        IconTextField(icon: "globe", placeholder: "Мови (через кому)", text: $languagesText)
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
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $avatarImage)
        }
    }

    private func registerTrainer() {
        let realm = try! Realm()
        let t = Trainer()
        t.email        = email
        t.passwordHash = password
        t.age          = Int(age)
        t.experience   = Int(experience)

        if let img = avatarImage {
            #if os(iOS)
            t.avatarData = img.jpegData(compressionQuality: 0.8)
            #else
            if let tiff = img.tiffRepresentation,
               let rep  = NSBitmapImageRep(data: tiff),
               let data = rep.representation(using: .jpeg, properties: [:]) {
                t.avatarData = data
            }
            #endif
        }

        t.districts.removeAll()
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
        userRole     = "trainer"
        currentEmail = t.email
        showAlert    = true
    }
}
