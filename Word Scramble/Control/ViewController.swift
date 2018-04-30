//
//  ViewController.swift
//  Word Scramble
//
//  Created by sam on 4/28/18.
//  Copyright © 2018 patrick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var wordArray = [String]()
    var usedWords = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }

}

// MARK: setup tableView
extension ViewController:  UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(wordArray[indexPath.row])"
        return cell
    }
}

