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

class ProgressVC: UIViewController {
    @IBOutlet var titleView: UIView!
    
    @IBOutlet var menuB: UIBarButtonItem!
    @IBAction func btn(_ sender: Any) {
        
    }
    @IBOutlet weak var progress: MBCircularProgressBarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
        self.progress.value = 0
        titleView.layer.cornerRadius = 10
        
        //animateProgress(toValue: 40, duration: 5.0)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        animateProgress(toValue: 60, duration: 5.0)
    }
    
    
    func animateProgress (toValue:CGFloat, duration:TimeInterval){
        UIView.animate(withDuration: duration){
            self.progress.value = toValue
        }
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
   
    
    


}
