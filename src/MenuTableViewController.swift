//
//  MenuTableViewController.swift
//  ninakendosa
//
//  Created by Tho Bequet on 15/04/16.
//  Copyright © 2016 ninakendosa.com. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var tableCellInscription: UITableViewCell!
    @IBOutlet weak var tableCellMonCompte: UITableViewCell!
    @IBOutlet weak var tableCellDeconnexion: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        if (NSUserDefaults.standardUserDefaults().boolForKey("isConnectedNinaKendosa"))
        {
            tableCellInscription.hidden = true
            tableCellInscription.userInteractionEnabled = false
            tableCellMonCompte.hidden = false
            tableCellMonCompte.userInteractionEnabled = true
            tableCellDeconnexion.hidden = false
            tableCellDeconnexion.userInteractionEnabled = true
        }
        else
        {
            tableCellInscription.hidden = false
            tableCellInscription.userInteractionEnabled = true
            tableCellMonCompte.hidden = true
            tableCellMonCompte.userInteractionEnabled = false
            tableCellDeconnexion.hidden = true
            tableCellDeconnexion.userInteractionEnabled = false
        }
    }
    
    @IBAction func buttonDeconnexion(sender: UIButton) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isConnectedNinaKendosa")
        self.performSegueWithIdentifier("MenuToAccueil", sender: sender)
    }
    
    @IBAction func Panier(sender: AnyObject) {
        if (NSUserDefaults.standardUserDefaults().boolForKey("isConnectedNinaKendosa") == false) {
            performSegueWithIdentifier("MenuToConnect", sender: sender)
        }
        else
        {
            performSegueWithIdentifier("MenuToPanier", sender: sender)
        }
    }
}
