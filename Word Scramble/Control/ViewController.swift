//
//  ViewController.swift
//  Word Scramble
//
//  Created by sam on 4/28/18.
//  Copyright © 2018 patrick. All rights reserved.
//

import UIKit
import GameKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var wordArray = [String]()
    var usedWords = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        //MARK: convert start.txt to wordArray an array of string
        guard let path = Bundle.main.path(forResource: "start", ofType: "txt") else {
            print("$$ can't find the start.txt")
            return
        }
        print("$$ path to the start.text is :\(path) ")
        
        guard let words = try? String(contentsOfFile: path) else {
            wordArray = ["Can't Load Find Start.Txt"]
            return
        }
        print("$$ words contains:\(words)")
        wordArray = words.components(separatedBy: "\n")
        print("$$ wordArray is : \(wordArray)")
        
        startGame()
    }
    
    func startGame() {
        wordArray = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: wordArray) as! [String]
        title = wordArray[0]
        usedWords.removeAll()
//        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
        
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter Answer", message: "Please", preferredStyle: .alert)
        ac.addTextField()
        
        
        let action = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] (alertaction) in
            print("printing inside UIAlerAciton's closure.", alertaction)
            let answer = ac.textFields![0] //ac does have TextField we just added.
            //seems like textFields[0].text is "" not NIL even we don't key in any on the textFields.
            print("$$ textFields![0] has :",answer)
            self.submit(answer: answer.text!)
        }
        let submitAction = UIAlertAction(title: "Submit2", style: .default) { _ in
            let answer = ac.textFields![0]
            print("$$ textFields![0] has :",answer)

            self.submit(answer: answer.text!)
        }
        
        ac.addAction(submitAction)
        ac.addAction(action)
        present(ac, animated: true, completion: nil)

    }
    
    func submit(answer: String) {
        print("$$ answer is \(answer)",type(of: answer))
    }

}

// MARK:  TableView Delegate
extension ViewController:  UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(wordArray[indexPath.row])"
        return cell
    }
}

