//
//  CuentoVC.swift
//  Citrus
//
//  Created by Mau on 7/12/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//

import UIKit

class CuentoVC: UIViewController {

    var counter: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(counter)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "unwindToTip") {
            let TipVC = (segue.destination as! TipVC)
            TipVC.counter = counter
        }
    }
    
    @IBAction func didTouchNextButton(_ sender: UIButton) {
        if(counter < 3) {
            counter = counter + 1
            performSegue(withIdentifier: "unwindToTip", sender: self)
        }
        else {
            //show full project
        }
    }
    
}
