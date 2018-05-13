//
//  SavedWordTableViewController.swift
//  Word Scramble
//
//  Created by sam on 5/4/18.
//  Copyright © 2018 patrick. All rights reserved.
//

import UIKit
import CoreData

class SavedWordTableViewController: UITableViewController {

    
    let dateFormatter = DateFormatter()

    var parentWordArray = [ParentWord]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    @IBOutlet weak var searchWordBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchWordBar.delegate = self
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")

        loadData()
    }
}


    // MARK: - Table View DataSource
extension SavedWordTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parentWordArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        let word = parentWordArray[indexPath.row]
        cell.textLabel?.text = word.name
        cell.detailTextLabel?.text = "Score: \(word.score) --  \(dateFormatter.string(from: word.date!))"
//        print("***  date. :",word.date!.description,dateFormatter.string(from: word.date!))
        return cell
    }

    // MARK: - Table View delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SubWords") as! SubWordsTableViewController
        vc.selectedParentWord = parentWordArray[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
                if editingStyle == .delete {
            context.delete(parentWordArray[indexPath.row]) // delete it from context and store first
            parentWordArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        }
    }
    
}

//MARK: - Core Data Manipulation methods
extension SavedWordTableViewController {
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("$$$ Error saving context,\(error)")
        }
        tableView.reloadData()
    }
    
//    func loadData(with request:NSFetchRequest<ParentWord> = ParentWord.fetchRequest()) {
//
//
//        do {
//            parentWordArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context :\(error)")
//        }
//        tableView.reloadData()
//    }
    
    
    func loadData(with request:NSFetchRequest<ParentWord> = ParentWord.fetchRequest(),predicate:NSPredicate?=nil) {
        
        if let predicate = predicate {
            request.predicate = predicate
        } else {
            let sortDate = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [sortDate]
        }
        
        do {
            parentWordArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context :\(error)")
        }
            tableView.reloadData()
            return
        
    }


}


// MARK- Search Bar Delegate Optioanl methods
extension SavedWordTableViewController: UISearchBarDelegate {
    
    
    // This optional searchBarSearchButtonClicked got triggered when taping search button. If it is empty(user didn't key in any), searchBar and keyboard will be dismissed by tapping search key on keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("@@@ searchBarSearchButtonClicked got triggered")
        if searchBar.text == "" {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                self.loadData()
            }
        }
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                print("@@@ serachBar textDidChange func got call and text is\(searchBar.text)")
        //        if searchBar.text?.count == 0 {
        if searchBar.text == "" {
            
            loadData() //restore to the original table vew
            
            DispatchQueue.main.async { //
                searchBar.resignFirstResponder()
            }
            
        }
        else {
            let request : NSFetchRequest<ParentWord> = ParentWord.fetchRequest()
            let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            print("!!! textDidChange got call and request is \(request)")
            
            loadData(with: request, predicate:predicate)
            
        }
        
    }

}
