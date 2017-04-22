//
//  ViewControllerProductPage2.swift
//  testConnexion
//
//  Created by Tho Bequet on 13/04/16.
//  Copyright © 2016 Tho Bequet. All rights reserved.
//

import UIKit

class ViewControllerProductPage2: UIViewController {


    
    // LIER LES ZONES TEXTES
    @IBOutlet weak var imageProduct: UIImageView!
    // Zone texte pour le nom de produit
    @IBOutlet weak var textProductName: UILabel!
    // Zone texte pour la reference du produit
    @IBOutlet weak var textProductRef: UILabel!
    // Zone texte pour le prix du produit
    @IBOutlet weak var textProductPrice: UILabel!
    // Reference du produit
    var productID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialisation des variables
        var productName = "" // Init le nom du produit
        var productRef = "" // Init la ref du produit
        var productPrice = "" // Init le prix du produit
        var productImageURL = "" // Init l'image du produit
        
        // Création de la route à suivre
        var baseURL = "https://test3-nextjoey.c9users.io" // Url Du Serveur
        let route = "/produit/" + self.productID! // Route De La Requete
        baseURL = baseURL + route // Url De La Requete
        
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
            
            // Print Le Resultat De La Requete Dans La Console
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding) // Conversion de la réponse en string
            print("responseString = \(responseString)") // Format JSON
            
            
            // Conversion de la réponse (Format JSON) vers un dictionnaire
            do {
                // Conversion
                if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    
                    // Print Le Dictionnaire
                    print(convertedJsonIntoDict)
                    
                    // Get Valeur Grace Aux Cles
                    productName = (convertedJsonIntoDict["retour"]![0]!["nom"] as? String)!
                    productRef = (convertedJsonIntoDict["retour"]![0]!["reference"] as? String)!
                    productPrice = (convertedJsonIntoDict["retour"]![0]!["prix"] as? String)!
                    productImageURL = (convertedJsonIntoDict["retour"]![0]!["images"] as? String)!
                    // Creation de la requete de l'image
                    let url = NSURL(string: productImageURL)
                    // Donnée de l'image dans imageData
                    let imageData = NSData(contentsOfURL: url!)
                    
                    // Change Les Valeurs Des Textes et images
                    dispatch_async(dispatch_get_main_queue()) {
                        self.textProductName.text = "Nom : " + productName
                        self.textProductRef.text = "Reference : " + productRef
                        self.textProductPrice.text = "Prix : " + productPrice + " €"
                        self.imageProduct.image = UIImage(data: imageData!)
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        // Lance La Requete
        task.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
