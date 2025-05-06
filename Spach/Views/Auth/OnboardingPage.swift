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
        ZStack {
            // MARK: Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.25), Color.purple.opacity(0.25)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                // MARK: Pages as cards
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                        OnboardingCard(page: page)
                            .tag(index)
                    }
                }
                #if os(iOS)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                #endif
                .frame(maxWidth: 500, maxHeight: 550)

                // MARK: Custom page indicator
                PageIndicator(numberOfPages: pages.count, currentPage: $currentPage)

                // MARK: Controls
                HStack {
                    if currentPage < pages.count - 1 {
                        Button("Пропустити", action: finishOnboarding)
                            .buttonStyle(.plain)

                        Spacer()

                        Button("Далі") {
                            withAnimation { currentPage += 1 }
                        }
                        .buttonStyle(.borderedProminent)
                    } else {
                        Button("Почати", action: finishOnboarding)
                            .buttonStyle(.borderedProminent)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 20)
            }
            .padding(.vertical, 50)
        }
    }

    private func finishOnboarding() {
        hasSeenOnboarding = true
    }
}

struct OnboardingCard: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 24) {
            Image(page.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 280)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 8)

            Text(page.title)
                .font(.title2).fontWeight(.semibold)

            Text(page.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 12, x: 0, y: 6)
    }
}

struct PageIndicator: View {
    let numberOfPages: Int
    @Binding var currentPage: Int

    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<numberOfPages, id: \.self) { idx in
                Circle()
                    .fill(idx == currentPage ? Color.accentColor : Color.gray.opacity(0.5))
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.vertical, 12)
    }
}

#if DEBUG
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .frame(width: 600, height: 700)
    }
}
#endif
