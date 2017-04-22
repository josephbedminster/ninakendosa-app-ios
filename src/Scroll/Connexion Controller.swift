//
//  Connexion Controller.swift
//  ninakendosa
//
//  Created by Joseph BEDMINSTER on 14/04/16.
//  Copyright © 2016 ninakendosa.com. All rights reserved.
//

import UIKit

class Connexion_Controller: UIViewController,UITextFieldDelegate {
    
    // VARIABLES
    // Bool pour test si l'utilisateur existe
    var userExist = false {
        didSet{
            if (userExist == false) {
                dispatch_async(dispatch_get_main_queue()) {
                    self.showErrorMessage("Adresse mail ou mot de passe invalide.")
                }
            }
            else if (userExist == true) {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isConnectedNinaKendosa")
                NSUserDefaults.standardUserDefaults().setObject(userID, forKey: "userIDNinaKendosa")
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("ConnexionToAccueil", sender: self.buttonSeConnecter)
                }
            }
        }
    }
    var userID = ""
    
    // Lier les champs textes
    @IBOutlet weak var textMail: UITextField!
    @IBOutlet weak var textPassWord: UITextField!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var buttonSeConnecter: UIButton!
    @IBOutlet weak var Scrollview: UIScrollView!
    
    // ACTION
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonSeConnecter.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).CGColor;
        self.buttonSeConnecter.layer.borderWidth = CGFloat(Float(1.0))
        self.buttonSeConnecter.layer.cornerRadius = CGFloat(Float(0.0))
    }
    
    @IBAction func submitRequest(sender: UIButton) {
        let email = textMail.text! // String mail entré
        let password = textPassWord.text! // String PassWord entré
        
        // Check si les champs ont bien été remplis
        if (email.isEmpty || password.isEmpty) {
            // Message d'erreur si les champs ne sont pas remplis
            showErrorMessage("Tous les champs doivent etre remplis.")
        }
        else {
            // Sinon envoie de la requete au serveur
            let param = "email=" + email + "&passWord=" + password // Paramétres à passer
            let url = NSURL(string: "https://test3-nextjoey.c9users.io/connexion") // URL du serveur
            let session = NSURLSession.sharedSession()
            let request = NSMutableURLRequest(URL: url!) // Creation de la requete au serveur
            
            request.HTTPMethod = "POST" // Envoi des donnees en POST
            request.HTTPBody = param.dataUsingEncoding(NSUTF8StringEncoding) // Ajout des données à la requete
            
            // Envoi de la requete
            let task = session.dataTaskWithRequest(request) {
                data, response, error in
                
                // Check des erreurs
                if(error != nil) {
                    return
                }
                
                // Conversion de la reponse du serveur
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                // Check de la reponse
                if (responseString! == "false" || (responseString?.hasPrefix("<"))! || responseString == nil) {
                    self.userExist = false
                    return
                }
                else {
                    self.userID = responseString as! String
                    self.userExist = true
                }
            }
            task.resume() // Execution de la requete
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == textPassWord)
        {
        Scrollview.setContentOffset(CGPointMake(0, 100), animated: true)
        }
        else
        {
            Scrollview.setContentOffset(CGPointMake(0, 50), animated: true)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        Scrollview.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    // Fonction pour afficher les alertes
    func showErrorMessage(message: String)
    {
        // Creation de l'alerte et assignation des messages
        let alert = UIAlertController(title: "Connexion", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        // Ajout du bouton "OK"
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil) // Affichage de l'alerte
    }
}