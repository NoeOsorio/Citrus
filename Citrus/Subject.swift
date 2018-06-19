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
    var reading:String?
    var image:UIImage?
    var tests: [Test] = []
    
    init(title:String, reading:String, img:String) {
        self.title = title
        self.reading = reading
        self.image = UIImage(named:img)
    }
    mutating func set(img:String) {
        self.image = UIImage(named:img)
        
    }
    mutating func set(img:UIImage) {
        self.image = img
        
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
