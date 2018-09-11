//
//  ProgressVC.swift
//  EduTest
//
//  Created by Noe Osorio on 08/06/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import Darwin

class ProgressVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = UserDefaults.standard.value(forKey: "username") as? String
        let imageURL = UserDefaults.standard.value(forKey: "photoURL") as? String
        let url = URL(string: imageURL!)
        if let data = try? Data(contentsOf: url!){
            avatar.image = UIImage(data: data)
        }
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        //animateProgress(toValue: 60, duration: 5.0)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "progreso", for: indexPath) as! ProgressCell
        
        cell.title.text = "Algun Curso"
        cell.icon.image = #imageLiteral(resourceName: "apple")
        cell.progress.value = 40
        cell.layer.cornerRadius = 15
        
        return cell
    }
    
    


}
