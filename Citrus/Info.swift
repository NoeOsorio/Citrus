//
//  Info.swift
//  Citrus
//
//  Created by Noe Osorio on 04/08/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//

import Foundation
import FirebaseAuth

var info:Info = Info()

struct Info {
    var materia:String
    var tipo:String?
    var curso:String?
    var proyecto:String?
    var clase:String?
    
    init(){
        self.materia = "Materia"

    }
    
    init(materia:String){
        self.materia = materia
    }
    
    mutating func setMateria(materia:String){
        self.materia = materia
    }
    mutating func setTipo(tipo:String){
        self.tipo = tipo
    }
    mutating func setCurso(curso:String){
        self.curso = curso
    }
    mutating func setProyecto(proyecto:String){
        self.proyecto = proyecto
    }
    mutating func setClase(clase:String){
        self.clase = clase
    }
    
    mutating func getUser() -> User{
        var currentUser:User?
        
        //_ = Auth.auth().addStateDidChangeListener({ (auth, user) in
            currentUser = Auth.auth().currentUser
        //})
        
        if(currentUser != nil) {
            print("Current user: \(String(describing: currentUser))")
        }
        else{
            print("Error: No user signed in")
            currentUser = nil
        }
        return currentUser!
    }
}
