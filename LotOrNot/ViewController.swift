//
//  ViewController.swift
//  LotOrNot
//
//  Created by Jordan Ellis  on 12/16/16.
//  Copyright © 2016 Tophatter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lotImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    
    var _currentLotId = 0
    
    @IBAction func likeButtonClicked(sender: AnyObject) {
        print(self._currentLotId)
        loadNextLot()
    }
    
    @IBAction func cancelButtonClicked(sender: AnyObject) {
        
    }
    
    func loadNextLot(){
        
        let scriptUrl = "http://ec2-54-196-192-180.compute-1.amazonaws.com/products/next.json?access_token=72b132ca963c5ade9499bf32f6c29ad8"
        // Add one parameter
        // Create NSURL Ibject
        let myUrl = NSURL(string: scriptUrl);
        
        // Creaste URL Request
        let request = NSMutableURLRequest(URL:myUrl!);
        
        // Set request HTTP method to GET. It could be POST as well
        request.HTTPMethod = "GET"
        
        
        // Excute HTTP Request
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    
                    // Print out dictionary
                    print(convertedJsonIntoDict)
                    
                    // Get value by key
                    let imageUrl = convertedJsonIntoDict["primary_image"] as? String
                    self._currentLotId = (convertedJsonIntoDict["id"] as? Int)!
                    
                    if let url = NSURL(string: imageUrl!) {
                        if let data = NSData(contentsOfURL: url) {
                            self.lotImage.image = UIImage(data: data)
                            self.lotImage.reloadInputViews()
                        }
                    }
                    
                    print(imageUrl)
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
        
    }
    
    func likeLot(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadNextLot()

    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

