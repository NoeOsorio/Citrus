//
//  ContentVC.swift
//  EduTest
//
//  Created by Noe Osorio on 08/06/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//

import UIKit

class ContentVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var lecturas: [Lectura] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lectura", for: indexPath) as! LectureCell
        
        cell.subtitulo.text = "Subtema \(indexPath.row)"
        cell.texto.text = "En esta seccion va a ir el contenido del subtema que estemos trabajando"
        
        if let img:String = "university.png"{
            cell.imagen.image = UIImage(named: img)
        }
        
        cell.setHighlighted(false, animated: true)
        return cell
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isHighlighted = false
        tableView.cellForRow(at: indexPath)?.setHighlighted(false, animated: false)
    }

}
struct Lectura{
    var subtema: String?
    var texto: String?
    var imagen: UIImage?
    init(subtema: String, texto: String, imagen: String){
        self.subtema = subtema
        self.texto = texto
        self.imagen = UIImage(named: imagen)
    }
    init(subtema: String, texto: String, imagen: UIImage){
        self.subtema = subtema
        self.texto = texto
        self.imagen = imagen
    }
}
