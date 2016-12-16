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
        print(self._currentLotId)
        loadNextLot()
    }
    
    func loadNextLot(){
        
        let scriptUrl = "http://ec2-54-196-192-180.compute-1.amazonaws.com/products/next.json?access_token=c7619c6ea91a73e026431da13aabb3f8"
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
                        /*
                         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                         UIImage * img = [UIImage imageNamed:@"background.jpg"];
                         
                         // Make a trivial (1x1) graphics context, and draw the image into it
                         UIGraphicsBeginImageContext(CGSizeMake(1,1));
                         CGContextRef context = UIGraphicsGetCurrentContext();
                         CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), [img CGImage]);
                         UIGraphicsEndImageContext();
                         
                         // Now the image will have been loaded and decoded and is ready to rock for the main thread
                         dispatch_sync(dispatch_get_main_queue(), ^{
                         [[self imageView] setImage: img];
                         });
                         });
 */
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {() -> Void in
                            if let data = NSData(contentsOfURL: url) {
                                var img = UIImage(data: data)
                                // Make a trivial (1x1) graphics context, and draw the image into it
                                UIGraphicsBeginImageContext(CGSizeMake(1, 1))
                                var context = UIGraphicsGetCurrentContext()
                                CGContextDrawImage(context!, CGRectMake(0, 0, 1, 1), img!.CGImage!)
                                UIGraphicsEndImageContext()
                                // Now the image will have been loaded and decoded and is ready to rock for the main thread
                                dispatch_sync(dispatch_get_main_queue(), {() -> Void in
                                    self.lotImage!.image = img
                                })
                            }
                        })
                        //self.lotImage.reloadInputViews()
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

