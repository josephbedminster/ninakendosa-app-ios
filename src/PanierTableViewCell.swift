//
//  PanierTableViewCell.swift
//  ninakendosa
//
//  Created by Tho Bequet on 18/04/16.
//  Copyright © 2016 ninakendosa.com. All rights reserved.
//

import UIKit

class PanierTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var textProductName: UILabel!
    @IBOutlet weak var textProductPrice: UILabel!
    @IBOutlet weak var textProductRef: UILabel!
    @IBOutlet weak var textProductQuantity: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    var parent: PanierController = PanierController()
    var arrayIndex = 0
    var productID = ""
    var colorID = ""
    var quantite = ""
    var productPrice: Double = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func buttonRemoveItem(sender: UIButton) {
        let baseURL = "https://test3-nextjoey.c9users.io" // Url Du Serveur
        let route = baseURL + "/removePanier/" + self.productID + "/" + NSUserDefaults.standardUserDefaults().stringForKey("userIDNinaKendosa")! + "/" + colorID
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
                self.parent.productsID.removeObjectAtIndex(self.arrayIndex)
                self.parent.productsPrice.removeObjectAtIndex(self.arrayIndex)
                self.parent.totalPrice -= self.productPrice * Double(self.quantite)!
                self.parent.quantity -= Int(self.quantite)!
                self.parent.productTableView.reloadData()
            }
        }
        task.resume() // Execution de la requete
    }
}