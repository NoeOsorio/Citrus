//
//  LoginViewController.swift
//  Citrus
//
//  Created by Mau on 6/13/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var googleButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    //email sign in
    @IBAction func didTouchLoginButton(_ sender: UIButton) {
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
                if user != nil {
                    self.performSegue(withIdentifier: "logged", sender: self)
                }
                    
                else {
                    print(error?.localizedDescription)
                }
            })
    }
    
    @IBAction func didTouchSignUpButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "register", sender: self)
    }
}
