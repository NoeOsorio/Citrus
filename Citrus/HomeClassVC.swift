//
//  HomeClassVC.swift
//  Citrus
//
//  Created by Noe Osorio on 04/08/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//
import FirebaseFirestore
import UIKit

class HomeClassVC:UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var noticiasTabla: UITableView!
    @IBOutlet var categoriaColection: UICollectionView!
    //Variables
    var categorias:[String] = []
    var noticias:[Noticia] = []
    var proyectos:[[[String:String]]] = []
    var clasesicon:[[String:String]] = []
    var selectedNoticia:Int?
    var materia:String?
    var proyecto:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        getNoticias()
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
                            self.insertNoti()
                        }
                    }
                }
            }
        }
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
                //self.insertCellAt()
            }
        }
    }
    
    func getClases(materia:String){
        
        //Variables
        var classicons:[[String:String]] = []
        clasesicon.removeAll()
        
        //DataBase
        let db = Firestore.firestore()
        //let settings = db.settings
        //settings.areTimestampsInSnapshotsEnabled = true
        //db.settings = settings
        
        //Referencia
        let matRef = db.collection("Materias").document(materia).collection("Cursos")
        matRef.getDocuments { (clases, error) in
            if error != nil{
                print("Clases no encontradas")
            }
            else{
                for clase in (clases?.documents)!{
                    if let titulo = clase.data()["Titulo"] as? String{
                        if let icono = clase.data()["Icono"] as? String{
                            classicons.append(["clase":titulo,"icono":icono])
                            self.clasesicon.append(["clase":titulo,"icono":icono])
                        }
                        
                    }
                }
                self.proyectos.append(classicons)
            }
        }
    }
    
    func insertCategoria(){
        
        let newIndexPath = IndexPath(item: self.categorias.count-1, section: 0)
        self.categoriaColection.insertItems(at: [newIndexPath])
    }
    
    func insertNoti(){
        self.noticiasTabla.beginUpdates()
        self.noticiasTabla.insertRows(at: [IndexPath.init(row: self.noticias.count-1, section: 0)], with: .automatic)
        self.noticiasTabla.endUpdates()
        
    }
    
    //Tabla
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hot", for: indexPath) as! HotCell
        
        cell.bgimage.image = UIImage(named: "orange.png")
        cell.title.text = noticias[indexPath.row].title
        //cell.content.text = noticias[indexPath.row].content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNoticia = indexPath.row
        performSegue(withIdentifier: "Noticia", sender: self)
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
        info.setTipo(tipo: "Proyectos")
        //getClases(materia: materia!)
        //performSegue(withIdentifier: "Clase", sender: self)
        performSegue(withIdentifier: "proyecto", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? ProjectVC{
            destino.materia = materia
            destino.proyecto = "Redaccion"
        }
        /*if let mostrarNoticia = segue.destination as? ContentVC{
         mostrarNoticia.noticia = noticias[selectedNoticia!]
         }*/
        if let destiny = segue.destination as? MenuVC{
            destiny.materia = materia!
            //destiny.material = "Cursos"
            //getClases(materia: materia!)
            //destiny.classicons = clasesicon
        }
    }
    
    
    
}
