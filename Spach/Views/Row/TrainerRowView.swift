import SwiftUI
import Kingfisher

struct TrainerRowView: View {
    let trainer: Trainer
    let contact: ContactRequest?

    private var contactStatusColor: Color? {
        guard let contact = contact else { return nil }
        if contact.rejected {
            return .red
        } else if contact.userRequested && contact.trainerConfirmed {
            return .green
        } else if contact.userRequested {
            return .yellow
        } else {
            return nil
        }
    }

    private var isContactConfirmed: Bool {
        contact?.userRequested == true && contact?.trainerConfirmed == true
    }

    var body: some View {
        HStack(spacing: 12) {
            // Аватар
            if let data = trainer.avatarData {
                #if os(iOS)
                if let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                #else
                if let nsImage = NSImage(data: data) {
                    Image(nsImage: nsImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                #endif
            } else if let urlString = trainer.avatarURL,
                      let url = URL(string: urlString) {
                KFImage(url)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
                    .clipShape(Circle())
            }

            // Інформація
            VStack(alignment: .leading, spacing: 4) {
                Text(isContactConfirmed ? trainer.email : "— приховано —")
                    .font(.body)
                Text("Рейтинг: \(trainer.rating, specifier: "%.1f")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            // Прапорець
            if let color = contactStatusColor {
                Spacer()
                Image(systemName: "flag.fill")
                    .foregroundColor(color)
            }
        }
        .padding(.vertical, 4)
    }
}
