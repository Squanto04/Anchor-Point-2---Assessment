//
//  ShoppingListTableViewController.swift
//  ShoppingList
//
//  Created by Jordan Lamb on 9/27/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListTableViewController: UITableViewController, ButtonTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        ShoppingController.shared.fetchResultsController.delegate = self
    }
    
    // MARK: - Actions
    @IBAction func addNewItemButtonTapped(_ sender: Any) {
        setUpAlertController()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ShoppingController.shared.fetchResultsController.sectionIndexTitles[section] == "0" ? "Not Purchased" : "Purchased"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ShoppingController.shared.fetchResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShoppingController.shared.fetchResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingListCell", for: indexPath) as? ButtonTableViewCell
        let shopping = ShoppingController.shared.fetchResultsController.object(at: indexPath)
        cell?.delegate = self
        cell?.update(shopping: shopping)
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let shopping = ShoppingController.shared.fetchResultsController.object(at: indexPath)
            ShoppingController.shared.deleteItem(shopping: shopping)
        }
    }
    
    // MARK: - Custom Button
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        let shopping = ShoppingController.shared.fetchResultsController.object(at: indexPath)
        ShoppingController.shared.toggleIsPurchased(shopping: shopping)
        sender.update(shopping: shopping)
    }
    
    // MARK: - Alert Controller
    func setUpAlertController() {
        var newItemTextField: UITextField?
        let alert = UIAlertController(title: "Add Item", message: "Please add an item to your shopping list", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "New Item"
            newItemTextField = textField
        }
        let addItemAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let newItemName = newItemTextField?.text,
                !newItemName.isEmpty
                else { return }
            ShoppingController.shared.createItem(itemWithName: newItemName)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.tableView.reloadData()
        }
        alert.addAction(cancelAction)
        alert.addAction(addItemAction)
        present(alert, animated: true, completion: nil)
    }
    
} // End of Class


extension ShoppingListTableViewController: NSFetchedResultsControllerDelegate {
    // Conform to the NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    //sets behavior for cells
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {return}
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
            
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default: return
        }
    }
}

