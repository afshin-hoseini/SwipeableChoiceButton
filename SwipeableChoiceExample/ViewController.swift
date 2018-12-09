//
//  ViewController.swift
//  SwipeableChoiceExample
//
//  Created by Afshin Hoseini on 12/3/18.
//  Copyright © 2018 Afshin Hoseini. All rights reserved.
//

import UIKit
import SwipeableChoiceButton

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func onSwitched(_ sender: UISwipeableChoiceButton) {
        
        if sender.selectedChoice == .none {
            
            
        }
        else {
            
            DispatchQueue.main.async {
                sender.isLoading = true
            }
            
        }
    }
}

