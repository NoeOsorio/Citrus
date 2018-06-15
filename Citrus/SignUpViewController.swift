//
//  SignUpViewController.swift
//  Citrus
//
//  Created by Mau on 6/13/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPassField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func didTouchRegisterButton(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "logged", sender: self)
            }
            else {
                print(error?.localizedDescription)
            }
        }
    }
}
