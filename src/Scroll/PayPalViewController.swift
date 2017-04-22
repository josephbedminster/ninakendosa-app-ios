//
//  PayPalViewController.swift
//  ninakendosa
//
//  Created by Clovis DEROUCK on 21/04/16.
//  Copyright © 2016 ninakendosa.com. All rights reserved.
//

import UIKit

class PayPalViewController: UIViewController, PayPalPaymentDelegate {

    var payPalConfig = PayPalConfiguration()
    var totalPrice: Double = 30.0
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        payPalConfig.acceptCreditCards = acceptCreditCards
        payPalConfig.merchantName = "Nina Kendosa"
        payPalConfig.merchantPrivacyPolicyURL = NSURL(string: "http://ninakendosa.com/fr/content/5-paiement-securise")
        payPalConfig.merchantUserAgreementURL = NSURL(string: "http://ninakendosa.com/fr/content/1-livraison")
        payPalConfig.languageOrLocale = NSLocale.preferredLanguages()[0] 
        payPalConfig.payPalShippingAddressOption = .PayPal
        
        PayPalMobile.preconnectWithEnvironment(environment)
        // Do any additional setup after loading the view.
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
    
    @IBAction func buttonPayement(sender: UIButton) {
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
