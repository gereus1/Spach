import SwiftUI
import RealmSwift

struct EditTrainerProfileView: View {
    @ObservedObject var vm: EditTrainerProfileViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var refreshTrigger: Bool

    @State private var showSuccess = false
    @Namespace private var animation
    @State private var selectedImage: NSImage? = nil
    @State private var showImagePicker = false

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

                    VStack(spacing: 8) {
                        if let selectedImage {
                            Image(nsImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        } else if let data = vm.avatarData,
                                  let nsImage = NSImage(data: data) {
                            Image(nsImage: nsImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray.opacity(0.5))
                        }

                        Button("Оновити фото") {
                            showImagePicker = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .fileImporter(
                        isPresented: $showImagePicker,
                        allowedContentTypes: [.image],
                        allowsMultipleSelection: false
                    ) { result in
                        guard let url = try? result.get().first,
                              let nsImage = NSImage(contentsOf: url) else { return }

                        selectedImage = nsImage
                        vm.avatarData = nsImage.tiffRepresentation
                    }

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

                        }
                    }

                    GroupBox(label: Label("Послуги", systemImage: "globe")) {
                        VStack(alignment: .leading, spacing: 12) {
                            TextField("Мови (через кому)", text: $vm.languagesText)
                                .textFieldStyle(.roundedBorder)
                            TextField("Райони (через кому)", text: $vm.districtsText)
                                .textFieldStyle(.roundedBorder)
                            TextField("Категорії (через кому)", text: $vm.categoriesText)
                                .textFieldStyle(.roundedBorder)

                            Toggle("Працює з дітьми", isOn: $vm.worksWithChildren)
                            Toggle("Є сертифікати", isOn: $vm.hasCertificates)
                        }
                    }

                    Button(action: {
                        vm.saveChanges()
                        selectedImage = nil
                        refreshTrigger.toggle()

                        withAnimation(.easeInOut(duration: 0.3)) {
                            showSuccess = true
                        }

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
        .onAppear {
            if selectedImage == nil, let data = vm.avatarData {
                selectedImage = NSImage(data: data)
            }
        }
    }
}

