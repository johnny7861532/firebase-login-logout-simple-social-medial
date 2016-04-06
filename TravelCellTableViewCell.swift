//
//  TravelCellTableViewCell.swift
//  Logout
//
//  Created by Johnny' mac on 2016/3/28.
//  Copyright © 2016年 Johnny' mac. All rights reserved.
//

import UIKit
import Firebase

class TravelCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var travelDate: UILabel!
    @IBOutlet weak var travelText: UITextView!

    @IBOutlet weak var totalLikeLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
   
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var travelImge: UIImageView!
    var travel: Travel!
    var likeRef: Firebase!
    var imageRef: Firebase!
    
    func configureCell(travel: Travel){
        self.travel = travel
        // Set the labels and textView.
        self.travelText.text = travel.travelText
        self.totalLikeLabel.text = "Likes\(travel.travelLikes)"
        self.usernameLabel.text = travel.username
        self.travelDate.text =  "\(travel.travelDate)"
        self.travelImge.image = UIImage(named: "\(travel.base64String)")
        

        // Set "likes" as a child of the current user in Firebase and save the travel's key in votes as a boolean.
        likeRef = DataService.dataService.CURRENT_USER_REF.childByAppendingPath("Likes").childByAppendingPath(travel.travelkey)
         // observeSingleEventOfType() listens for the heart to be tapped, by any user, on any device.
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            // Set the like image.
            if let hearthollow = snapshot.value as? NSNull {
            // Current user hasn't liked for the travel... yet.
            print(hearthollow)
                self.likeImage.image = UIImage(named: "hearthollow")
               
            
            }
            else{
                 // Current user voted for the travel!
                self.likeImage.image = UIImage(named: "heartfull")
                                }
                
            
        
        
        })
         imageRef = DataService.dataService.CURRENT_USER_REF.childByAppendingPath("potoBase64").childByAppendingPath(travel.travelkey)
        imageRef.observeEventType(.Value, withBlock: { snapshot in
            
            let base64EncodedString = snapshot.value as? NSString
            let imageData = NSData(base64EncodedString: base64EncodedString as! String,options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        
            let decodedImage = UIImage(data:imageData!)
            self.travelImge.image = decodedImage
            
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        
    
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // UITapGestureRecognizer is set programatically.
        
        let tap = UITapGestureRecognizer(target: self, action: "likeTapped:")
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.userInteractionEnabled = true
        
    }
    func likeTapped(sender: UITapGestureRecognizer){
    // observeSingleEventOfType listens for a tap by the current user.
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let hearthollow = snapshot.value as? NSNull{
            print(hearthollow)
                self.likeImage.image = UIImage(named: "hearthollow")
                // addSubtractVote(), in Travel.swift, handles the vote.
                self.travel.addSubtractVote(true)
                // setValue saves the vote as true for the current user.
                // voteRef is a reference to the us/Users/apple/Desktop/程式專用/Logout-the-travel-master/Logout/Info.plister's "votes" path.
                self.likeRef.setValue(true)
            }else{
            self.likeImage.image = UIImage(named: "heartfull")
            self.travel.addSubtractVote(false)
            self.likeRef.removeValue()
            }
        
        })
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
