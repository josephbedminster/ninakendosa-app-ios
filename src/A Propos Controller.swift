//
//  A Propos Controller.swift
//  ninakendosa
//
//  Created by nextjoey on 19/04/2016.
//  Copyright © 2016 ninakendosa.com. All rights reserved.
//

import UIKit
import MessageUI

class A_Propos_Controller: UIViewController, MFMailComposeViewControllerDelegate {

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

    @IBAction func buttonNorma(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController("norma@ninakendosa.com")
        
         if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        }
        else {
            self.showErrorSendMailAlert()
        }
    }
    
    @IBAction func buttonKendy(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController("kendy@ninakendosa.com")
        
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        }
        else {
            self.showErrorSendMailAlert()
        }
    }
    
    func configuredMailComposeViewController(email: String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients([email])
        mailComposerVC.setSubject("APP NinaKendosa")
        mailComposerVC.setMessageBody("Bonjour,\n\n", isHTML: false)
        
        return (mailComposerVC)
    }
    
    func showErrorSendMailAlert() {
        let sendErrorMailAlert = UIAlertView(title: "Le mail n'a pas pu être envoyé", message: "Vérifiez la configuration de votre téléphone et réessayez.", delegate: self, cancelButtonTitle: "OK")
        
        sendErrorMailAlert.show()
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
    {
        switch result.rawValue {
        
        case MFMailComposeResultCancelled.rawValue:
            dispatch_async(dispatch_get_main_queue()) {
                self.showErrorMessage("Message annulé")
            }
        case MFMailComposeResultSent.rawValue:
            dispatch_async(dispatch_get_main_queue()) {
                self.showErrorMessage("Message envoyé")
            }
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showErrorMessage(title: String) {
        // Creation de l'alerte et assignation des messages
        let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        // Ajout du bouton "OK"
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil) // Affichage de l'alerte
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
