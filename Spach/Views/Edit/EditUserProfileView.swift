import SwiftUI
import RealmSwift

struct EditUserProfileView: View {
    @ObservedObject var vm: EditUserProfileViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var refreshTrigger: Bool

    @State private var showSuccess = false
    @Namespace private var animation

    init(user: User, refreshTrigger: Binding<Bool>) {
        self._refreshTrigger = refreshTrigger
        self.vm = EditUserProfileViewModel(user: user)
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Редагування профілю")
                        .font(.title.bold())
                        .padding(.top, 8)

                    GroupBox(label: Label("Особисті дані", systemImage: "person")) {
                        VStack(alignment: .leading, spacing: 12) {
                            TextField("Ім’я", text: $vm.name)
                                .textFieldStyle(.roundedBorder)
                            TextField("Прізвище", text: $vm.surname)
                                .textFieldStyle(.roundedBorder)
                            TextField("Email", text: $vm.email)
                                .textFieldStyle(.roundedBorder)

                            Stepper("Вік: \(vm.age)", value: $vm.age, in: 10...100)
                            Stepper("Очікуваний досвід тренера: \(vm.expectedTrainerExperience)", value: $vm.expectedTrainerExperience, in: 0...50)
                        }
                    }

                    GroupBox(label: Label("Уподобання", systemImage: "slider.horizontal.3")) {
                        VStack(alignment: .leading, spacing: 12) {
                            TextField("Мови (через кому)", text: $vm.languagesText)
                                .textFieldStyle(.roundedBorder)
                            TextField("Райони (через кому)", text: $vm.districtsText)
                                .textFieldStyle(.roundedBorder)

                            Toggle("Працює з дітьми", isOn: $vm.worksWithChildren)
                            Toggle("Є сертифікати", isOn: $vm.hasCertificates)
                        }
                    }

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

            // Успішне збереження банер
            if showSuccess {
                VStack {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Збережено успішно")
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
