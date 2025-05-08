import RealmSwift

class ContactService {
    private let realm = try! Realm()

    func createRequest(fromUser userId: String, toTrainer trainerId: String) {
        if let existing = realm.objects(ContactRequest.self)
            .filter("userId == %@ AND trainerId == %@", userId, trainerId).first {
            try! realm.write {
                existing.userRequested = true
            }
        } else {
            let request = ContactRequest()
            request.userId = userId
            request.trainerId = trainerId
            request.userRequested = true
            request.trainerConfirmed = false
            try! realm.write {
                realm.add(request)
            }
        }
    }

    func confirmRequest(byTrainer trainerId: String, forUser userId: String) {
        if let request = realm.objects(ContactRequest.self)
            .filter("trainerId == %@ AND userId == %@", trainerId, userId).first {
            try! realm.write {
                request.trainerConfirmed = true
            }
        }
    }
    
    func rejectRequest(userId: String, trainerId: String) {
        if let request = realm.objects(ContactRequest.self)
            .filter("userId == %@ AND trainerId == %@", userId, trainerId).first {
            try! realm.write {
                request.userRequested = false
                request.trainerConfirmed = false
                request.rejected = true
            }
        }
    }

    func getRequestsForTrainer(_ trainerId: String) -> [ContactRequest] {
        return Array(realm.objects(ContactRequest.self)
            .filter("trainerId == %@", trainerId))
    }

    func getRequest(userId: String, trainerId: String) -> ContactRequest? {
        return realm.objects(ContactRequest.self)
            .filter("userId == %@ AND trainerId == %@", userId, trainerId)
            .first
    }
}
