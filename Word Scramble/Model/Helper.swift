//
//  Helper.swift
//  Word Scramble
//
//  Created by sam on 5/4/18.
//  Copyright © 2018 patrick. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    //Mark: - SHow message through Alert
    static func showMessage(title:String,message:String,view:UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        //Cancel Button
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (actionHandler) in
            alert.dismiss(animated: true, completion: nil)
        }))
        view.present(alert, animated: true, completion: nil)
    }
    
    static func setActIndicator(stop:Bool,vc:UIViewController,activityIndicator:UIActivityIndicatorView) {
        
        //MARK: - set up indicator
        activityIndicator.center = vc.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        
        if stop {
            
            //stop indicator after view appear
            print("&&&&&&& stop activity Indicator in callAlert()")
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
        } else {
            print("&&&&&&& Start activity Indicator in callAlert()")
            vc.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
        }
    }
    
    // Parse JSON data
    
    static func parseJSON (data:Data,view:UIViewController) -> [String:AnyObject] {
        let parsedResult: [String:AnyObject]!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
        } catch {
            
            showMessage(title: "Error", message: "$$$  Could not parse the data as JSON: '\(data)'", view: view)
            return [:]
        }
        return parsedResult
    }
    
    //Chcek word in Apple dictionary
    
    static func checkDic(word:String,vc:UIViewController,ai: UIActivityIndicatorView) {
        
                let ai = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
                Helper.setActIndicator(stop: false, vc: vc, activityIndicator: ai)
                let dictionVC = UIReferenceLibraryViewController(term: word) // passs word to built-in libary.
                vc.present(dictionVC, animated: true, completion: {Helper.setActIndicator(stop: true, vc: vc, activityIndicator: ai)})
        }

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func saveData() {
        do {
            try context.save()
        } catch {
            print("$$$ Error saving context,\(error)")
        }
    }
    
    static func makeNaviButton(imageName:String,target:UIViewController,action:Selector) -> UIBarButtonItem {
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage (named: imageName), for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        button.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem

    }

}
