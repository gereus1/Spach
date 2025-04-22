import SwiftUI
import Kingfisher

struct TrainerRowView: View {
  let trainer: Trainer

  var body: some View {
    HStack(spacing: 12) {
      if let urlString = trainer.avatarURL,
         let url = URL(string: urlString) {
        KFImage(url)
          .resizable()
          .frame(width: 40, height: 40)
          .clipShape(Circle())
      } else {
        // Локальний плейсхолдер
        Image(systemName: "person.circle.fill")
          .resizable()
          .frame(width: 40, height: 40)
          .foregroundColor(.gray)
      }

      VStack(alignment: .leading, spacing: 4) {
        Text(trainer.email)
          .font(.body)
        Text("Рейтинг: \(trainer.rating, specifier: "%.1f")")
          .font(.subheadline)
          .foregroundColor(.gray)
      }
    }
    .padding(.vertical, 4)
  }
}
