import FirebaseFirestore

class TeamHandling {
    private let db = Firestore.firestore()

    func createTeam(team: DragonBoatTeam, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("teams").document(team.id).setData([
            "id": team.id,
            "crewname": team.crewname,
            "coachname": team.coachname,
            "members": team.members
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func joinTeam(teamId: String, userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let teamRef = db.collection("teams").document(teamId)
        
        teamRef.updateData([
            "members": FieldValue.arrayUnion([userId])
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
