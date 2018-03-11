//
//  ViewController.swift
//  FilmFinder2
//
//  Created by Omar Ayman on 12/2/16.
//  Copyright © 2016 Omar Ayman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var textview: UITextView!

    @IBOutlet var Answer: UITextField!
 
    @IBOutlet var Wait: UIActivityIndicatorView!
    
    @IBAction func Reset(_ sender: UIButton) {
        viewDidLoad()
        Wait.stopAnimating()
        
    }
    
    var msg:String = ""
    var uuid:String = ""
    
   
    @IBAction func Send(_ sender: UIButton) {
        let answer = Answer.text
        Wait.startAnimating()
        
        // Editing the body of the post request
        let json = [ "message":answer!]
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            
            // Send HTTP GET Request
            // Define server side URL
            
            let scriptUrl = "https://blooming-cove-58079.herokuapp.com/chat"
            
            // Create NSURL Ibject
            let myUrl = NSURL(string: scriptUrl);
            
            // Creaste URL Request
            let request = NSMutableURLRequest(url:myUrl! as URL);
            
            
            // Set request HTTP method to post
            request.httpMethod = "POST"
            
            //set authorization
            request.setValue(uuid, forHTTPHeaderField: "Authorization")
            //set content-type
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            //set the body of the post request
            request.httpBody = jsonData
            //        request.HTTPBody?.setValue("search", forKey: "message")
            
            //create the task that retrieves the content of URL based on a its request
            
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                // Check for error
                if error != nil
                {
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                // Print out response string
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("responseString = \(responseString)")
                
                // Convert server json response to NSDictionary
                do {
                    //Returns an object(dictionary) from given json data
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        
                        // Print out dictionary
                        print(convertedJsonIntoDict)
                        
                        
                        // Get value by key
                        self.msg = (convertedJsonIntoDict["message"] as? String)!
                        
                        
                        print(self.msg)
                        
                        DispatchQueue.main.async {
                            self.textview.text=self.msg
                        }
                        
                        
                        
                    }
                } catch let error as NSError {
                    print("ERROR!"+error.localizedDescription)
                }
                
                
                
            }
            
            task.resume()
            
        } catch {
            print("JSON serialization failed:  \(error)")
        }
    }

    
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        // Send HTTP GET Request
        
        // Define server side URL
        let scriptUrl = "https://blooming-cove-58079.herokuapp.com/welcome"
        // Create NSURL Ibject
        let myUrl = NSURL(string: scriptUrl);
        
        // Creaste URL Request
        let request = NSMutableURLRequest(url:myUrl! as URL);
        
        // Set request HTTP method to GET
        request.httpMethod = "GET"
        
        //create the task that retrieves the content of URL based on a its request
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(responseString)")
            
            
            
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    // Print out dictionary
                    print(convertedJsonIntoDict)
                    
                    
                    // Get value by key
                    let message = convertedJsonIntoDict["message"] as? String
                    self.uuid = (convertedJsonIntoDict["uuid"] as? String)!
                    
                    print(message!)
                    print(self.uuid)
                    
                    
                    
//                    dispatch_async(DispatchQueue.main) {
//                        self.textView.text=message
//                    }
                    
                    DispatchQueue.main.async {
                        self.textview.text=message
                    }
                    
                    
                }
            } catch let error as NSError {
                print("ERROR!"+error.localizedDescription)
            }
            
        }
        
        task.resume()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}


