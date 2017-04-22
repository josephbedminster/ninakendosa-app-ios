//
//  OutViewController.swift
//  ninakendosa
//
//  Created by Thomas ROLLAND on 13/04/16.
//  Copyright © 2016 ninakendosa.com. All rights reserved.
//

import UIKit

class AcceuilController: UIViewController {
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "AffNouveaute") {
            let navDest = segue.destinationViewController as! UINavigationController
            let dest = navDest.viewControllers.first as! Pull_et_gillets_Controller
            dest.categorieID = "6"
        }
    }
    
    @IBAction func affMenu(sender: AnyObject) {
        let menu = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Menu") as! MenuTableViewController
        if (NSUserDefaults.standardUserDefaults().boolForKey("isConnectedNinaKendosa"))
        {
            menu.tableCellInscription.hidden = true
            menu.tableCellInscription.userInteractionEnabled = false
            menu.tableCellMonCompte.hidden = false
            menu.tableCellMonCompte.userInteractionEnabled = true
            menu.tableCellDeconnexion.hidden = false
            menu.tableCellDeconnexion.userInteractionEnabled = true
        }
        else
        {
            menu.tableCellInscription.hidden = false
            menu.tableCellInscription.userInteractionEnabled = true
            menu.tableCellMonCompte.hidden = true
            menu.tableCellMonCompte.userInteractionEnabled = false
            menu.tableCellDeconnexion.hidden = true
            menu.tableCellDeconnexion.userInteractionEnabled = false
        }
    }
    
    @IBAction func buttonPanier(sender: UIBarButtonItem) {
        if (NSUserDefaults.standardUserDefaults().boolForKey("isConnectedNinaKendosa"))
        {
            performSegueWithIdentifier("LienPanier", sender: sender)
        }
        else {
            performSegueWithIdentifier("LienConnexion", sender: sender)
        }
    }
}


