//
//  ViewController.swift
//  SSColorSliderDemo
//
//  Created by Sweta on 04/04/20.
//  Copyright © 2020 Sweta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var colorView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func sliderChanged(_ sender: SSColorSlider) {
        self.colorView.backgroundColor = sender.color
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

