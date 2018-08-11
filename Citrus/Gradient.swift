//
//  Gradient.swift
//  Citrus
//
//  Created by Noe Osorio on 11/08/18.
//  Copyright © 2018 Noe Osorio. All rights reserved.
//

import UIKit
@IBDesignable
class Gradient: UIView {
    @IBInspectable var FirstColor: UIColor = UIColor.clear{
        didSet{
            update()
        }
    }
    @IBInspectable var SecondColor: UIColor = UIColor.clear{
        didSet{
            update()
        }
    }
    
    override class var layerClass: AnyClass{
        get{
            return CAGradientLayer.self
        }
    }
    func update(){
        let layer = self.layer as! CAGradientLayer
        layer.colors = [FirstColor.cgColor, SecondColor.cgColor]
    }

}
