//
//  Info.swift
//  Citrus
//
//  Created by Noe Osorio on 04/08/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//
import Firebase
import FirebaseFirestore
import Foundation
import FirebaseAuth


var info:Info = Info()
var userInfo:PersonalInfo = PersonalInfo()


struct PersonalInfo {
    
    //Personal data
    var username:String?
    var user: User?
    var userData: [String:Any]?
    
    //Personality
    var personality:String
    var subPersonality:[String] = []
    var contextQuestion:Int = 0
    
    
    init(){
        self.personality = ""
        
    }
    
    mutating func addSubText(_ text:String, _ questNum:Int){
        if (!self.subPersonality.isEmpty && self.subPersonality.count - 1 >= questNum){
            self.subPersonality[questNum] = text
        }
        else{
            self.subPersonality.append(text)
        }
    }
    
    mutating func getPersonality() -> String{
        
        for sub in self.subPersonality{
            self.personality = self.personality + sub
        }
        return self.personality
    }
    
    mutating func setContextQuestion(_ context:Int){
        self.contextQuestion = context
    }
    mutating func setUser(_ info:Info){
        self.username = info.getUsername()
        self.user = info.getUser()
        self.userData = info.getUserData()
    }
    mutating func updatePersonality(){
        let data:[String:Any] = ["personality":self.getPersonality()]
        let db = Firestore.firestore()
        db.collection("Users").document(data["userID"] as! String).updateData(data) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully updated!")
            }
        }
        UserDefaults.standard.set(userInfo, forKey: "userInfo")
    }
    
}

struct Info {
    var materia:String
    var tipo:String?
    var curso:String?
    var proyecto:String?
    var clase:String?
    var user:User?
    var userData:[String:Any]?
    
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
    mutating func setUserData(){
        
        self.userData = ["name": self.getUsername(),
                         "userID": self.getUID(),
                         "photoURL": self.getPhotoURL(),
                         "email":self.getEmail()]
       
    }
    
    
    
    mutating func setUser(){
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
    }
    
    func getEmail() -> String {
        let email = user?.email
        print("User email: \(String(describing: email))")
        return email!
    }
    
    func getUID() -> String {
        let uid = user?.uid
        print("User UID: \(String(describing: uid))")
        return uid!
    }
    
    func getUsername() -> String {
        let username = user?.displayName
        print("User UID: \(String(describing: username))")
        return username!
    }
    
    func getPhotoURL() -> String {
        let photoURL = user?.photoURL?.absoluteString
        print("User photo URL: \(String(describing: photoURL))")
        return photoURL!
    }
    
    func getUserData() -> [String:Any]{
        return self.userData!
    }
    
    func getUser() -> User{
        return self.user!
    }
    
    mutating func uploadUserData(){
        let data = self.getUserData()
        let db = Firestore.firestore()
        db.collection("Users").document(data["userID"] as! String).setData(data) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
    
    func saveDefault(){
        UserDefaults.standard.set(getUsername(), forKey: "username")
        UserDefaults.standard.set(getUID(), forKey: "userID")
        UserDefaults.standard.set(getPhotoURL(), forKey: "photoURL")
        UserDefaults.standard.set(getEmail(), forKey: "email")
    }
    
}
