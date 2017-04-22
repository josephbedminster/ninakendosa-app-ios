//
//  Profil ControllerViewController.swift
//  ninakendosa
//
//  Created by Clovis DEROUCK on 18/04/16.
//  Copyright © 2016 ninakendosa.com. All rights reserved.
//

import UIKit

class Profil_ControllerViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var buttonModifMDP: UIButton!
    @IBOutlet weak var NomProfil: UILabel!
    @IBOutlet weak var Date_naissance_Profil: UILabel!
    @IBOutlet weak var OldMail: UITextField!
    @IBOutlet weak var OldAdresse: UITextField!
    @IBOutlet weak var OldVille: UITextField!
    @IBOutlet weak var OldCodePostal: UITextField!
    @IBOutlet weak var OldMotDePasse: UITextField!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var confirmMDP = false
    var alert: UIAlertController = UIAlertController()
    
    @IBAction func updateEmail(sender: AnyObject) {
        // Initialisation des variables
        if (OldMail.text != "" && Inscription_Controller().matchesForRegexInText("^[A-Z0-9a-z][A-Z0-9a-z._-]+@[A-Za-z0-9_-]+\\.[A-Za-z]{2,4}$", text: OldMail.text, textField: OldMail) == true) {
            // Création de la route à suivre
            var baseURL = "https://test3-nextjoey.c9users.io" // Url Du Serveur
            let route = "/modif_profil/email/" + OldMail.text! + "/" + NSUserDefaults.standardUserDefaults().stringForKey("userIDNinaKendosa")! // Route De La Requete
            baseURL = baseURL + route // Url De La Requete
            // Création de la requete
            let myUrl = NSURL(string: baseURL);
            let request = NSURLRequest(URL:myUrl!);
            // Requete à executer
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
                
                // Check des erreurs
                if error != nil {
                    print("error=\(error)") // Affichage de l'erreur
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("refreshLink", sender: sender)
                }
            }
            // Lance la requete
            task.resume()
        }
        else {
            showErrorMessage("Cet email est invalide.")
        }
    }
    
    @IBAction func updateAdresse(sender: AnyObject) {
        // Initialisation des variables
        if (OldAdresse.text != "" && Inscription_Controller().matchesForRegexInText("^[1-9][0-9]*[, ][-a-zA-Z' ]+$", text: OldAdresse.text, textField: OldAdresse) == true) {
            // Création de la route à suivre
            var baseURL = "https://test3-nextjoey.c9users.io" // Url Du Serveur
            let route = "/modif_profil/adresse/" + OldAdresse.text! + "/" + NSUserDefaults.standardUserDefaults().stringForKey("userIDNinaKendosa")! // Route De La Requete
            baseURL = baseURL + route // Url De La Requete
            // Création de la requete
            let url = baseURL as NSString
            baseURL = url.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            let myUrl = NSURL(string: baseURL);
            let request = NSURLRequest(URL:myUrl!);
            // Requete à executer
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
                
                // Check des erreurs
                if error != nil {
                    print("error=\(error)") // Affichage de l'erreur
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("refreshLink", sender: sender)
                }
            }
            // Lance la requete
            task.resume()
        }
        else {
            showErrorMessage("Cette adresse est invalide.")
        }
    }
    
    @IBAction func updateVille(sender: AnyObject) {
        // Initialisation des variables
        if (OldVille.text != "" && Inscription_Controller().matchesForRegexInText("^[A-Za-z][A-Za-z-' ]+$", text: OldVille.text, textField: OldVille) == true) {
            // Création de la route à suivre
            var baseURL = "https://test3-nextjoey.c9users.io" // Url Du Serveur
            let route = "/modif_profil/ville/" + OldVille.text! + "/" + NSUserDefaults.standardUserDefaults().stringForKey("userIDNinaKendosa")! // Route De La Requete
            baseURL = baseURL + route // Url De La Requete
            // Création de la requete
            let url = baseURL as NSString
            baseURL = url.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            let myUrl = NSURL(string: baseURL);
            let request = NSURLRequest(URL:myUrl!);
            // Requete à executer
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
                
                // Check des erreurs
                if error != nil {
                    print("error=\(error)") // Affichage de l'erreur
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("refreshLink", sender: sender)
                }
            }
            // Lance la requete
            task.resume()
        }
        else {
            showErrorMessage("Cette ville est invalide.")
        }
    }
    
    @IBAction func updateCP(sender: AnyObject) {
        // Initialisation des variables
        if (OldCodePostal.text != "" && Inscription_Controller().matchesForRegexInText("^[0-9]{5}$", text: OldCodePostal.text, textField: OldCodePostal) == true) {
            // Création de la route à suivre
            var baseURL = "https://test3-nextjoey.c9users.io" // Url Du Serveur
            let route = "/modif_profil/code_postal/" + OldCodePostal.text! + "/" + NSUserDefaults.standardUserDefaults().stringForKey("userIDNinaKendosa")! // Route De La Requete
            baseURL = baseURL + route // Url De La Requete
            // Création de la requete
            let myUrl = NSURL(string: baseURL);
            let request = NSURLRequest(URL:myUrl!);
            // Requete à executer
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
                
                // Check des erreurs
                if error != nil {
                    print("error=\(error)") // Affichage de l'erreur
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("refreshLink", sender: sender)
                }
            }
            // Lance la requete
            task.resume()
        }
        else {
            showErrorMessage("Ce code postal est invalide.")
        }
    }
    
    @IBAction func updateMDP(sender: AnyObject) {
        if (OldMotDePasse.text != "" && Inscription_Controller().matchesForRegexInText("^\\S{5,16}$", text: OldMotDePasse.text, textField: OldMotDePasse) == true) {
            showErrorMessageWithInput("Entrez votre ancien mot de passe pour confirmer.")
        }
        else {
            showErrorMessage("Entrez 5 à 16 caractères.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialisation des variables
        var Nom = ""
        var Date_naissance = ""
        var Mail_Placeholder = ""
        var Adresse_Placeholder = ""
        var Ville_Placeholder = ""
        var CP_Placeholder = ""
        
        // Création de la route à suivre
        var baseURL = "https://test3-nextjoey.c9users.io" // Url Du Serveur
        let route = "/modif_profil/informations/" + NSUserDefaults.standardUserDefaults().stringForKey("userIDNinaKendosa")! // Route De La Requete
        baseURL = baseURL + route // Url De La Requete
        // Création de la requete
        let myUrl = NSURL(string: baseURL);
        let request = NSURLRequest(URL:myUrl!);
        // Requete à executer
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            // Check des erreurs
            if error != nil
            {
                print("error=\(error)") // Affichage de l'erreur
                return
            }
            // Conversion de la réponse (Format JSON) vers un dictionnaire
            do {
                // Conversion
                if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    
                    // Get Valeur Grace Aux Cles
                    Nom = (convertedJsonIntoDict["retour"]![0]![0]!["nom"] as? String)!
                    Date_naissance = (convertedJsonIntoDict["retour"]![0]![0]!["date_de_naissance"] as? String)!
                    Mail_Placeholder = (convertedJsonIntoDict["retour"]![0]![0]!["email"] as? String)!
                    Adresse_Placeholder = (convertedJsonIntoDict["retour"]![0]![0]!["adresse"] as? String)!
                    Ville_Placeholder = (convertedJsonIntoDict["retour"]![0]![0]!["ville"] as? String)!
                    CP_Placeholder = (convertedJsonIntoDict["retour"]![0]![0]!["code_postal"] as? String)!
                    
                    Date_naissance = self.cut_date_de_naissance(Date_naissance)
                    // Change Les Valeurs Des Textes et images
                    dispatch_async(dispatch_get_main_queue()) {
                        self.NomProfil.text = Nom
                        self.Date_naissance_Profil.text = Date_naissance
                        self.OldMail.placeholder = Mail_Placeholder
                        self.OldAdresse.placeholder = Adresse_Placeholder
                        self.OldVille.placeholder = Ville_Placeholder
                        self.OldCodePostal.placeholder = CP_Placeholder
                        if (self.OldAdresse.placeholder == nil) {
                            self.OldAdresse.placeholder = "Renseigner mon adresse"
                        }
                        if (self.OldVille.placeholder == nil) {
                            self.OldVille.placeholder = "Renseigner ma ville"
                        }
                        if (self.OldCodePostal.placeholder == nil) {
                            self.OldCodePostal.placeholder = "Renseigner mon code postal"
                        }
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        // Lance la requete
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cut_date_de_naissance (date_de_naissance: String) -> String {
        let RangeDateY = date_de_naissance.startIndex..<date_de_naissance.endIndex.advancedBy(-20)
        let DateY = date_de_naissance[RangeDateY]
        let RangeDateM = date_de_naissance.startIndex.advancedBy(5)..<date_de_naissance.endIndex.advancedBy(-17)
        let DateM = date_de_naissance[RangeDateM]
        let RangeDateD = date_de_naissance.startIndex.advancedBy(8)..<date_de_naissance.endIndex.advancedBy(-14)
        let DateD = date_de_naissance[RangeDateD]
        let newDate = DateD + "/" + DateM + "/" + DateY
        return (newDate)
    }
    
    func showErrorMessage(message: String) {
        // Creation de l'alerte et assignation des messages
        let alert = UIAlertController(title: "Mon profil", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        // Ajout du bouton "OK"
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil) // Affichage de l'alerte
    }
    
    func configurationTextField(textField: UITextField!) {
        textField.placeholder = "Ancien mot de passe"
        textField.secureTextEntry = true
    }
    
    func handlerCancel(alertView: UIAlertAction!) {
        self.confirmMDP = false
    }
    
    func handlerValidate(alertView: UIAlertAction!) {
        self.confirmMDP = true
        // Initialisation des variables
        if (confirmMDP == true) {
            // Sinon envoie de la requete au serveur
            let param = "email=" + self.OldMail.placeholder! + "&passWord=" + self.alert.textFields![0].text! // Paramétres à passer
            let url = NSURL(string: "https://test3-nextjoey.c9users.io/connexion") // URL du serveur
            let session = NSURLSession.sharedSession()
            let request = NSMutableURLRequest(URL: url!) // Creation de la requete au serveur
            
            request.HTTPMethod = "POST" // Envoi des donnees en POST
            request.HTTPBody = param.dataUsingEncoding(NSUTF8StringEncoding) // Ajout des données à la requete
            
            // Envoi de la requete
            let task1 = session.dataTaskWithRequest(request) {
                data, response, error in
                
                // Check des erreurs
                if(error != nil) {
                    return
                }
                
                // Conversion de la reponse du serveur
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                // Check de la reponse
                if (responseString! == "false" || (responseString?.hasPrefix("<"))! || responseString == nil) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.showErrorMessage("Mot de passe incorrect.")
                    }
                }
                else {
                    // Création de la route à suivre
                    var baseURL = "https://test3-nextjoey.c9users.io" // Url Du Serveur
                    let route = "/modif_profil/mdp/" + self.OldMotDePasse.text! + "/" + NSUserDefaults.standardUserDefaults().stringForKey("userIDNinaKendosa")! // Route De La Requete
                    baseURL = baseURL + route // Url De La Requete
                    // Création de la requete
                    let myUrl = NSURL(string: baseURL);
                    let request = NSURLRequest(URL:myUrl!);
                    // Requete à executer
                    let task2 = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                        data, response, error in
                        
                        // Check des erreurs
                        if error != nil {
                            print("error=\(error)") // Affichage de l'erreur
                        }
                        dispatch_async(dispatch_get_main_queue()) {
                            self.performSegueWithIdentifier("refreshLink", sender: self.buttonModifMDP)
                        }
                    }
                    // Lance la requete
                    task2.resume()
                }
            }
            task1.resume() // Execution de la requete
        }
    }
    
    func showErrorMessageWithInput(message: String) {
        // Creation de l'alerte et assignation des messages
        alert = UIAlertController(title: "Mot de passe", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        // Ajout du bouton "OK"
        let okAction = UIAlertAction(title: "Valider", style: UIAlertActionStyle.Default, handler: handlerValidate)
        let cancelAction = UIAlertAction(title: "Annuler", style: UIAlertActionStyle.Cancel, handler: handlerCancel)
        
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil) // Affichage de l'alerte
    }
    
    @IBOutlet weak var Scrollview: UIScrollView!
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == OldMail)
        {
        Scrollview.setContentOffset(CGPointMake(0, 0), animated: true)
        }
        else if (textField == OldAdresse)
        {
            Scrollview.setContentOffset(CGPointMake(0, 50), animated: true)
        }
        else if (textField == OldVille)
        {
            Scrollview.setContentOffset(CGPointMake(0, 100), animated: true)
        }
        else if (textField == OldCodePostal)
        {
            Scrollview.setContentOffset(CGPointMake(0, 150), animated: true)
        }
        else if (textField == OldMotDePasse)
        {
            Scrollview.setContentOffset(CGPointMake(0, 200), animated: true)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        Scrollview.setContentOffset(CGPointMake(0, 0), animated: true)
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