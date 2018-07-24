//
//  MenuVC.swift
//  EduTest
//
//  Created by Noe Osorio on 06/06/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//

import FirebaseFirestore
import UIKit

class MenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var menuB: UIBarButtonItem!
    @IBOutlet var table: UITableView!
    //Arreglo de iconos
    var classicons:[[String:String]] = []
    var iconos:[[String:String]] =
        [["materia":"Español","icono":"open-bookbw.png"],
         ["materia":"Matematicas","icono":"abacusbw.png"],
         ["materia":"Ciencias","icono":"atombw.png"],
         ["materia":"Geografia","icono":"earth-globebw.png"],
         ["materia":"Ingles","icono":"blackboardbw.png"]]
    /*var colores = [UIColor(red:0.98, green:0.97, blue:0.97, alpha:1.0),
                   UIColor(red:0.38, green:0.94, blue:0.72, alpha:1.0),
                   UIColor(red:0.81, green:0.99, blue:0.53, alpha:1.0),
                   UIColor(red:0.56, green:0.68, blue:1.00, alpha:1.0)]
    */
    /*var colores = [UIColor(red:1.00, green:1.00, blue:0.62, alpha:1.0),
                   UIColor(red:0.75, green:0.92, blue:0.62, alpha:1.0),
                   UIColor(red:0.47, green:0.74, blue:0.56, alpha:1.0)]
    */
    
    var colores = [UIColor(red:0.01, green:0.62, blue:0.65, alpha:1.0)]
    
    var materia:String?
    var proyecto:String?
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return iconos.count
        return classicons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menucell", for: indexPath) as! MenuCell
        
        /*if let img = iconos[indexPath.row]["icono"]{
            cell.icon.image = UIImage(named: img)
            cell.icon.tintColor = UIColor.white
        }
         cell.title.text = iconos[indexPath.row]["materia"]
         cell.title.tintColor = UIColor.white
 */
        if let img = classicons[indexPath.row]["icono"]{
            cell.icon.image = UIImage(named: img)
            cell.icon.tintColor = UIColor.white
        }
        cell.title.text = classicons[indexPath.row]["clase"]
        cell.title.tintColor = UIColor.white
        //cell.backgroundColor = colores[indexPath.row % colores.count]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        proyecto = classicons[indexPath.row]["clase"]
       // performSegue(withIdentifier: "lectura", sender: self)
         performSegue(withIdentifier: "Proyecto", sender: self)
    }
    //Esto evita que la celda se ponga gris a la hora de tocarla
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isHighlighted = false
    }
    
    
   func sideMenu(){
        if revealViewController() != nil{
            menuB.target = revealViewController()
            menuB.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
            view.addGestureRecognizer(
                self.revealViewController().panGestureRecognizer())
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Gestos
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeleft(swipe:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        table.rowHeight = UITableViewAutomaticDimension
        sideMenu()
        getClases(materia: materia!)
        
        
    }
    
    @objc func swipeleft(swipe:UISwipeGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
    func getClases(materia:String){
        
        //Variables
        
        
        //DataBase
        let db = Firestore.firestore()
        //let settings = db.settings
        //settings.areTimestampsInSnapshotsEnabled = true
        //db.settings = settings
        
        //Referencia
        let matRef = db.collection("Materias").document(materia).collection("Proyectos")
        matRef.getDocuments { (clases, error) in
            if error != nil{
                print("Clases no encontradas")
            }
            else{
                for clase in (clases?.documents)!{
                    if let titulo = clase.data()["Titulo"] as? String{
                        if let icono = clase.data()["Icono"] as? String{
                            self.classicons.append(["clase":titulo,"icono":icono])
                            self.insertClass()
                        }
                        
                    }
                }
                
            }
        }
    }
    
    func insertClass(){
        let indexPath = IndexPath(row: classicons.count-1, section: 0)
        
        self.table.beginUpdates()
        self.table.insertRows(at: [indexPath], with: .automatic)
        self.table.endUpdates()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? ProjectVC{
            destino.materia = materia
            destino.proyecto = "Cuento"
        }
    }
}
