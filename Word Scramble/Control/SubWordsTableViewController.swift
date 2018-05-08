//
//  SubWordsTableViewController.swift
//  Word Scramble
//
//  Created by sam on 5/4/18.
//  Copyright © 2018 patrick. All rights reserved.
//

import UIKit
import CoreData

class SubWordsTableViewController: UITableViewController {
    
    var subWordArray = [SubWord]()
    var arrayTableView = [String]() // this is the one for View Table Data Source
    
    var selectedParentWord : ParentWord! {
        
        didSet{
            loadSubWords()
        }
        
    }

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    //  Load Core Data
    func loadSubWords(with request:NSFetchRequest<SubWord> = SubWord.fetchRequest(), predicate:NSPredicate?=nil) {
        
        
        let ParentWordPredicate = NSPredicate(format: "parent == %@", selectedParentWord!)
        
        
        
        //optional binding to handle nil at predicate
        if let predicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [ParentWordPredicate,predicate])
        }
        else {
            request.predicate = ParentWordPredicate
        }
        
        do {
            arrayTableView.removeAll()
            subWordArray = try context.fetch(request)
            //sort a custom array.
            subWordArray = subWordArray.sorted{$0.name!<$1.name! }

            for word in subWordArray {
                arrayTableView.append(word.name!)
            }
            arrayTableView.insert(selectedParentWord.name!, at: 0)
            print("%%% new array is \(arrayTableView)")
        } catch {
            print("Error fetching data from context :\(error)")
        }
        
        tableView.reloadData()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        loadSubWords()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(playSavedWord))
    }


    @objc func playSavedWord() {
        DataModel.savedWords = arrayTableView
        navigationController?.popToRootViewController(animated: true)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return subWordArray.count
        return arrayTableView.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubWordCell", for: indexPath)

//        cell.textLabel?.text = subWordArray[indexPath.row].name
        cell.textLabel?.text = arrayTableView[indexPath.row]
        return cell
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("&&&   didSelectRowAt indexPath",indexPath)
        if let cell = tableView.cellForRow(at: indexPath) {
            if let word = cell.textLabel?.text {
                print("&&& you tap the word:",word)
                let ai = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
                Helper.setActIndicator(stop: false, vc: self, activityIndicator: ai)
                let dictionVC = UIReferenceLibraryViewController(term: word) // passs word to built-in libary.
                self.present(dictionVC, animated: true, completion: {Helper.setActIndicator(stop: true, vc: self, activityIndicator: ai)})
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(subWordArray[indexPath.row-1])
            arrayTableView.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            
        }
    }

}
