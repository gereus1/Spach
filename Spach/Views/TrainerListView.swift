import SwiftUI

struct TrainerListView: View {
  @StateObject private var vm = TrainerListViewModel()

  var body: some View {
    NavigationView {
      List(vm.trainers) { trainer in
        NavigationLink(destination: TrainerDetailView(trainer: trainer)) {
          TrainerRowView(trainer: trainer)
        }
      }
      .searchable(text: $vm.searchText, prompt: "Шукати тренера…")
      .navigationTitle("Тренери")
    }
  }
}
