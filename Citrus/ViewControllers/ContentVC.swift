//
//  ContentVC.swift
//  EduTest
//
//  Created by Noe Osorio on 08/06/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//

import UIKit

class ContentVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tituloMain: UILabel!
    var noticias: [Noticia] = []
    var noticia: Noticia?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Gestos
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiperight(swipe:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        //====
        tituloMain.text = "Noticias de la semana"
        
        // Do any additional setup after loading the view.
    }
    
    @objc func swiperight(swipe:UISwipeGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lectura", for: indexPath) as! LectureCell
        
        cell.subtitulo.text = noticia?.title
        cell.texto.text = noticia?.content
        
        if let img:String = "university.png"{
            cell.imagen.image = #imageLiteral(resourceName: "orangebg")
        }
        
        cell.setHighlighted(false, animated: true)
        return cell
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isHighlighted = false
        tableView.cellForRow(at: indexPath)?.setHighlighted(false, animated: false)
    }

}

