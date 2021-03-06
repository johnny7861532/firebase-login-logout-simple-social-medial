//
//  Travel.swift
//  Logout
//
//  Created by Johnny' mac on 2016/3/24.
//  Copyright © 2016年 Johnny' mac. All rights reserved.
//

import Foundation
import Firebase
class Travel {
    private var _travelRef: Firebase!
    private var _travelkey: String!
    private var _base64String: NSString?
    private var _travelText: String!
    private var _username: String!
    private var _travelLikes: Int!
    private var _datePicker: NSTimeInterval!
    
    var travelkey:String{
    return _travelkey
    }
    var travelText:String{
    return _travelText
    }
    var username:String{
    return _username
    }
    var travelLikes: Int{
    return _travelLikes
    }
    var travelDate: NSTimeInterval{
    return _datePicker
    }
    var base64String: NSString?{
    return _base64String
    }
// Initialize the new Travel
    
    init(key:String, dictionary:Dictionary<String, AnyObject> )
    {
    self._travelkey = key
    
// Within the Travel, or Key, the following properties are children
        if let travel = dictionary["travelText"]as? String
        {
        self._travelText = travel
        }
        if let likes = dictionary["Likes"]as? Int
        {
        self._travelLikes = likes
        }
        if let user = dictionary["author"]as? String
        {
        self._username = user
        }else{
        self._username = ""
        }
        if let date = dictionary["Date"]as? NSTimeInterval{
        self._datePicker = date
        }
        if let image = dictionary["potoBase64"]as? String{
        self._base64String = image
        }
        // The above properties are assigned to their key.
        self._travelRef = DataService.dataService.TRAVEL_REF.childByAppendingPath(self._travelkey)
        
    }
    
    
    func addSubtractVote(addLike: Bool){
        if addLike{
        _travelLikes = _travelLikes + 1
        }
        else{
        _travelLikes = _travelLikes - 1
        }
        // Save the new likes total.
        _travelRef.childByAppendingPath("Likes").setValue(_travelLikes)
    
    }


}
