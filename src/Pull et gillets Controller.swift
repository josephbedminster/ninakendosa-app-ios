//
//  Pull et gillets Controller.swift
//  ninakendosa
//
//  Created by Joseph BEDMINSTER on 14/04/16.
//  Copyright © 2016 ninakendosa.com. All rights reserved.
//

import UIKit

class Pull_et_gillets_Controller: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var tableData: [String] = []    
    var categorieID: String = ""
    
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    override func viewWillAppear(animated: Bool) {
        // Création de la route à suivre
        var baseURL = "https://test3-nextjoey.c9users.io" // Url Du Serveur
        let route = "/categories/" + categorieID + "/produits" // Route De La Requete
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
                    var i: Int = 0
                    while (i < convertedJsonIntoDict["retour"]?[0].count)
                    {
                        self.tableData.append(((convertedJsonIntoDict["retour"] as! NSArray)[0] as! NSArray)[i] as! String)
                        i += 1
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        self.productCollectionView.reloadData()
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
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ProduitCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("BaseCell", forIndexPath: indexPath) as! ProduitCollectionViewCell
        // Initialisation des variables
        var productName = "" // Init le nom du produit
        var productPrice = "" // Init le prix du produit
        var productImageURL = "" // Init l'image du produit
        
        // Création de la route à suivre
        var baseURL = "https://test3-nextjoey.c9users.io" // Url Du Serveur
        let route = "/produit/" + tableData[indexPath.row]// Route De La Requete
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
                    productImageURL = (convertedJsonIntoDict["retour"]![0]!["images"] as? String)!
                    // Creation de la requete de l'image
                    let url = NSURL(string: productImageURL)
                    // Donnée de l'image dans imageData
                    let imageData = NSData(contentsOfURL: url!)
                    // Change Les Valeurs Des Textes et images
                    dispatch_async(dispatch_get_main_queue()) {
                        cell.textProductName.text = "" + productName
                        cell.textProductPrice.text = "" + productPrice + " €"
                        cell.imageProduct.image = UIImage(data: imageData!)
                        cell.buttonProduit.titleLabel?.text = self.tableData[indexPath.row]
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        // Lance La Requete
        task.resume()
        
        cell.textProductName.text = tableData[indexPath.row]
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "CategoriesToProduits") {
            let navDest = segue.destinationViewController as! UINavigationController
            let dest = navDest.viewControllers.first as! Carousel_Controller
            dest.productID = sender.titleLabel!!.text!
            dest.categoryID = self.categorieID
        }
    }
    
    @IBAction func buttonChangementPage(sender: UIButton) {
        performSegueWithIdentifier("CategoriesToProduits", sender: sender)
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