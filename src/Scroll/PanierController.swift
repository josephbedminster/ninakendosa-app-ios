//
//  OutViewController4.swift
//  ninakendosa
//
//  Created by Thomas ROLLAND on 13/04/16.
//  Copyright © 2016 ninakendosa.com. All rights reserved.
//

import UIKit

class PanierController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var buttonValider: UIBarButtonItem!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var textTotalPrice: UILabel!
    
    var productsID: NSMutableArray = NSMutableArray()
    var product: [String: String] = [:]
    var productsPrice: NSMutableArray = NSMutableArray()
    
    var totalPrice: Double = 0.0 {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                self.textTotalPrice.text = "  " + String(self.quantity) + " Article(s): Total (hors livraison) : " + String(self.totalPrice) + "0 €"
            }
        }
    }
    
    var quantity: Int = 0 {
        didSet {
            if (quantity <= 0) {
                buttonValider.enabled = false
            }
            else {
                buttonValider.enabled = true
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.textTotalPrice.text = "  " + String(self.quantity) + " Article(s): Total (hors livraison) : " + String(self.totalPrice) + "0 €"
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if (quantity <= 0) {
            buttonValider.enabled = false
        }
        else {
            buttonValider.enabled = true
        }
        var i: Int = 0
        // Création de la route à suivre
        var baseURL = "https://test3-nextjoey.c9users.io" // Url Du Serveur
        let route = "/panier/" + NSUserDefaults.standardUserDefaults().stringForKey("userIDNinaKendosa")! // Route De La Requete
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
                    while (i < convertedJsonIntoDict["retour"]?[0].count)
                    {
                        self.product.updateValue(convertedJsonIntoDict["retour"]![0]![i]["id_produit"] as! String, forKey: "id_produit")
                        self.product.updateValue(convertedJsonIntoDict["retour"]![0]![i]["id_couleur"] as! String, forKey: "id_couleur")
                        self.product.updateValue(convertedJsonIntoDict["retour"]![0]![i]["quantite"] as! String, forKey: "quantite")
                        self.totalPrice += ((convertedJsonIntoDict["retour"]![0]![i]["prix"] as! Double) * Double(convertedJsonIntoDict["retour"]![0]![i]["quantite"] as! String)!)
                        self.quantity += Int(convertedJsonIntoDict["retour"]![0]![i]["quantite"] as! String)!
                        self.productsID.addObject(self.product)
                        self.productsPrice.addObject(convertedJsonIntoDict["retour"]![0]![i]["prix"] as! Double)
                        i += 1
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        self.productTableView.reloadData()
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
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsID.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PanierCell", forIndexPath: indexPath) as! PanierTableViewCell
        // Initialisation des variables
        var productName = "" // Init le nom du produit
        var productPrice = "" // Init le prix du produit
        var productRef = ""
        var productImageURL = "" // Init l'image du produit
        
        // Création de la route à suivre
        var baseURL = "https://test3-nextjoey.c9users.io" // Url Du Serveur
        let route = "/produit/" + (productsID[indexPath.row]["id_produit"] as! String)// Route De La Requete
        baseURL = baseURL + route // Url De La Requete
        
        // Création de la requete
        let myUrl = NSURL(string: baseURL);
        let request = NSURLRequest(URL:myUrl!);
        // Requete à éxecuter
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            // Check des erreurs
            if (error != nil)
            {
                print("error=\(error)") // Affichage de l'erreur
                return
            }
            // Conversion de la réponse (Format JSON) vers un dictionnaire
            do {
                // Conversion
                if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    
                    // Get Valeur Grace Aux Cles
                    productName = (convertedJsonIntoDict["retour"]![0]!["nom"] as? String)!
                    productPrice = (convertedJsonIntoDict["retour"]![0]!["prix"] as? String)!
                    productRef = (convertedJsonIntoDict["retour"]![0]!["reference"] as? String)!
                    var i = 0
                    while (i < convertedJsonIntoDict["retour"]![1]!.count) {
                        if (convertedJsonIntoDict["retour"]![1]![i]["id_couleur"] as! String == self.productsID[indexPath.row]["id_couleur"] as! String) {
                            productImageURL = (convertedJsonIntoDict["retour"]![1]![i]["url1"] as? String)!
                        }
                        i += 1
                    }
                    // Creation de la requete de l'image
                    let url = NSURL(string: productImageURL)
                    // Donnée de l'image dans imageData
                    let imageData = NSData(contentsOfURL: url!)
                    
                    // Change Les Valeurs Des Textes et images
                    dispatch_async(dispatch_get_main_queue()) {
                        cell.textProductName.text = productName
                        cell.textProductPrice.text = productPrice + " €"
                        cell.textProductRef.text = "Ref : " + productRef
                        let textQte = self.productsID[indexPath.row]["quantite"] as? String
                        cell.textProductQuantity.text = "QTE : " + textQte!
                        cell.imageProduct.image = UIImage(data: imageData!)
                        cell.productID = self.productsID[indexPath.row]["id_produit"] as! String
                        cell.colorID = self.productsID[indexPath.row]["id_couleur"] as! String
                        cell.quantite = self.productsID[indexPath.row]["quantite"] as! String
                        cell.productPrice = self.productsPrice[indexPath.row] as! Double
                        cell.arrayIndex = indexPath.row
                        cell.parent = self
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        // Lance La Requete
        task.resume()
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "PanierToConfirmation"){
            let navDest = segue.destinationViewController as! UINavigationController
            let dest = navDest.viewControllers.first as! ConfirmPanierViewController
            dest.totalPrice = totalPrice
        }
    }
}
