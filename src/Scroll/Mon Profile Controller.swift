//
//  Mon Profile Controller.swift
//  ninakendosa
//
//  Created by nextjoey on 19/04/2016.
//  Copyright © 2016 ninakendosa.com. All rights reserved.
//

import UIKit

class Mon_Profile_Controller:   UIViewController, NSURLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate {
    
    var downloadTask: NSURLSessionDownloadTask!
    var backgroundSession: NSURLSession!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBAction func startDownload(sender: AnyObject) {
        let url = NSURL(string: "http://ninakendosa.com/documents/bon-de-retour-fr.pdf")!
        downloadTask = backgroundSession.downloadTaskWithURL(url)
        downloadTask.resume()
    }
    
    @IBAction func buttonDeconnexion(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isConnectedNinaKendosa")
        self.performSegueWithIdentifier("ProfilToAccueil", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
        
        let backgroundSessionConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("backgroundSession")
        backgroundSession = NSURLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 1
    func URLSession(session: NSURLSession,
                    downloadTask: NSURLSessionDownloadTask,
                    didFinishDownloadingToURL location: NSURL){
        
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentDirectoryPath:String = path[0]
        let fileManager = NSFileManager()
        let destinationURLForFile = NSURL(fileURLWithPath: documentDirectoryPath.stringByAppendingString("/Echange-retour.pdf"))
        
        if fileManager.fileExistsAtPath(destinationURLForFile.path!){
            showFileWithPath(destinationURLForFile.path!)
        }
        else{
            do {
                try fileManager.moveItemAtURL(location, toURL: destinationURLForFile)
                // show file
                showFileWithPath(destinationURLForFile.path!)
            }catch{
                print("An error occurred while moving file to destination url")
            }
        }
    }
    // 2
    func URLSession(session: NSURLSession,
                    downloadTask: NSURLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                                 totalBytesWritten: Int64,
                                 totalBytesExpectedToWrite: Int64){
    }
    
    func showFileWithPath(path: String){
        let isFileFound:Bool? = NSFileManager.defaultManager().fileExistsAtPath(path)
        if isFileFound == true{
            let viewer = UIDocumentInteractionController(URL: NSURL(fileURLWithPath: path))
            viewer.delegate = self
            viewer.presentPreviewAnimated(true)
        }
    }
    
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController{
        return self
    }
    
    func URLSession(session: NSURLSession,task: NSURLSessionTask,
                    didCompleteWithError error: NSError?){
        downloadTask = nil
        
        if (error != nil) {
            print(error?.description)
        }
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