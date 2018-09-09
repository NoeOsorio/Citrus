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
    
    var userInfoBuffer = userInfo
    
    var preguntas: [String] = ["¿Qué edad tienes?",
                               "¿Cual es tu materia favorita? \n Explica la razón",
                               "¿Que materia te gusta menos? \n Explica la razón"]
    var preguntaActual: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pregunta.layer.cornerRadius = 15
        respuesta.layer.cornerRadius = 15
        
        
        
        preguntaActual = userInfo.contextQuestion
        if(preguntaActual == 0){
            atrasBtn.isHidden = true
        }
        setQuestion()
        
    }

    @IBAction func cancelar(_ sender: Any) {
        
    }
    @IBAction func atras(_ sender: Any) {
        ant()
    }
    @IBAction func siguiente(_ sender: Any) {
        sig()
    }
    
    func setQuestion(){
        self.pregunta.text = preguntas[preguntaActual]
    }
    
    
    func getAnswer(){
        userInfo.setContextQuestion(self.preguntaActual)
        let txt = self.respuesta.text!
        userInfo.addSubText(txt, preguntaActual)
        print(userInfo.subPersonality[preguntaActual])
        
        self.respuesta.text.removeAll()
    }
    
    func sig(){
        getAnswer()
        
        if(preguntaActual >= preguntas.count - 1){
            print(userInfo.getPersonality())
            userInfo.setFisrtTime(false)
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
