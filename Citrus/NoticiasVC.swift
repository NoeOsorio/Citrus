//
//  NoticiasVC.swift
//  Citrus
//
//  Created by Noe Osorio on 04/08/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//
import FirebaseFirestore
import UIKit

class NoticiasVC: UIViewController {

    var noticias:[Noticia] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    func getNoticias(){
        //DataBase
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        //Referencia
        let notiRef = db.collection("Noticias")
        notiRef.getDocuments { (noti, error) in
            if error != nil{
                print("No hay noticias")
            }
            else{
                for noticia in (noti?.documents)!{
                    if let titulo = noticia.data()["Titulo"] as? String{
                        if let contenido = noticia.data()["Contenido"] as? String{
                            self.noticias.append(Noticia(title: titulo, content: contenido))
                            //self.insertNoti()
                        }
                    }
                }
            }
        }
    }
    
    
    /*func insertNoti(){
        self.noticiasTabla.beginUpdates()
        self.noticiasTabla.insertRows(at: [IndexPath.init(row: self.noticias.count-1, section: 0)], with: .automatic)
        self.noticiasTabla.endUpdates()
        
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
