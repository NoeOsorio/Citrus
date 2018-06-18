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
import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
   
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var googleButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create facebook button
        let fbLoginButton = FBSDKLoginButton()
        fbLoginButton.delegate = self
        fbLoginButton.frame = CGRect(x: 98, y: 422 + 66, width: 179, height: 42)
        view.addSubview(fbLoginButton)
        
        //Inicializar boton de google
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
        
        //Agregar listener de estado (Si el usuario ya ingreso)
        var handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user != nil{
                //MeasurementHelper.SendLoginEvent()
                //self.performSegue(withIdentifier: "logged", sender: self)
            }
        })
    }
    
    //Facebook sign in
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("Error logging in to facebook /(error)")
            return
        }
        
        print("Ingreso exitosamente con Facebook")
        let credential =  FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("Failed to log in with Facebook /(error)")
            }
            print("Ingreso exitosamente a Firebase con Facebook")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged out of Facebook")
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
