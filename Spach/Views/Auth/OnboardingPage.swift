import SwiftUI

/// Модель однієї сторінки onboarding
struct OnboardingPage: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
}

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0

    private let pages: [OnboardingPage] = [
        .init(imageName: "onboarding1",
              title: "Ласкаво просимо",
              description: "Відкрийте для себе кращих тренерів поруч з вами."),
        .init(imageName: "onboarding2",
              title: "Персоналізовані рекомендації",
              description: "Отримуйте список тренерів, відсортований за вашими критеріями."),
        .init(imageName: "onboarding3",
              title: "Бронюйте заняття",
              description: "Легко заплануйте першу сесію прямо в застосунку.")
    ]

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                    VStack(spacing: 24) {
                        Image(page.imageName)
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)

                        Text(page.title)
                            .font(.title)
                            .bold()
                        Text(page.description)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .tag(index)
                }
            }
            #if os(iOS)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            #endif

            Spacer()

            HStack {
                if currentPage < pages.count - 1 {
                    Button("Пропустити") {
                        finishOnboarding()
                    }
                    Spacer()
                    Button("Далі") {
                        withAnimation {
                            currentPage += 1
                        }
                    }
                } else {
                    Button("Почати") {
                        finishOnboarding()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
        }
    }

    private func finishOnboarding() {
        hasSeenOnboarding = true
    }
}

#if DEBUG
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
#endif
