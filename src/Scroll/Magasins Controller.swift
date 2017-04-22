//
//  Magasins Controller.swift
//  ninakendosa
//
//  Created by Joseph BEDMINSTER on 14/04/16.
//  Copyright © 2016 ninakendosa.com. All rights reserved.
//

import UIKit
import MapKit

class Magasins_Controller: UIViewController {
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var label7: UILabel!
    @IBOutlet weak var label8: UILabel!
    @IBOutlet weak var label9: UILabel!
    @IBOutlet weak var label10: UILabel!
    @IBOutlet weak var label11: UILabel!
    @IBOutlet weak var label12: UILabel!
    @IBOutlet weak var label13: UILabel!
    @IBOutlet weak var label14: UILabel!
    @IBOutlet weak var label15: UILabel!
    @IBOutlet weak var label16: UILabel!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        //Centrer sur Paris (long lat = Louvre)
        let initialLocation = CLLocation(latitude: 48.860871, longitude: 2.338972)
        
        //Zone d'affichage
        let regionRadius: CLLocationDistance = 1000
        var labels = [label1, label2, label3, label4, label5, label6, label7, label8, label9, label10, label11, label12, label13, label14, label15, label16]
        var infos: [String] = []
        var store1title = ""
        var store1subtitle = ""
        var store1long = ""
        var store1lat = ""
        var doublelong = 0.0
        var doublelat = 0.0
        var annotations: [MKPointAnnotation] = []
        var i = 0
        
        // Création de la route à suivre
        var baseURL = "https://test3-nextjoey.c9users.io" // Url Du Serveur
        let route = "/magasins/" // Route De La Requete
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
            //print("responseString = \(responseString)") // Format JSON
            // Conversion de la réponse (Format JSON) vers un dictionnaire
            do {
                // Conversion
                if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    
                    //Declarer position des annotations
                    //Action de centrer
                    func centerMapOnLocation(location: CLLocation) {
                        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 10.5, regionRadius * 10.5)
                        self.mapView.setRegion(coordinateRegion, animated: true)
                    }
                    
                    centerMapOnLocation(initialLocation)
                    
                    while (i < convertedJsonIntoDict["retour"]![0].count) {
                        let pointAnnotation = MKPointAnnotation()
                        pointAnnotation.title = (convertedJsonIntoDict["retour"]![0][i]["nom"] as? String)!
                        infos.append(pointAnnotation.title!)
                        pointAnnotation.subtitle = (convertedJsonIntoDict["retour"]![0][i]["adresse"] as? String)!
                        infos.append(pointAnnotation.subtitle!)
                        store1long = (convertedJsonIntoDict["retour"]![0][i]["long"] as? String)!
                        store1lat = (convertedJsonIntoDict["retour"]![0][i]["lat"] as? String)!
                        doublelong = NSString(string: store1long).doubleValue
                        doublelat = NSString(string: store1lat).doubleValue
                        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: doublelong, longitude: doublelat)
                        annotations.append(pointAnnotation)
                        self.mapView.addAnnotation(pointAnnotation)
                        i = i + 1
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        var a = 0
                        while (a < infos.count) {
                            labels[a].text = infos[a]
                            a = a + 1
                        }
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        // Lance La Requete
        task.resume()
        // Do any additional setup after loading the view.
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
