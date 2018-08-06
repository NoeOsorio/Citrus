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
    var user:User?
    
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
        
        currentUser = Auth.auth().currentUser
        
        if(currentUser != nil) {
            print("Current user: \(String(describing: currentUser))")
        }
        else{
            print("Error: No user signed in")
            currentUser = nil
        }
        self.user = currentUser
        return currentUser!
    }
    
    mutating func getEmail() -> String {
        let email = user?.email
        print("User email: \(String(describing: email))")
        return email!
    }
    
    mutating func getUID() -> String {
        let uid = user?.uid
        print("User UID: \(String(describing: uid))")
        return uid!
    }
    
    mutating func getPhotoURL() -> URL {
        let photoURL = user?.photoURL
        print("User photo URL: \(String(describing: photoURL))")
        return photoURL!
    }
    
}
