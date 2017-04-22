//
//  ViewController.swift
//  testConnexion
//
//  Created by Tho Bequet on 12/04/16.
//  Copyright © 2016 Tho Bequet. All rights reserved.
//


class ViewController: UIViewController {
    
    @IBOutlet weak var requestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (sender === requestButton){
            if (segue.identifier == "productPage") {
                let dest = segue.destinationViewController as! ViewControllerProductPage2
                dest.productID = (sender.titleLabel?!.text)!
            }
        }
    }

    @IBAction func boutonRequete(sender: UIButton) {
        performSegueWithIdentifier("productPage", sender: sender)
    }
}

