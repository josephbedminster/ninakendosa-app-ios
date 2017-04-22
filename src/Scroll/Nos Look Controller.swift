//
//  Nos Look Controller.swift
//  ninakendosa
//
//  Created by Thomas Rolland on 14/04/2016.
//  Copyright © 2016 ninakendosa.com. All rights reserved.
//

import UIKit

class Nos_Look_Controller: UIViewController,iCarouselDelegate,iCarouselDataSource {
    
    @IBOutlet weak var DisplayView: iCarousel!
    var tableData: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DisplayView.type = iCarouselType.Linear
        DisplayView.contentMode = .ScaleAspectFit
        DisplayView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
        // Création de la route à suivre
        var baseURL = "https://test3-nextjoey.c9users.io" // Url Du Serveur
        let route = "/looks/"// Route De La Requete
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
                        // Get Valeur Grace Aux Cles
                        var i = 0
                        while i < convertedJsonIntoDict["retour"]![0].count {
                            print(convertedJsonIntoDict["retour"]![0][i]["url"] as? String)
                            self.tableData.addObject((convertedJsonIntoDict["retour"]![0][i]!["url"] as? String)!)
                            i += 1
                            print(self.tableData)
                        }
                        dispatch_async(dispatch_get_main_queue()) {
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
}
