//
//  HomeVC.swift
//  Citrus
//
//  Created by Noe Osorio on 19/06/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//
import FirebaseFirestore
import UIKit



class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var cursosTabla: UITableView!
    @IBOutlet var categoriaColection: UICollectionView!
    //Variables
    var categorias:[String] = []
    var cursos:[[String:String]] = []
    var materia:String?
    var proyecto:String?
    var tipo = "Cursos"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    
    func getData(){
        //DataBase
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        //Referencia
        let matRef = db.collection("Materias")
        matRef.getDocuments { (materias, error) in
            if error != nil{
                print("Materias no encontradas")
            }
            else{
                for materia in (materias?.documents)!{
                    if let titulo = materia.data()["Titulo"] as? String{
                        self.categorias.append(titulo)
                        print(titulo)
                        //self.categoriaColection.reloadData()
                        self.insertCategoria()
                        
                    }
                }
                self.getCursos(tipo: self.tipo)
                //self.insertCellAt()
            }
        }
    }
    
    func getCursos(tipo:String){
        
        //Variables
        
        //DataBase
        let db = Firestore.firestore()
        
        //Referencia
        
        for materia in categorias{
            let matRef = db.collection("Materias").document(materia).collection(tipo)
            matRef.getDocuments { (cursos, error) in
                if error != nil{
                    print("Cursos no encontradas")
                }
                else{
                    for curso in (cursos?.documents)!{
                        if let titulo = curso.data()["Titulo"] as? String{
                            if let icono = curso.data()["Icono"] as? String{
                                self.cursos.append(["curso":titulo,"icono":icono, "materia":materia])
                                self.insertCurso()
                            }
                            
                        }
                    }
                }
            }
        }
        
    }
    
    func insertCategoria(){
        
        let newIndexPath = IndexPath(item: self.categorias.count-1, section: 0)
        self.categoriaColection.insertItems(at: [newIndexPath])
    }
    
    func insertCurso(){
        let indexPath = IndexPath(row: cursos.count-1, section: 0)
        
        self.cursosTabla.beginUpdates()
        self.cursosTabla.insertRows(at: [indexPath], with: .automatic)
        self.cursosTabla.endUpdates()
        
    }
    
    //Tabla
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cursos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hot", for: indexPath) as! HotCell
        
        cell.contentDicc = cursos[indexPath.row]
        let cursosContent = cell.contentDicc!
        
        cell.bgimage.image = UIImage(named: cursosContent["icono"]!)
        cell.title.text = cursosContent["curso"]! + " : " + cursosContent["materia"]!
        cell.layer.cornerRadius = 15
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = tableView.cellForRow(at: indexPath) as! HotCell
        
        info.setMateria(materia: selected.contentDicc!["materia"]!)
        info.setTipo(tipo: tipo)
        info.setCurso(curso: selected.contentDicc!["curso"]!)
        performSegue(withIdentifier: "cursito", sender: self)
    }
    
    //Collection Categorias
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categorias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoria", for: indexPath) as! CategoriaCell
        
        //cell.bg.image = UIImage(named:"orangebg")
        cell.layer.cornerRadius = 15
        cell.title.text = categorias[indexPath.row]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        materia = categorias[indexPath.row]
        info.setMateria(materia: materia!)
        info.setTipo(tipo: "Cursos")
        performSegue(withIdentifier: "curso", sender: self)
       
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? ProjectVC{
            //destino.materia = materia
            destino.proyecto = "Cuento"
        }
        
        if let destiny = segue.destination as? MenuVC{
            destiny.materia = materia!
        }
    }
    
    

}
