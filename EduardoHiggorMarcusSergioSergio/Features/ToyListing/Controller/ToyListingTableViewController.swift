//
//  ToyListingTableViewController.swift
//  EduardoHiggorMarcusSergioSergio
//
//  Created by Eduardo Silva on 09/10/22.
//

import UIKit

class ToyListingTableViewController: UITableViewController {
    
    private func loadToys() {
        do {
            try ToyService.loadToys(<#T##self: ToyService##ToyService#>)
        } catch {
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ProblemVisualizationViewController,
              let indexPath = tableView.indexPathForSelectedRow else { return }
        
        vc.problem = fetchedResultsController.object(at: indexPath)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ProblemTableViewCell else {
            return UITableViewCell()
        }

        let problem = fetchedResultsController.object(at: indexPath)
        cell.configure(with: problem)

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let movie = fetchedResultsController.object(at: indexPath)
            context.delete(movie)
            try? context.save()
        }
    }

}
