import SwiftUI

struct TrainerListView: View {
    @StateObject private var vm = RecommendationViewModel()
    @AppStorage("currentEmail") private var currentEmail = ""
    private let contactService = ContactService()
    private let service = RealmService()
    
    var body: some View {
        NavigationView {
            List(vm.recommendations) { trainer in
                if let user = service.fetchUser(byEmail: currentEmail) {
                    let contact = contactService.getRequest(
                        userId: user.id.stringValue,
                        trainerId: trainer.id.stringValue
                    )
                    
                    NavigationLink(destination: TrainerDetailView(trainer: trainer, user: user, contact: contact)) {
                        TrainerRowView(trainer: trainer, contact: contact)
                    }
                }
            }
            .searchable(text: $vm.searchText, prompt: "Шукати тренера…")
            .navigationTitle("Тренери")
        }
    }
}
