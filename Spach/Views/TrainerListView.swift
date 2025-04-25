// Views/List/TrainerListView.swift

import SwiftUI

struct TrainerListView: View {
    @StateObject private var vm = TrainerListViewModel()

    var body: some View {
        NavigationView {
            List(vm.filteredTrainers) { trainer in          // <- юзаємо filteredTrainers
                NavigationLink(destination: TrainerDetailView(trainer: trainer)) {
                    TrainerRowView(trainer: trainer)
                }
            }
            .searchable(text: $vm.searchText, prompt: "Шукати тренера…")  // <- биндинг до searchText
            .navigationTitle("Тренери")
        }
    }
}
