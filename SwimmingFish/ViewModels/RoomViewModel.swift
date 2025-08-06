//
//  RoomViewModel.swift
//  Swimming Fish
//
//  Created by Matt Cadena on 7/27/25.
//

import Combine
import FirebaseFirestore
import Foundation

class RoomViewModel: ObservableObject {
    @Published var nemoMessage: String = ""
    @Published var squishMessage: String = ""

    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private var isNemoUser = true

    func createRoom(code: String, asNemo: Bool) {
        isNemoUser = asNemo
        db.collection("rooms").document(code).setData([
            "nemoMessage": "hi squish",
            "squishMessage": "hi nemo",
        ])
        listen(to: code)
    }

    func joinRoom(code: String, asNemo: Bool) {
        isNemoUser = asNemo
        listen(to: code)
    }

    public func listen(to code: String) {
        listener?.remove()

        listener = db.collection("rooms")
            .document(code)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("Firestore listener error for room \(code): \(error)")
                    return
                }

                guard let data = snapshot?.data() else {
                    print("No data found for room \(code)")
                    return
                }

                DispatchQueue.main.async {
                    guard let self = self else { return }

                    let nemoMessage = data["nemoMessage"] as? String ?? ""
                    let squishMessage = data["squishMessage"] as? String ?? ""

                    self.nemoMessage = nemoMessage
                    self.squishMessage = squishMessage
                }
            }
    }

    func updateMessage(code: String, nemoMessageUpdate: Bool, message: String) {
        let field = nemoMessageUpdate ? "nemoMessage" : "squishMessage"
        db.collection("rooms")
            .document(code)
            .updateData([field: message])
    }

    public func stopListening() {
        listener?.remove()
        listener = nil
    }
}
