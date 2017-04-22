//
//  Download Controller.swift
//  ninakendosa
//
//  Created by Thomas ROLLAND on 19/04/16.
//  Copyright © 2016 ninakendosa.com. All rights reserved.
//

import UIKit

class Download_Controller:  UIViewController, NSURLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate {
    
    var downloadTask: NSURLSessionDownloadTask!
    var backgroundSession: NSURLSession!
    
    @IBAction func startDownload(sender: AnyObject) {
        let url = NSURL(string: "http://ninakendosa.com/documents/bon-de-retour-fr.pdf")!
        downloadTask = backgroundSession.downloadTaskWithURL(url)
        downloadTask.resume()
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let destinationURLForFile = NSURL(fileURLWithPath: documentDirectoryPath.stringByAppendingString("/file.pdf"))
        
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
        }else{
            print("The task finished transferring data successfully")
        }
    }
}


