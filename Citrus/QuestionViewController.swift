//
//  QuestionViewController.swift
//  EduTest
//
//  Created by Mau on 6/9/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func flipButton(withButton button: UIButton) {
        UIView.transition(with: button, duration: 0.3, options: .transitionFlipFromBottom, animations: nil, completion: nil)
    }
    
    @IBAction func buttonOnTouch(_ sender: UIButton) {
        flipButton(withButton: sender)
        
    }
    
    
}
