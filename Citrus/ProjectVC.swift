//
//  ProjectVC.swift
//  Citrus
//
//  Created by Noe Osorio on 29/06/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//
import FirebaseFirestore
import UIKit

class ProjectVC: UIViewController, UIScrollViewDelegate{
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var scrollV: UIScrollView!
    
    @IBOutlet var titulo: UILabel!
    @IBOutlet var textContainer: UITextView!
    
    private var lastContentOffset: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollV.delegate = self
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.lastContentOffset < scrollV.contentOffset.x){
            self.lastContentOffset = scrollV.contentOffset.x
            textContainer.text = "Derecha"
            pageControl.currentPage = Int(pageControl.currentPage) + 1
        }
        if(self.lastContentOffset > scrollV.contentOffset.x){
            self.lastContentOffset = scrollV.contentOffset.x
            textContainer.text = "Derecha"
            pageControl.currentPage = Int(pageControl.currentPage) + 1
        }
    }
    
    @objc func swipeAction(swipe:UISwipeGestureRecognizer){
        switch swipe.direction.rawValue {
        case 1:
            //Right
            textContainer.text = "Left"
            pageControl.currentPage = Int(pageControl.currentPage) + 1
        case 2:
            //Left
            textContainer.text = "Right"
            pageControl.currentPage = Int(pageControl.currentPage) - 1
        default:
            break
        }
        
    }
    
    func newPage(index:Int, direction:Int){
        titulo.text = "Nuevo titulo"
        textContainer.text = "Descripcion pequeña"
        pageControl.currentPage = Int(pageControl.currentPage) + direction
        
    }
    func getDB(){
        let db = Firestore.firestore()
        let docRef = db.collection("Materias/Historia/Proyectos/Cuento/Cuentos")
        docRef.whereField("Autor", isEqualTo: "Noe Osorio").getDocuments { (snapshot, error) in
            if error != nil{
                
            }
            else{
                for document in (snapshot?.documents)!{
                    if let intro = document.data()["Introduccion"]{
                        print(intro)
                    }
                }
            }
        }
        
    }


}

