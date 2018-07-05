//
//  Subject.swift
//  Citrus
//
//  Created by Noe Osorio on 19/06/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//

import Foundation

struct Subject{
    var title:String?
    var content:String?
    var index:Int?
    var tests: [Test] = []
    
    init(title:String, content:String, index:Int) {
        self.title = title
        self.content = content
        self.index = index
    }
    init(){
        self.title = "Bienvenido"
        self.content = "Gracias por confiar en nosotros"
        self.index = 0
    }
    mutating func setData(title:String, content:String, index:Int){
        self.title = title
        self.content = content
        self.index = index
    }
    
    
}

struct Test{
    var question: String?
    var answer: [String] = []
    var rightAnswer: Int?
    
    init(question:String, answer:[String], right:Int){
        self.question = question
        self.answer = answer
        self.rightAnswer = right
    }
    
    
}

struct Noticia{
    var title:String?
    var content:String?
    init(title:String, content:String) {
        self.title = title
        self.content = content
    }
    mutating func setData(title:String, content:String){
        self.title = title
        self.content = content
    }
}
