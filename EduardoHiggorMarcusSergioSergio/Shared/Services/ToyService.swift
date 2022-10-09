//
//  ToyService.swift
//  EduardoHiggorMarcusSergioSergio
//
//  Created by Eduardo Silva on 09/10/22.
//

import FirebaseFirestore
import Foundation

final class ToyService {
    let database = Firestore.firestore()
    
    func loadToys(onComplete: (Result<[Toy], Error>) -> Void) {
        let dbRef = database.collection("posfiap")
        dbRef.getDocuments { snapshot, error in
            guard let data = snapshot?.documents, error == nil else {
                return
            }
            
            do{
                let toys = try JSONDecoder().decode([Toy], from: data)
            }
            print(data)
        }
    }
    
    func insertToy(toy: Toy) {
        
    }
    
    func deleteToy() {
        
    }
    
    func updateToy() {
        
    }
    
    func saveData(toy: Toy) {
        let docRef = database.document("posfiap/toys")
        docRef.setData(["name": toy.name, "phone": toy.phoneNumber])
    }
    
    func updateData(toy: Toy) {
        database.collection("posfiap")
            .whereField("id", isEqualTo: toy._id!)
            .getDocuments() { (querySnapshot, err) in
                if let _ = err {
                    print("Erro no update")
                    return
                } else {
                    guard let querySnapshot = querySnapshot else {
                        print("Registro não encnotrado")
                        return
                    }
                    let document = querySnapshot.documents.first
                    document!.reference.updateData([
                        "name": toy.name, "phone": toy.phoneNumber
                    ])
                }
            }
    }
}
