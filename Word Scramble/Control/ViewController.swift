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
//        print("$$ path to the start.text is :\(path) ")
        
        guard let words = try? String(contentsOfFile: path) else {
            wordArray = ["Can't Load Find Start.Txt"]
            return
        }
//        print("$$ words contains:\(words)")
        wordArray = words.components(separatedBy: "\n")
//        print("$$ wordArray is : \(wordArray)")
        
        startGame()
    }
    
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter Answer", message: "Please", preferredStyle: .alert)
        ac.addTextField()
        
        
        let action = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] (alertaction) in
//            print("### printing inside UIAlerAciton's closure.", alertaction)
            let answer = ac.textFields![0] //ac does have TextField we just added.
            //seems like textFields[0].text is "" not NIL even we don't key in any on the textFields.
//            print("$$ textFields![0] has :",answer)
            self.submit(answer: answer.text!)
        }
//        let submitAction = UIAlertAction(title: "Submit2", style: .default) { _ in
//            let answer = ac.textFields![0]
//            print("$$ textFields![0] has :",answer)
//
//            self.submit(answer: answer.text!)
//        }
//
//        ac.addAction(submitAction)
        ac.addAction(action)
        present(ac, animated: true, completion: nil)

    }
    
}

// MARK: Game Functions

extension ViewController {
    
    func startGame() {
        wordArray = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: wordArray) as! [String]
        title = wordArray[0]
        usedWords.removeAll()
        //        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
        
    }

    func submit(answer: String) {
        
        
        print("$$ answer is \(answer)",type(of: answer))
        let lowerAnswer = answer.lowercased()
        let errorTitle:String
        let errorMessage:String
        
        if isPossible(word: lowerAnswer)  {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(lowerAnswer, at: 0) //put the new at index 0
                    print("@@ userWords:\(usedWords)")
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                    
                    return //exit the submit method.
                    
                } else {
                    
                    errorTitle = "Word not recognized"
                    errorMessage = "you can just make them up, you know!"
                    
                }
                
            } else {
                errorTitle = "Word userd already"
                errorMessage = "try another word!"
            }
        } else {
            
            errorTitle = "ONLY letters in \(title!.lowercased())"
            errorMessage = "You can't spell that word from \(title!.lowercased())"
        }
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
        
    }
    

    
    // the word that user input has to be from the word we random pickup as the one at title
    // and every characters in the title can be only used once to assemble the new word
    func isPossible(word:String)->Bool {
        var question = title!.lowercased()
        for c in word {
            if let indexOfC = question.index(of: c) {
                question.remove(at: indexOfC)
                print("$$ Title has this character:\(c)")
            } else {
                print("$$ Title doesn't have this character:\(c)")
                return false
            }
        }
        
//        for c in word {
//            if let position = question.range(of: String(c)) {
//                question.remove(at: position.lowerBound)
//            } else {
//                return false
//            }
//        }
        return true
    }
    
    // check if user keyin the repeated word.
    // return true when usedWords array doesn't contain word
    func isOriginal(word:String)->Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word:String)->Bool {
        
        let spellChecker = UITextChecker()

        let range = NSMakeRange(0, word.utf16.count)
        let misspelledRange = spellChecker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        //NO misspelling found will set both .location and NSNotfFound to 0
        print("$$$ spelling check :",misspelledRange.location,type(of: misspelledRange.location),NSNotFound,type(of: NSNotFound))
        return misspelledRange.location == NSNotFound

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
        cell.textLabel?.text = "\(usedWords[indexPath.row])"
        return cell
    }
}

