import SwiftUI
import Kingfisher

struct ClientRowView: View {
    let user: User
    let request: ContactRequest

    private var statusColor: Color {
        if request.rejected { return .red }
        if request.trainerConfirmed { return .green }
        return .yellow
    }

    private var statusIcon: String {
        if request.rejected { return "xmark.circle.fill" }
        if request.trainerConfirmed { return "checkmark.circle.fill" }
        return "clock.fill"
    }

    var body: some View {
        HStack(spacing: 16) {
            // АВАТАР
            // АВАТАР
            Group {
                if let data = user.avatarData {
                    #if os(iOS)
                    if let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                    }
                    #else
                    if let nsImage = NSImage(data: data) {
                        Image(nsImage: nsImage)
                            .resizable()
                            .scaledToFill()
                    }
                    #endif
                } else if let urlString = user.avatarURL,
                          let url = URL(string: urlString) {
                    KFImage(url)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(.gray.opacity(0.4))
                }
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .shadow(radius: 2)

            // Інфо
            VStack(alignment: .leading, spacing: 4) {
                if !user.name.isEmpty {
                    Text(user.name)
                        .font(.headline)
                }
                Text("Очікує досвід: \(user.expectedTrainerExperience) р.")
                    .font(.subheadline)
                Text("Вік: \(user.age)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            // Статус
            Image(systemName: statusIcon)
                .foregroundColor(statusColor)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.windowBackgroundColor))
                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
        )
    }
}
