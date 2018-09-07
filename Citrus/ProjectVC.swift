//
//  ProjectVC.swift
//  Citrus
//
//  Created by Noe Osorio on 29/06/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//
import FirebaseFirestore
import UIKit

class ProjectVC: UIViewController{
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet var titulo: UILabel!
    @IBOutlet var textContainer: UITextView!
    
    private var lastContentOffset: CGFloat = 0
    
    var pageTotal:Int?
    var subject:Subject = Subject()
    var counter = 0
    
    //Variables que se modifican dependiendo lo que eliga el usuario
    var materia = info.materia
    var proyecto:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //==Gestures==
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        //==
        getClass(index: 0)
        getNumberPages()
        
    }
    
    
    @objc func swipeAction(swipe:UISwipeGestureRecognizer){
        var currentp = Int(pageControl.currentPage)
        
        switch swipe.direction.rawValue {
        case 1:
            //Right
            currentp = currentp - 1
            getClass(index: currentp)
            pageControl.currentPage = currentp
            
            if (currentp > 3) {
                performSegue(withIdentifier: "goToTipSection", sender: self)
            }
        case 2:
            //Left
            currentp = currentp + 1
            getClass(index: currentp)
            pageControl.currentPage = currentp
            
            if (currentp > 3) {
                performSegue(withIdentifier: "goToTipSection", sender: self)
            }
        default:
            self.dismiss(animated: true, completion: nil)
            break
        }
        
    }
    
    func newPage(index:Int, direction:Int){
        titulo.text = "Nuevo titulo"
        textContainer.text = "Descripcion pequeña"
        pageControl.currentPage = Int(pageControl.currentPage) + direction
        
    }
    func getClass(index: Int){
        //var materia = "Historia"
        getNumberPages()
        //Base de datos
        let db = Firestore.firestore()
        
        //Referencia de la coleccion
        let docRef = db.collection("Materias/"+self.materia+"/Proyectos/"+self.proyecto!+"/Clase")
        
        //Obtener los datos del contenido por clase
        docRef.whereField("Index", isEqualTo: index).getDocuments{ (snapshot, error) in
            if error != nil{
                print("Error en la base de datos")
            }
            else{
                for document in (snapshot?.documents)!{
                    if let titulo = document.data()["Titulo"] as? String{
                        if let content = document.data()["Contenido"] as? String{
                            self.subject.setData(title: titulo, content: content, index: index)
                            print("Data succesfully added with index \(index)")
                            self.showData()
                        }
                    }
                }
            }
        }
        
        
    }
    func showData(){
        self.titulo.text = subject.title
        self.textContainer.text = subject.content
        self.pageControl.currentPage = (subject.index)!
    }
    
    func getNumberPages(){
        //Base de datos
        let db = Firestore.firestore()
        
        //Referencia de la coleccion
        let docRef = db.collection("Materias/Historia/Proyectos/Cuento/Clase")
        
        //Numero de paginas
        docRef.getDocuments { (countsnap, error) in
            if error != nil{
                print("Documento no encontrado")
            }
            else{
                let count = countsnap?.documents.count
                self.pageTotal = count!
                self.pageControl.numberOfPages = self.pageTotal!
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToTipSection") {
            let TipVC = (segue.destination as! TipVC)
            TipVC.counter = counter
        }
    }

}

