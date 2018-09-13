//
//  PersonalidadVC.swift
//  Citrus
//
//  Created by Noe Osorio on 12/09/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//

import UIKit

class PersonalidadVC: UIViewController {

    @IBOutlet var pregunta: UITextView!
    @IBOutlet var respuesta: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func ok(_ sender: Any) {
        getAnswer()
        info.updatePersonality()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getAnswer(){
        let txt = self.respuesta.text!
        info.updatePersonalityString(txt)
        
        self.respuesta.text.removeAll()
        self.dismissKeyboard()
    }
    

}
