//
//  NameViewController.swift
//  ZiangQiuPlaneWar
//
//  Created by Period Three on 2018-06-07.
//  Copyright © 2018 skylove. All rights reserved.
//

import UIKit

class NameViewController: UIViewController {    
    @IBOutlet weak var nameText: UITextField!
    
     static var name = ""
    // button to show the next view controller
    @IBAction func startAction(_ sender: Any) {
        // pretend to put a nil value which the user do not input anything
        guard nameText.text != nil else {return}
        // test
        print(nameText.text!)
        // perform segue
    
    }
    // send the data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // find the destination
        let send = segue.destination as? GameViewController
        
        
        // send the data
        send?.playerName=self.nameText.text!
        send?.shouldPlay = true
    }
    

}
