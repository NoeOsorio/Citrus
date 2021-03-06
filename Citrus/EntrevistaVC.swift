//
//  EntrevistaVC.swift
//  Citrus
//
//  Created by Noe Osorio on 09/09/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//

import UIKit

class EntrevistaVC: UIViewController {

    @IBOutlet var pregunta: UITextView!
    @IBOutlet var respuesta: UITextView!
    @IBOutlet var atrasBtn: UIButton!
    @IBOutlet var siguienteBtn: UIButton!
    
    var infoBuffer = info
    
    var preguntas: [String] = ["¿Qué edad tienes?",
                               "¿Cual es tu materia favorita? \n Explica la razón",
                               "¿Que materia te gusta menos? \n Explica la razón"]
    var preguntaActual: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        pregunta.layer.cornerRadius = 15
        respuesta.layer.cornerRadius = 15
        let defaultInfoData = (UserDefaults.standard.value(forKey: "userID") as? String)
        if defaultInfoData == nil{
            info.setUser()
            info.setUserData()
            info.setPersonality("")
            userInfo.setUser(info)
            info.uploadUserData()
            info.saveDefault()
        }
        preguntaActual = info.contextQuestion
        if(preguntaActual == 0){
            atrasBtn.isHidden = true
        }
        setQuestion()
    }

    @IBAction func cancelar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func atras(_ sender: Any) {
        ant()
    }
    @IBAction func siguiente(_ sender: Any) {
        sig()
    }
    
    @IBAction func ok(_ sender: Any) {
        getAnswer()
        info.setPersonality()
        info.updatePersonality()
        performSegue(withIdentifier: "inicio", sender: self)
    }
    @IBAction func Avanzado(_ sender: Any) {
        performSegue(withIdentifier: "avanzado", sender: self)
    }
    
    func setQuestion(){
        self.pregunta.text = preguntas[preguntaActual]
    }
    
    
    func getAnswer(){
        info.setContextQuestion(self.preguntaActual)
        let txt = self.respuesta.text!
        info.addSubText(txt, preguntaActual)
        print(info.subPersonality[preguntaActual])
        
        self.respuesta.text.removeAll()
    }
    
    func sig(){
        getAnswer()
        
        if(preguntaActual >= preguntas.count - 1){
            print(info.getPersonality())
            info.setPersonality()
            info.updatePersonality()
            performSegue(withIdentifier: "inicio", sender: self)
            
        }
        else{
            preguntaActual = preguntaActual + 1
            atrasBtn.isHidden = false
            setQuestion()
        }
        
    }
    func ant(){
        
        preguntaActual = preguntaActual - 1
        setQuestion()
        if(preguntaActual <= 0){
            atrasBtn.isHidden = true
        }
        
    }
    
    
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


