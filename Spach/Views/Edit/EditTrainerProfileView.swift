import SwiftUI
import RealmSwift

struct EditTrainerProfileView: View {
    @ObservedObject var vm: EditTrainerProfileViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var refreshTrigger: Bool

    @State private var showSuccess = false
    @Namespace private var animation

    init(trainer: Trainer, refreshTrigger: Binding<Bool>) {
        self._refreshTrigger = refreshTrigger
        self.vm = EditTrainerProfileViewModel(trainer: trainer)
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Редагування тренера")
                        .font(.title.bold())
                        .padding(.top, 8)

                    // 🔹 Основна інформація
                    GroupBox(label: Label("Основна інформація", systemImage: "person")) {
                        VStack(alignment: .leading, spacing: 12) {
                            TextField("Ім’я", text: $vm.name)
                                .textFieldStyle(.roundedBorder)
                            TextField("Прізвище", text: $vm.surname)
                                .textFieldStyle(.roundedBorder)
                            TextField("Email", text: $vm.email)
                                .textFieldStyle(.roundedBorder)

                            Stepper("Вік: \(vm.age)", value: $vm.age, in: 18...100)
                            Stepper("Досвід: \(vm.experience)", value: $vm.experience, in: 0...50)
                            Stepper("Роки в категорії: \(vm.yearsInCategory)", value: $vm.yearsInCategory, in: 0...50)
                            Stepper("Ціна за сесію: \(vm.pricePerSession, specifier: "%.0f")₴", value: $vm.pricePerSession, in: 0...10000, step: 100)
                            Stepper("Рейтинг: \(vm.rating, specifier: "%.1f")", value: $vm.rating, in: 0...5, step: 0.1)
                        }
                    }

                    // 🔹 Послуги
                    GroupBox(label: Label("Послуги", systemImage: "globe")) {
                        VStack(alignment: .leading, spacing: 12) {
                            TextField("Мови (через кому)", text: $vm.languagesText)
                                .textFieldStyle(.roundedBorder)
                            TextField("Райони (через кому)", text: $vm.districtsText)
                                .textFieldStyle(.roundedBorder)

                            Toggle("Працює з дітьми", isOn: $vm.worksWithChildren)
                            Toggle("Є сертифікати", isOn: $vm.hasCertificates)
                        }
                    }

                    // 🔹 Кнопка збереження з анімацією
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showSuccess = true
                        }

                        vm.saveChanges()
                        refreshTrigger.toggle()

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                showSuccess = false
                            }
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Зберегти")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .scaleEffect(showSuccess ? 1.05 : 1.0)
                            .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                }
                .padding()
                .frame(maxWidth: 500)
            }

            // 🔹 Успішне збереження банер
            if showSuccess {
                VStack {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .green)
                        Text("Збережено успішно")
                            .fontWeight(.medium)
                    }
                    .padding()
                    .background(Color.green.opacity(0.9))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .shadow(radius: 8)
                    .transition(.move(edge: .top).combined(with: .opacity))

                    Spacer()
                }
                .padding(.top, 16)
                .frame(maxWidth: .infinity)
            }
        }
    }
}
