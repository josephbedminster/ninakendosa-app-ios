//
//  Carousel Controller.swift
//  ninakendosa
//
//  Created by Thomas Rolland on 15/04/2016.
//  Copyright © 2016 ninakendosa.com. All rights reserved.
//

import UIKit

class Carousel_Controller: UIViewController, iCarouselDelegate, iCarouselDataSource {
    
    @IBOutlet weak var DisplayView: iCarousel!
    @IBOutlet weak var textProductName: UILabel!
    @IBOutlet weak var textProductPrice: UILabel!
    @IBOutlet weak var textProductRef: UILabel!
    @IBOutlet weak var textProductDesc: UILabel!
    @IBOutlet weak var textProductMat: UILabel!
    @IBOutlet weak var buttonColor1: UIButton!
    @IBOutlet weak var buttonColor2: UIButton!
    @IBOutlet weak var buttonColor3: UIButton!
    @IBOutlet weak var imageRecommandation1: UIImageView!
    @IBOutlet weak var imageRecommandation2: UIImageView!
    @IBOutlet weak var imageRecommandation3: UIImageView!
    @IBOutlet weak var buttonRecommandation1: UIButton!
    @IBOutlet weak var buttonRecommandation2: UIButton!
    @IBOutlet weak var buttonRecommandation3: UIButton!
    
    var tableData: NSMutableArray = NSMutableArray()
    var tableColor: NSMutableArray = NSMutableArray()
    var tableImage: NSMutableArray = NSMutableArray()
    var recomCategory = ""
    var productID = ""
    var categoryID = ""
    var currentColorID = ""
    var price = ""
    var imageDict: NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DisplayView.type = iCarouselType.Linear
        DisplayView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        switch categoryID {
        case "1":
            recomCategory = "5"
        case "2":
            recomCategory = "4"
        case "3":
            recomCategory = "1"
        case "4":
            recomCategory = "1"
        case "5":
            recomCategory = "5"
        case "6":
            recomCategory = "6"
        default:
            recomCategory = "6"
        }
        
        // Initialisation des variables
        var productName = "" // Init le nom du produit
        var productRef = "" // Init la ref du produit
        var productPrice = "" // Init le prix du produit
        var productDesc = "" // Init la description du produit
        var productMat = "" // Init la matiere du produit
        
        // Création de la route à suivre
        var baseURL = "https://test3-nextjoey.c9users.io" // Url Du Serveur
        var route = "/produit/" + self.productID // Route De La Requete
        baseURL = baseURL + route // Url De La Requete
        
        // Création de la requete
        var myUrl = NSURL(string: baseURL);
        var request = NSURLRequest(URL:myUrl!);
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
            if (!(responseString?.hasPrefix("<"))!)
            {
                // Conversion de la réponse (Format JSON) vers un dictionnaire
                do
                {
                    // Conversion
                    if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                        // Get Valeur Grace Aux Cles
                        productName = (convertedJsonIntoDict["retour"]![0]!["nom"] as? String)!
                        productRef = (convertedJsonIntoDict["retour"]![0]!["reference"] as? String)!
                        productPrice = (convertedJsonIntoDict["retour"]![0]!["prix"] as? String)!
                        self.price = (convertedJsonIntoDict["retour"]![0]!["prix"] as? String)!
                        productDesc = (convertedJsonIntoDict["retour"]![0]!["description"] as? String)!
                        productMat = (convertedJsonIntoDict["retour"]![0]!["matiere"] as? String)!
                        self.tableData.addObject((convertedJsonIntoDict["retour"]![0]!["images"] as? String)!)
                        if (convertedJsonIntoDict["retour"]![1].count > 0) {
                            self.changeColorButton(self.buttonColor1, id: convertedJsonIntoDict["retour"]![1][0]["id_couleur"] as! String)
                        }
                        if (convertedJsonIntoDict["retour"]![1].count > 1) {
                            self.changeColorButton(self.buttonColor2, id: convertedJsonIntoDict["retour"]![1][1]["id_couleur"] as! String)
                        }
                        if (convertedJsonIntoDict["retour"]![1].count > 2) {
                            self.changeColorButton(self.buttonColor3, id: convertedJsonIntoDict["retour"]![1][2]["id_couleur"] as! String)
                        }
                        self.imageDict = convertedJsonIntoDict
                        // Change Les Valeurs Des Textes et images
                        dispatch_async(dispatch_get_main_queue()) {
                            self.textProductName.text = "" + productName
                            self.textProductRef.text = "Ref: " + productRef
                            self.textProductPrice.text = "" + productPrice + " € TTC"
                            self.textProductDesc.text = "" + productDesc
                            self.textProductMat.text = "" + productMat
                            self.buttonColor1(self.buttonColor1)
                            self.DisplayView.reloadData()
                        }
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
        // Lance La Requete
        task.resume()
        
        // Création de la route à suivre
        baseURL = "https://test3-nextjoey.c9users.io" // Url Du Serveur
        route = "/categories/" + recomCategory + "/produits" // Route De La Requete
        baseURL += route // Url De La Requete
        
        // Création de la requete
        myUrl = NSURL(string: baseURL);
        request = NSURLRequest(URL:myUrl!);
        // Requete à éxecuter
        let task2 = NSURLSession.sharedSession().dataTaskWithRequest(request) {
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
                    var randoms = Array(0...(convertedJsonIntoDict["retour"]![0].count - 1))
                    randoms.removeAtIndex(self.removeExistentID(convertedJsonIntoDict))
                    srandom(UInt32(time(nil)))
                    var rand = (random() % randoms.count)
                    self.changeImageRecommandation(self.imageRecommandation1, productID: ((convertedJsonIntoDict["retour"]! as! NSArray)[0] as! Array)[randoms[rand]], button: self.buttonRecommandation1)
                    randoms.removeAtIndex(rand)
                    rand = (random() % randoms.count)
                    self.changeImageRecommandation(self.imageRecommandation2, productID: ((convertedJsonIntoDict["retour"]! as! NSArray)[0] as! Array)[randoms[rand]], button: self.buttonRecommandation2)
                    randoms.removeAtIndex(rand)
                    rand = (random() % randoms.count)
                    self.changeImageRecommandation(self.imageRecommandation3, productID: ((convertedJsonIntoDict["retour"]! as! NSArray)[0] as! Array)[randoms[rand]], button: self.buttonRecommandation3)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        // Lance La Requete
        task2.resume()
    }
    
    func removeExistentID(json: NSDictionary) -> Int {
        var i = 0
        while (i < json["retour"]![0].count) {
            if (((json["retour"]! as! NSArray)[0] as! NSArray)[i] as! String == productID) {
                return i
            }
            i += 1
        }
        return 0
    }
    
    func changeImageRecommandation(imageView: UIImageView, productID: String, button: UIButton) {
        var productImageURL = "" // Init l'image du produit
        
        // Création de la route à suivre
        var baseURL = "https://test3-nextjoey.c9users.io" // Url Du Serveur
        let route = "/produit/" + productID // Route De La Requete
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
                    productImageURL = (convertedJsonIntoDict["retour"]![0]!["images"] as? String)!
                    // Creation de la requete de l'image
                    let url = NSURL(string: productImageURL)
                    print(url)
                    // Donnée de l'image dans imageData
                    let imageData = NSData(contentsOfURL: url!)
                    // Change Les Valeurs Des Textes et images
                    dispatch_async(dispatch_get_main_queue()) {
                        imageView.image = UIImage(data: imageData!)
                        button.titleLabel?.text = productID
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        // Lance La Requete
        task.resume()
    }
    
    @IBAction func buttonRecommandation(sender: UIButton) {
        performSegueWithIdentifier("ProduitToProduit", sender: sender)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        var imageView : UIImageView!
        
        if view == nil {
            imageView = UIImageView(frame: CGRectMake(0, 0, 320, 510))
            imageView.contentMode = .ScaleToFill
        } else {
            imageView = view as! UIImageView
        }
        if (tableData.count > 0) {
            imageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: tableData.objectAtIndex(index) as! String)!)!)
        }
        return imageView
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return tableData.count
    }
    
    @IBAction func AddPanier(sender: UIButton) {
        if (NSUserDefaults.standardUserDefaults().boolForKey("isConnectedNinaKendosa") != true) {
            showErrorMessage("Vous devez être connecté pour ajouter ce produit à votre panier.")
            return
        }
        let baseURL = "https://test3-nextjoey.c9users.io" // Url Du Serveur
        let route = baseURL + "/addPanier/" + self.productID + "/" + NSUserDefaults.standardUserDefaults().stringForKey("userIDNinaKendosa")! + "/" + currentColorID + "/" + self.price
        // Sinon envoie de la requete au serveurParamétres à passer
        let url = NSURL(string: route) // URL du serveur
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: url!) // Creation de la requete au serveur
        // Envoi de la requete
        let task = session.dataTaskWithRequest(request) {
            data, response, error in
            // Check des erreurs
            if(error != nil) {
                return
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.showErrorMessage("Ajouté au panier.")
            }
        }
        task.resume() // Execution de la requete
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ProductToCategory"){
            let navDest = segue.destinationViewController as! UINavigationController
            let dest = navDest.viewControllers.first as! Pull_et_gillets_Controller
            dest.categorieID = categoryID
        }
        else if (segue.identifier == "ProduitToProduit") {
            let navDest = segue.destinationViewController as! UINavigationController
            let dest = navDest.viewControllers.first as! Carousel_Controller
            dest.productID = sender!.titleLabel!!.text!
            dest.categoryID = self.categoryID
        }
    }
    
    @IBAction func buttonReturn(sender: UIBarButtonItem) {
        performSegueWithIdentifier("ProductToCategory", sender: sender)
    }
    
    @IBAction func buttonColor1(sender: UIButton) {
        if (imageDict["retour"]![1].count > 0) {
            if ((imageDict["retour"]![1][0]!["url1"]) as! String != "") {
                tableData.removeAllObjects()
                currentColorID = imageDict["retour"]![1][0]!["id_couleur"] as! String
                self.tableData.addObject((imageDict["retour"]![1][0]!["url1"] as? String)!)
            }
            if ((imageDict["retour"]![1][0]!["url2"]) as! String != "") {
                self.tableData.addObject((imageDict["retour"]![1][0]!["url2"] as? String)!)
            }
            if ((imageDict["retour"]![1][0]!["url3"]) as! String != "") {
                self.tableData.addObject((imageDict["retour"]![1][0]!["url3"] as? String)!)
            }
            DisplayView.reloadData()
        }
    }
    
    @IBAction func buttonColor2(sender: UIButton) {
        if (imageDict["retour"]![1].count > 1) {
            if ((imageDict["retour"]![1][1]!["url1"]) as! String != "") {
                tableData.removeAllObjects()
                currentColorID = imageDict["retour"]![1][1]!["id_couleur"] as! String
                self.tableData.addObject((imageDict["retour"]![1][1]!["url1"] as? String)!)
            }
            if ((imageDict["retour"]![1][1]!["url2"]) as! String != "") {
                self.tableData.addObject((imageDict["retour"]![1][1]!["url2"] as? String)!)
            }
            if ((imageDict["retour"]![1][1]!["url3"]) as! String != "") {
                self.tableData.addObject((imageDict["retour"]![1][1]!["url3"] as? String)!)
            }
            DisplayView.reloadData()
        }
    }
    
    @IBAction func buttonColor3(sender: UIButton) {
        if (imageDict["retour"]![1].count > 2) {
            if ((imageDict["retour"]![1][2]!["url1"]) as! String != "") {
                tableData.removeAllObjects()
                currentColorID = imageDict["retour"]![1][2
                    ]!["id_couleur"] as! String
                self.tableData.addObject((imageDict["retour"]![1][2]!["url1"] as? String)!)
            }
            if ((imageDict["retour"]![1][2]!["url2"]) as! String != "") {
                self.tableData.addObject((imageDict["retour"]![1][2]!["url2"] as? String)!)
            }
            if ((imageDict["retour"]![1][2]!["url3"]) as! String != "") {
                self.tableData.addObject((imageDict["retour"]![1][2]!["url3"] as? String)!)
            }
            DisplayView.reloadData()
        }
    }
    
    func changeColorButton(button: UIButton, id: String) {
        // Création de la route à suivre
        var baseURL = "https://test3-nextjoey.c9users.io" // Url Du Serveur
        let route = "/color/" + id // Route De La Requete
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
            if (!(responseString?.hasPrefix("<"))!)
            {
                // Conversion de la réponse (Format JSON) vers un dictionnaire
                do
                {
                    // Conversion
                    if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                        let colorCode = convertedJsonIntoDict["retour"]![0][0]["code"] as! String
                        // Change Les Valeurs Des Textes et images
                        dispatch_async(dispatch_get_main_queue()) {
                            button.backgroundColor = self.hexStringToUIColor(colorCode)
                            button.hidden = false
                            button.userInteractionEnabled = true
                        }
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func showErrorMessage(message: String)
    {
        // Creation de l'alerte et assignation des messages
        let alert = UIAlertController(title: "Panier", message: message, preferredStyle: UIAlertControllerStyle.Alert)
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
