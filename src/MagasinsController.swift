//
//  OutViewController3.swift
//  ninakendosa
//
//  Created by Thomas ROLLAND on 13/04/16.
//  Copyright © 2016 ninakendosa.com. All rights reserved.
//

import UIKit
import MapKit

class MagasinsController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view.
    }
}
