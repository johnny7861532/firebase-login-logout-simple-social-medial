//
//  AddTravelViewController.swift
//  Logout
//
//  Created by Johnny' mac on 2016/3/29.
//  Copyright © 2016年 Johnny' mac. All rights reserved.
//

import UIKit
import Firebase
var imageRef: Firebase!
class AddTravelViewController: UIViewController {
    var currentUsername = ""
    var travelDate: NSTimeInterval = 0
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    @IBOutlet weak var travelDateLabel: UILabel!
       
    @IBOutlet weak var travelDatePicker: UIDatePicker!
    @IBOutlet weak var travelImageView: UIImageView!
    @IBOutlet weak var travelarticleFied: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get username of the current user, and set it to currentUsername, so we can add it to the Travel.\
        DataService.dataService.CURRENT_USER_REF.observeEventType(FEventType.Value, withBlock: { snapshot in
            let currentUser = snapshot.value.objectForKey("username")as! String
            
            print("Username: \(currentUser)")
            
            self.currentUsername = currentUser
            },withCancelBlock: { error in print(error.description)}
        )}
    
        
   
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveTravel(sender: AnyObject) {
        let travelText = travelarticleFied.text
        var data: NSData = NSData()
        if let image = travelImageView.image{
            data = UIImageJPEGRepresentation(image,0.1)!
       
            
        }
         let base64String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
         
        if travelText != ""{
            // Build the new Travel.
            // AnyObject is needed because of the likes of type Int.
            let newTravel: Dictionary<String, AnyObject > = [
                "travelText": travelText!,
                "photoBase64":base64String,
                "Date": travelDate,
                "Likes": 0,
                "author": currentUsername
                
                
            ]
            // Send it over to DataService to seal the deal.
            DataService.dataService.createNewTravel(newTravel)
            if let navController = self.navigationController{navController.popViewControllerAnimated(true)
            }
            
            
            
        }
                }
    @IBAction func Logout(sender: AnyObject) {
        // unauth() is the logout method for the current user.
        DataService.dataService.CURRENT_USER_REF.unauth()
        // Remove the user's uid from storage.
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        // Head back to Login!
        let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Login")
        UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
        
    }
    //設定時間
    func formatDate(date: NSDate) ->  String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let dateStr = dateFormatter.stringFromDate(date)
        return dateStr
    }

    
    @IBAction func datePicked(sender: AnyObject) {
    travelDate = travelDatePicker.date.timeIntervalSinceNow
    travelDateLabel.text =  formatDate(travelDatePicker.date)
    }
}
    //加入圖片
    extension AddTravelViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        // MARK:- UIImagePickerControllerDelegate methods
        
        func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            imagePicker.dismissViewControllerAnimated(true, completion: nil)
            travelImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        func imagePickerControllerDidCancel(picker: UIImagePickerController) {
            dismissViewControllerAnimated(true, completion: nil)
        }
        

    
    @IBAction func addPhoto(sender: AnyObject) {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera
            
            presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .PhotoLibrary
            imagePicker.delegate = self
            presentViewController(imagePicker, animated: true, completion:nil)
        }
        }

    }
    
    //鍵盤自動收起
    func textFieldShouldReturn(textField: UITextField) ->Bool{
        textField.resignFirstResponder()
        return true
    
    
    
    
    
}

