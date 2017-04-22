//
//  ConfirmPanierViewController.swift
//  ninakendosa
//
//  Created by Tho Bequet on 20/04/16.
//  Copyright © 2016 ninakendosa.com. All rights reserved.
//

import UIKit

class ConfirmPanierViewController: UIViewController, PayPalPaymentDelegate {
    
    var payPalConfig = PayPalConfiguration()    
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnectWithEnvironment(newEnvironment)
            }
        }
    }
    
    var acceptCreditCards:Bool = true {
        didSet {
            payPalConfig.acceptCreditCards = acceptCreditCards
        }
    }

    @IBOutlet weak var textAdresse: UITextField!
    @IBOutlet weak var textVille: UITextField!
    @IBOutlet weak var textCodePostal: UITextField!
    @IBOutlet weak var textTelephone: UITextField!
    @IBOutlet weak var labelPrixTotal: UILabel!
    
    var totalPrice: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelPrixTotal.text = "Total : " + String(totalPrice) + "0€"
        payPalConfig.acceptCreditCards = acceptCreditCards
        payPalConfig.merchantName = "Nina Kendosa"
        payPalConfig.merchantPrivacyPolicyURL = NSURL(string: "http://ninakendosa.com/fr/content/5-paiement-securise")
        payPalConfig.merchantUserAgreementURL = NSURL(string: "http://ninakendosa.com/fr/content/1-livraison")
        payPalConfig.languageOrLocale = NSLocale.preferredLanguages()[0]
        payPalConfig.payPalShippingAddressOption = .PayPal
        
        PayPalMobile.preconnectWithEnvironment(environment)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func payPalPaymentDidCancel(paymentViewController: PayPalPaymentViewController!) {
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func payPalPaymentViewController(paymentViewController: PayPalPaymentViewController!, didCompletePayment completedPayment: PayPalPayment!) {
        print(completedPayment.confirmation)
    }
    
    @IBAction func buttonConfirmerCommande(sender: UIButton) {
        let adresse = textAdresse.text
        let ville = textVille.text
        let codePostal = textCodePostal.text
        let telephone = textTelephone.text
        
        if (adresse == "" || ville == "" || codePostal == "" || telephone == "") {
            showErrorMessage("Tous les champs doivent être remplis.")
        }
        else if (matchesForRegexInText("^[1-9][0-9]*[, ][-a-zA-Z' ]+$", text: adresse, textField: textAdresse) == true && matchesForRegexInText("^[A-Za-z][A-Za-z-' ]+$", text: ville, textField: textVille) == true && matchesForRegexInText("^[0-9]{5}$", text: codePostal, textField: textCodePostal) == true || matchesForRegexInText("^[0-9]{10}$", text: textTelephone.text, textField: textTelephone) == true)
        {
            // Création de la route à suivre
            var baseURL = "https://test3-nextjoey.c9users.io" // Url Du Serveur
            var route = "/commande/" + NSUserDefaults.standardUserDefaults().stringForKey("userIDNinaKendosa")! + "/" + String(totalPrice) + "/"
            route += adresse! + "/" + ville! + "/"
            route += codePostal! + "/" + telephone!
            
            baseURL = baseURL + route // Url De La Requete
            baseURL = baseURL.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            // Création de la requete
            let myUrl = NSURL(string: baseURL)
            let request = NSURLRequest(URL:myUrl!)
            // Requete à éxecuter
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
                
                // Check des erreurs
                if error != nil
                {
                    print("error=\(error)") // Affichage de l'erreur
                    return
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("ConfirmToPayPal", sender: sender)
                }
            }
            // Lance La Requete
            task.resume()
            let item1 = PayPalItem(name: "Nina Kendosa", withQuantity: 1, withPrice: NSDecimalNumber(double: totalPrice), withCurrency: "EUR", withSku: "Nina Kendosa-0001")
            let items = [item1]
            let subtotal = PayPalItem.totalPriceForItems(items)
            let livraison = NSDecimalNumber(string: "5.00")
            let tax = NSDecimalNumber(string: "0.00")
            let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: livraison, withTax: tax)
            let total = subtotal.decimalNumberByAdding(livraison).decimalNumberByAdding(tax)
            let payment = PayPalPayment(amount: total, currencyCode: "EUR", shortDescription: "Nina Kendosa", intent: .Sale)
            payment.items = items
            payment.paymentDetails = paymentDetails
            
            if (payment.processable) {
                let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
                presentViewController(paymentViewController, animated: true, completion: nil)
            }
            else {
                print("Payement impossible")
            }
        }
    }
    
    func showErrorMessage(message: String)
    {
        // Creation de l'alerte et assignation des messages
        let alert = UIAlertController(title: "Confirmer", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        // Ajout du bouton "OK"
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil) // Affichage de l'alerte
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
    
    
    @IBOutlet var Scrollview: UIScrollView!
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == textAdresse)
        {
            Scrollview.setContentOffset(CGPointMake(0, 0), animated: true)
        }
        if (textField == textVille)
        {
            Scrollview.setContentOffset(CGPointMake(0, 75), animated: true)
        }
        if (textField == textCodePostal)
        {
            Scrollview.setContentOffset(CGPointMake(0, 150), animated: true)
        }
        if (textField == textTelephone)
        {
            Scrollview.setContentOffset(CGPointMake(0, 150), animated: true)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        Scrollview.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    func setTextErrorColor(textField: UITextField) {
        textField.textColor = UIColor(red: 226/255, green: 131/255, blue: 134/255, alpha: 1)
    }
    
    func setTextCorrectColor(textField: UITextField) {
        textField.textColor = UIColor(red: 131/255, green: 188/255, blue: 141/255, alpha: 1)
    }
   
    @IBAction func textChangedAdresse(sender: UITextField) {
        matchesForRegexInText("^[1-9][0-9]*[, ][-a-zA-Z' ]+$", text: textAdresse.text, textField: textAdresse)
    }

    @IBAction func textChangedVille(sender: UITextField) {
        matchesForRegexInText("^[A-Za-z][A-Za-z-' ]+$", text: textVille.text, textField: textVille)
    }
    
    @IBAction func textChangedCodePostal(sender: UITextField) {
        matchesForRegexInText("^[0-9]{5}$", text: textCodePostal.text, textField: textCodePostal)
    }

    @IBAction func textChangedTelephone(sender: UITextField) {
        matchesForRegexInText("^[0-9]{10}$", text: textTelephone.text, textField: textTelephone)
    }
}
