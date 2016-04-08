//
//  T_Friend.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 05/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import Parse
import Bond

class T_User : PFUser {
    
    @NSManaged var emailVerified:Bool
    @NSManaged var birthDate:NSDate
    @NSManaged var firstName:String
    @NSManaged var lastName:String
    @NSManaged var isDeleted:Bool
    @NSManaged var picture:PFFile?

    var image: Observable<UIImage?> = Observable(nil)
    
    static var selectedFriends:[T_User] = []

    private
    var selected:Bool

    //MARK: PFSubclassing Protocol
    override init () {
        self.selected = false
        
        super.init()
    }
    
    init(username: String, password:String, birthDate:NSDate, email:String, firstName:String, lastName:String, picture:PFFile)
    {
        self.selected = false

        super.init()
        
        self.username = username
        self.password = password
        self.birthDate = birthDate
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.isDeleted = false
        self.picture = picture
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
    func changeStateFriendSelected()
    {
        if(self.selected)
        {
            self.selected = false
            
            if let index = T_User.selectedFriends.indexOf(self)
            {
                T_User.selectedFriends.removeAtIndex(index)
            }
        }
        else {
            self.selected = true
            if (T_User.selectedFriends.indexOf(self) == nil)
            {
                T_User.selectedFriends.append(self)
            }
        }
    }
    
    func isSelected() -> Bool
    {
        return selected
    }

    static func reset() {
        selectedFriends.removeAll()
    }
    
    func downloadImage() {
        if (image.value == nil) {
            picture?.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                if let data = data {
                    let image = UIImage(data: data, scale:1.0)!
                    self.image.value = image
                    print("donwload ended")
                }
            }
        }
    }
    
    static func getAllUsers(withCompletion: (data: [T_User]) -> ())
    {
        let query = PFQuery(className:"_User")
        query.selectKeys(["firstName", "lastName", "picture"])
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if error == nil {
                withCompletion(data: objects as! [T_User])
            }
            else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }

    }
    
    
}