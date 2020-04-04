//
//  SSIndicatorView.swift
//  SSColorSlider
//
//  Created by Sweta on 29/09/19.
//  Copyright © 2019 Sweta. All rights reserved.
//

import UIKit

class SSIndicatorThumbView: UIView {
    var colorView:UIView!
    var color:UIColor = UIColor.clear {
        didSet {
            colorView.backgroundColor = color
        }
    }
    
    var inset:CGFloat = 0 {
        didSet {
            colorView.frame = self.bounds.insetBy(dx: inset, dy: inset)
            colorView.layer.cornerRadius = colorView.frame.width/2
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        colorView = UIView(frame: self.bounds)
        addSubview(colorView)
        
        self.shadowColor = UIColor.black
        self.shadowOffset = CGSize(width: 0, height: 5)
        self.shadowRadius = 3
        self.shadowOpacity = 0.1
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func tintColorDidChange() {
        self.backgroundColor = self.tintColor;
    }
}

class SSIndicatorView: UIView {
    var colorView:UIView!
    var arrowView:UIView!
    var color:UIColor = UIColor.clear {
        didSet {
            colorView.backgroundColor = color
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        colorView = UIView(frame: self.bounds.insetBy(dx: 3, dy: 3))
        colorView.layer.cornerRadius = colorView.frame.width/2
        addSubview(colorView)
       
        arrowView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        var rect:CGRect = arrowView.frame
        rect.origin.y = self.bounds.height - 15
        rect.origin.x = self.bounds.midX - round(arrowView.frame.width/2)
        
        arrowView.frame = rect
        arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2)/2)
//        arrowView.layer.cornerRadius = 4
        
        addSubview(arrowView)
        sendSubviewToBack(arrowView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func tintColorDidChange() {
        self.backgroundColor = Color.centerThumbColor
        arrowView.backgroundColor = Color.centerThumbColor
    }
}
