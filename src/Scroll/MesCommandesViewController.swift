//
//  MesCommandesViewController.swift
//  ninakendosa
//
//  Created by Tho Bequet on 21/04/16.
//  Copyright © 2016 ninakendosa.com. All rights reserved.
//

import UIKit

class MesCommandesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var commandeTableView: UITableView!

    var commandID: NSDictionary = NSDictionary()
    
    override func viewWillAppear(animated: Bool) {
        // Création de la route à suivre
        var baseURL = "https://test3-nextjoey.c9users.io" // Url Du Serveur
        let route = "/getCommandeForID/" + NSUserDefaults.standardUserDefaults().stringForKey("userIDNinaKendosa")! // Route De La Requete
        baseURL += route // Url De La Requete

        // Création de la requete
        let myUrl = NSURL(string: baseURL);
        let request = NSURLRequest(URL:myUrl!);
        // Requete à éxecuter
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
                    print(convertedJsonIntoDict)
                    self.commandID = convertedJsonIntoDict
                    dispatch_async(dispatch_get_main_queue()) {
                        self.commandeTableView.reloadData()
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        // Lance La Requete
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (commandID.count != 0) {
            return commandID["retour"]![0]!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommandeCell", forIndexPath: indexPath) as! CommandeTableViewCell
        // Initialisation des variables
        var commandeTotal = ""
        var commandeAdresse = ""
        var commandeVille = ""
        
        // Get Valeur Grace Aux Cles
        commandeTotal = "TOTAL : " + String(commandID["retour"]![0]![indexPath.row]["total"] as? Double)
        let commandeTotal2 = NSString(string: commandeTotal)
        commandeTotal = commandeTotal2.stringByReplacingOccurrencesOfString("Optional(", withString: "")
        if (commandeTotal.isEmpty == false) {
            commandeTotal.removeAtIndex(commandeTotal.endIndex.predecessor())
        }
        commandeAdresse = (commandID["retour"]![0]![indexPath.row]["adresse"] as? String)!
        commandeVille = (commandID["retour"]![0]![indexPath.row]["ville"] as? String)!
        var commandeDate = (commandID["retour"]![0]![indexPath.row]["date_de_creation"] as? String)!
        let comDate: NSString = NSString(string: commandeDate)
        commandeDate = comDate.stringByReplacingOccurrencesOfString("T00:00:00.000Z", withString: "")
        cell.labelTotalPrice.text = commandeTotal + "€"
        cell.labelVille.text = commandeVille
        cell.labelAdresse.text = commandeAdresse
        cell.labelCommande.text = "Commande du " + commandeDate
        return cell
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
