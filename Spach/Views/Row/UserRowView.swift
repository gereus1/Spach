import SwiftUI

struct UserRowView: View {
    let user: User

    var body: some View {
        HStack(spacing: 12) {
            // 1. Локальний аватар
            if let data = user.avatarData {
                #if os(iOS)
                if let ui = UIImage(data: data) {
                    Image(uiImage: ui)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                #else
                if let ns = NSImage(data: data) {
                    Image(nsImage: ns)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                #endif
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
                    .clipShape(Circle())
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(user.email)
                    .font(.body)
                Text("Досвід: \(user.expectedTrainerExperience) р.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}
