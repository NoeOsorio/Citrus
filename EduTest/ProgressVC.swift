//
//  ProgressVC.swift
//  EduTest
//
//  Created by Noe Osorio on 08/06/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class ProgressVC: UIViewController {

    @IBOutlet var menuB: UIBarButtonItem!
    @IBAction func btn(_ sender: Any) {
        animateProgress(toValue: 40, duration: 5.0)
    }
    @IBOutlet weak var progress: MBCircularProgressBarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
        self.progress.value = 100
       
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
