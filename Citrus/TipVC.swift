//
//  TipVC.swift
//  Citrus
//
//  Created by Mau on 7/5/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Lottie

class TipVC: UIViewController {

    @IBOutlet weak var titleField: UITextView!
    @IBOutlet weak var contentField1: UITextView!
    @IBOutlet weak var contentField2: UITextView!
    @IBOutlet weak var animation: LOTAnimationView!
    @IBOutlet weak var nextbutton: UIButton!
    
    var subject: Subject = Subject()
    var counter: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getContent(index: counter)
        loadAnimation(index: counter)
        setColor(index: counter)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getContent(index: counter)
        loadAnimation(index: counter)
        setColor(index: counter)
    }
    func getContent(index: Int){
        let db = Firestore.firestore() //Base de datos
        let docRef = db.collection("Materias/Historia/Proyectos/Cuento/Tips")//referencia
        
        docRef.whereField("Index", isEqualTo: index).getDocuments { (snapshot, error) in
            if error != nil {
                print("Error en la base de datos")
            }
            else{
                for document in (snapshot?.documents)! {
                    if let titulo = document.data()["Titulo"] as? String {
                        if let cuerpo1 = document.data()["Cuerpo 1"] as? String {
                            if let cuerpo2 = document.data()["Cuerpo 2"] as? String {
                                self.subject.setData(title: titulo, content: cuerpo1, content2: cuerpo2, index: index)
                                print("Data successfully added with index \(index)")
                                self.showData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loadAnimation(index: Int) {
        switch index {
        case 0: animation.setAnimation(named: "so_excited")
            break
        case 1: animation.setAnimation(named: "biking_is_cool")
            break
        case 2: animation.setAnimation(named: "bikingishard")
            break
        case 3: animation.setAnimation(named: "acrobatics")
            break
        default: print("Error loading animation")
            break
            
        }
        
        animation.loopAnimation = true
        animation.contentMode = .scaleAspectFit
        view.addSubview(animation)
        animation.play()
    }
    
    func setColor(index: Int) {
        
        //Todavia no cargan bien los colores
        switch index {
        case 0: self.view.backgroundColor = UIColor(red: 21, green:139 , blue: 193, alpha: 1)
                titleField.backgroundColor = UIColor(red: 21, green:139 , blue: 193, alpha: 1)
                contentField1.backgroundColor = UIColor(red: 21, green:139 , blue: 193, alpha: 1)
                contentField2.backgroundColor = UIColor(red: 21, green:139 , blue: 193, alpha: 1)
            print("Set color with index \(index)")
            break
        case 1:
            break
        case 2:
            break
        case 3:
            break
        default: print("Error loading color")
            break
        }
    }
    
    @IBAction func didTouchButton(_ sender: UIButton) {
        performSegue(withIdentifier: "goToWriteSection", sender: self)
    }
    
    @IBAction func unwindToTip(segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "goToWriteSection") {
            let CuentoVC = (segue.destination as! CuentoVC)
            CuentoVC.counter = counter
        }
    }
    
    func showData(){
        self.titleField.text = subject.title
        self.contentField1.text = subject.content
        self.contentField2.text = subject.content2
        //self.pageControl.currentPage = (subject.index)!
    }
}
