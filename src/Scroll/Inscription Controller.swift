//
//  Inscription Controller.swift
//  ninakendosa
//
//  Created by Joseph BEDMINSTER on 14/04/16.
//  Copyright © 2016 ninakendosa.com. All rights reserved.
//

import UIKit

class Inscription_Controller: UIViewController,UITextFieldDelegate {

    // VARIABLES
    // Bool pour test si l'utilisateur existe
    var userExist = false {
        didSet {
            if (userExist == false) {
                dispatch_async(dispatch_get_main_queue()) {
                    self.showErrorMessage("L'inscription a échoué.")
                }
            }
            else if (userExist == true) {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isConnectedNinaKendosa")
                NSUserDefaults.standardUserDefaults().setObject(userID, forKey: "userIDNinaKendosa")
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("InscriptionToAccueil", sender: self.buttonSInscrire)
                }
            }
        }
    }
    var userAlreadyExist = false {
        didSet {
            if (userAlreadyExist == true) {
                dispatch_async(dispatch_get_main_queue()) {
                    self.showErrorMessage("L'adresse mail est déjà utilisée.")
                }
            }
        }
    }
    var userID = ""
    
    @IBOutlet weak var buttonSexe: UISegmentedControl!
    @IBOutlet weak var textNom: UITextField!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textMotDePasse: UITextField!
    @IBOutlet weak var textConfirmationMotDePasse: UITextField!
    @IBOutlet weak var datePickerDate: UIDatePicker!
    @IBOutlet weak var buttonSInscrire: UIButton!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonSInscrire.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).CGColor;
        self.buttonSInscrire.layer.borderWidth = CGFloat(Float(1.5))
        self.buttonSInscrire.layer.cornerRadius = CGFloat(Float(0.0))
        datePickerDate.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func inscription(sender: AnyObject) {
        // Assignation des variables
        let userNom = textNom.text
        let userEmail = textEmail.text
        let userPassWord = textMotDePasse.text
        let userConfirmationPassWord = textConfirmationMotDePasse.text
        var userSexe = "1"
        switch buttonSexe.selectedSegmentIndex {
        case 0:
            userSexe = "1"
        case 1:
            userSexe = "2"
        default:
            userSexe = "1"
        } // Switch end
        
        // Recuperation de la date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let userNaissance = dateFormatter.stringFromDate(datePickerDate.date)
        
        // Check si tous les champs sont remplis
        if (userNom!.isEmpty || userEmail!.isEmpty || userPassWord!.isEmpty || userConfirmationPassWord!.isEmpty || userSexe.isEmpty || userNaissance.isEmpty)
        {
            showErrorMessage("Tous les champs doivent être remplis.")
        }
        else if (userPassWord != userConfirmationPassWord)
        {
            setTextErrorColor(textMotDePasse)
            setTextErrorColor(textConfirmationMotDePasse)
        }
        else if (matchesForRegexInText("^[A-Za-z][A-Za-z-' ]+$", text: userNom, textField: textNom) == true && matchesForRegexInText("^[A-Z0-9a-z][A-Z0-9a-z._-]+@[A-Za-z0-9_-]+\\.[A-Za-z]{2,4}$", text: userEmail, textField: textEmail) == true && matchesForRegexInText("^\\S{5,16}$", text: userPassWord, textField: textMotDePasse) == true)
        {
            // Sinon envoie de la requete au serveur
            
            // Paramétres à passer
            var param = "email=" + userEmail!
            param += "&passWord=" + userPassWord!
            param += "&nom=" + userNom!
            param += "&mdp=" + userPassWord!
            param += "&sexe=" + userSexe
            param += "&dateNaissance=" + userNaissance
            
            
            let url = NSURL(string: "https://test3-nextjoey.c9users.io/inscription") // URL du serveur
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
                else if (responseString == "existentUser") {
                    self.userAlreadyExist = true
                }
                else {
                    self.userID = responseString as! String
                    self.userExist = true
                }
            }
            task.resume() // Execution de la requete
        }
        else {
            showErrorMessage("Certains champs sont invalides.")
        }
    }

    func showErrorMessage(message: String)
    {
        // Creation de l'alerte et assignation des messages
        let alert = UIAlertController(title: "Inscription", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        // Ajout du bouton "OK"
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil) // Affichage de l'alerte
    }
    
    func setTextErrorColor(textField: UITextField) {
        textField.textColor = UIColor(red: 226/255, green: 131/255, blue: 134/255, alpha: 1)
        
    }
    
    func setTextCorrectColor(textField: UITextField) {
        textField.textColor = UIColor(red: 131/255, green: 188/255, blue: 141/255, alpha: 1)
    }
    
    func matchesForRegexInText(regex: String!, text: String!, textField: UITextField) -> Bool {
        
        do {
            let reg = try NSRegularExpression(pattern: regex, options: NSRegularExpressionOptions.AnchorsMatchLines)
            let nsString = text as NSString
            let results = reg.matchesInString(text, options: NSMatchingOptions.Anchored, range: NSMakeRange(0, nsString.length))
            if (results.isEmpty) {
                setTextErrorColor(textField)
                return (false)
            }
            else {
                setTextCorrectColor(textField)
                return (true)
            }
            
        }
        catch {
            print("error")
        }
        return (false)
    }
    
    @IBOutlet weak var Scrollview: UIScrollView!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == textNom)
        {
            Scrollview.setContentOffset(CGPointMake(0, 0), animated: true)
        }
        else if (textField == textEmail)
        {
            Scrollview.setContentOffset(CGPointMake(0, 50), animated: true)
        }
        else if (textField == textMotDePasse)
        {
            Scrollview.setContentOffset(CGPointMake(0, 120), animated: true)
        }
        else if (textField == textConfirmationMotDePasse)
        {
            Scrollview.setContentOffset(CGPointMake(0, 200), animated: true)
        }

    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        Scrollview.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    
    @IBAction func checkTextChangeNom(sender: UITextField) {
        matchesForRegexInText("^[A-Za-z][A-Za-z-' ]+$", text: sender.text, textField: sender)
    }
    
    @IBAction func checkTextChangeEmail(sender: UITextField) {
        matchesForRegexInText("^[A-Z0-9a-z][A-Z0-9a-z._-]+@[A-Za-z0-9_-]+\\.[A-Za-z]{2,4}$", text: sender.text, textField: sender)
    }
    
    @IBAction func checkTextChangePassWord(sender: UITextField) {
        matchesForRegexInText("^\\S{5,16}$", text: sender.text, textField: sender)
    }
}
