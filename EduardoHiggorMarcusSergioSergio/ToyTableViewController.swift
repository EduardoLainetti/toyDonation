//
//  ToyTableViewController.swift
//  EduardoHiggorMarcusSergioSergio
//
//  Created by Eduardo Silva on 09/10/22.
//

import FirebaseFirestore
import UIKit

final class ToyTableViewController: UITableViewController {
    
    let collection = "posfiap"
    var toysList: [Toy] = []
    
    private lazy var firestore: Firestore = {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        
        let firestore = Firestore.firestore()
        firestore.settings = settings
        return firestore
    }()
    var firestoreListener: ListenerRegistration!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadToysList()
    }
    
    private func loadToysList() {
        firestoreListener = firestore
                            .collection(collection)
                            .order(by: "name", descending: false)
                            .addSnapshotListener(includeMetadataChanges: true, listener: { snapshot, error in
                                if let error = error {
                                    print(error)
                                } else {
                                    guard let snapshot = snapshot else { return }
                                    if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0 {
                                        self.showItemsFrom(snapshot: snapshot)
                                    }
                                }
                            })
    }
    
    private func showItemsFrom(snapshot: QuerySnapshot) {
        toysList.removeAll()
        for document in snapshot.documents {
            let id = document.documentID
            let data = document.data()
            let name = data["name"] as? String ?? "---"
            let phone = data["phone"] as? Int ?? 0
            let toy = Toy(id: id, name: name, phone: phone)
            toysList.append(toy)
        }
        tableView.reloadData()
    }
    
    private func showAlertForItem(_ item: Toy?) {
        let alert = UIAlertController(title: "Brinquedo", message: "Entre com as informações do brinquedo para doação", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Nome"
            textField.text = item?.name
        }
        alert.addTextField { textField in
            textField.placeholder = "Telefone"
            textField.keyboardType = .numberPad
            textField.text = item?.phone.description
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            guard let name = alert.textFields?.first?.text,
                  let phoneText = alert.textFields?.last?.text,
                  let phone = Int(phoneText)
            else {return}
            
            let data: [String: Any] = [
                "name": name,
                "phone": phone
            ]
            
            if let item = item {
                //Edição
                self.firestore.collection(self.collection).document(item.id).updateData(data)
            } else {
                //Criação
                self.firestore.collection(self.collection).addDocument(data: data)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        toysList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let toy = toysList[indexPath.row]
        cell.textLabel?.text = toy.name
        cell.detailTextLabel?.text = "\(toy.phone)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toy = toysList[indexPath.row]
        showAlertForItem(toy)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toy = toysList[indexPath.row]
            firestore.collection(collection).document(toy.id).delete()
        }
    }
    
    
    @IBAction func addItem(_ sender: Any) {
        showAlertForItem(nil)
    }
}
