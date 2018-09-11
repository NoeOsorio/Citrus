//
//  WatsonVC.swift
//  Citrus
//
//  Created by Noe Osorio on 11/09/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//

import UIKit

class WatsonVC: UIViewController {

    @IBOutlet var muteBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (UserDefaults.standard.value(forKey: "mute") as? Bool)!{
            self.muteBtn.isSelected = true
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func mute(_ sender: Any) {
        if self.muteBtn.isSelected{
            self.muteBtn.isSelected = false
            UserDefaults.standard.set(false, forKey: "mute")
        }
        else{
            self.muteBtn.isSelected = true
            UserDefaults.standard.set(true, forKey: "mute")
        }
    }
    
}
