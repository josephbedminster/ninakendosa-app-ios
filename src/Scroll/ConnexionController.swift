//
//  OutViewController5.swift
//  ninakendosa
//
//  Created by Thomas ROLLAND on 13/04/16.
//  Copyright © 2016 ninakendosa.com. All rights reserved.
//

import UIKit

class ConnexionController: UIViewController {

    @IBOutlet weak var pasdecomptebutton: UIButton!
    @IBOutlet weak var buttonSeConnecter: UIButton!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonSeConnecter.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).CGColor;
        self.buttonSeConnecter.layer.borderWidth = CGFloat(Float(2.0))
        self.buttonSeConnecter.layer.cornerRadius = CGFloat(Float(0.0))
        self.pasdecomptebutton.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).CGColor;
        self.pasdecomptebutton.layer.borderWidth = CGFloat(Float(2.0))
        self.pasdecomptebutton.layer.cornerRadius = CGFloat(Float(0.0))

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view.
    }
}
