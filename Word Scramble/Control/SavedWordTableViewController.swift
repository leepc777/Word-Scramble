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

    //MARK: - Data Manipulation Methods
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("$$$ Error saving context,\(error)")
        }
        tableView.reloadData()
    }
    
    func loadData(with request:NSFetchRequest<ParentWord> = ParentWord.fetchRequest()) {
        do {
            parentWordArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context :\(error)")
        }
        tableView.reloadData()
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")

        
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(editTable)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(playSavedWord))
        ]
        loadData()
    }

    @objc func editTable() {
        tableView.isEditing = !tableView.isEditing
    }

    @objc func playSavedWord() {

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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

