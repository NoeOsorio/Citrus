//
//  MenuClasesVC.swift
//  Citrus
//
//  Created by Noe Osorio on 02/08/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//
import FirebaseFirestore
import UIKit

class MenuClasesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tituloClase: UILabel!
    @IBOutlet var table: UITableView!
    var materia:String = "Historia"
    var curso:String = "Redaccion"
    var clasesA: [Clase] = []
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clasesA.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuclase", for: indexPath) as! MenuClaseCell
    
        cell.selectionStyle = .none
        cell.texto.text = clasesA[indexPath.row].title
        cell.likeBool = clasesA[indexPath.row].like
        if (cell.likeBool){
            cell.likeButton.isSelected = true
        }
        cell.watchedBool = clasesA[indexPath.row].watched
        if (cell.watchedBool){
            cell.successButton.isSelected = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MenuClaseCell
        cell.selectionStyle = .none
    }
    
    func insertRow(){
        let indexPath = IndexPath(row: clasesA.count-1, section: 0)
        
        self.table.beginUpdates()
        self.table.insertRows(at: [indexPath], with: .automatic)
        self.table.endUpdates()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tituloClase.text = curso
        getClases()
    }
    func getClases(){
        
        //Variables
        let path = "Materias/" + materia + "/Cursos/" + curso + "/Clases"
        
        
        //DataBase
        let db = Firestore.firestore()
        //let settings = db.settings
        //settings.areTimestampsInSnapshotsEnabled = true
        //db.settings = settings
        
        //Referencia
        let matRef = db.collection(path)
        
        matRef.getDocuments { (clases, error) in
            if error != nil{
                print("Clases no encontradas")
            }
            else{
                for clase in (clases?.documents)!{
                    if let titulo = clase.data()["Titulo"] as? String{
                        if let index = clase.data()["Index"] as? Int{
                            var nuevaClase = Clase(title: titulo, index: index, path: path)
                            if let watched = clase.data()["Watched"] as? Bool{
                                nuevaClase.setWatched(bool: watched)
                            }
                            self.clasesA.append(nuevaClase)
                            self.insertRow()
                        }
                    }
                }
                
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
 

}
