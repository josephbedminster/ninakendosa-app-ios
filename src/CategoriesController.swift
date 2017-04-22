//
//  OutViewController2.swift
//  ninakendosa
//
//  Created by Thomas ROLLAND on 13/04/16.
//  Copyright © 2016 ninakendosa.com. All rights reserved.
//

import UIKit

class CategoriesController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var buttonNouveautesImage: UIButton!
    @IBOutlet weak var buttonNouveautesText: UIButton!
    @IBOutlet weak var buttonPullsImage: UIButton!
    @IBOutlet weak var buttonPullsText: UIButton!
    @IBOutlet weak var buttonTopImage: UIButton!
    @IBOutlet weak var buttonTopText: UIButton!
    @IBOutlet weak var buttonPantalonsImage: UIButton!
    @IBOutlet weak var buttonPantalonsText: UIButton!
    @IBOutlet weak var buttonRobesImage: UIButton!
    @IBOutlet weak var buttonRobesText: UIButton!
    @IBOutlet weak var buttonAccessoiresImage: UIButton!
    @IBOutlet weak var buttonAccessoiresText: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "AffCategories") {
            if (sender === buttonTopText || sender === buttonTopImage)
            {
                let navDest = segue.destinationViewController as! UINavigationController
                let dest = navDest.viewControllers.first as! Pull_et_gillets_Controller
                dest.categorieID = "1"
            }
            else if (sender === buttonPantalonsText || sender === buttonPantalonsImage)
            {
                let navDest = segue.destinationViewController as! UINavigationController
                let dest = navDest.viewControllers.first as! Pull_et_gillets_Controller
                dest.categorieID = "2"
            }
            else if (sender === buttonRobesText || sender === buttonRobesImage)
            {
                let navDest = segue.destinationViewController as! UINavigationController
                let dest = navDest.viewControllers.first as! Pull_et_gillets_Controller
                dest.categorieID = "3"
            }
            else if (sender === buttonPullsText || sender === buttonPullsImage)
            {
                let navDest = segue.destinationViewController as! UINavigationController
                let dest = navDest.viewControllers.first as! Pull_et_gillets_Controller
                dest.categorieID = "4"
            }
            else if (sender === buttonAccessoiresText || sender === buttonAccessoiresImage)
            {
                let navDest = segue.destinationViewController as! UINavigationController
                let dest = navDest.viewControllers.first as! Pull_et_gillets_Controller
                dest.categorieID = "5"
            }
            else if (sender === buttonNouveautesText || sender === buttonNouveautesImage)
            {
                let navDest = segue.destinationViewController as! UINavigationController
                let dest = navDest.viewControllers.first as! Pull_et_gillets_Controller
                dest.categorieID = "6"
            }
        }
    }
    
    @IBAction func boutonRequete(sender: UIButton) {
        performSegueWithIdentifier("AffCategories", sender: sender)
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
