//
//  T_FriendAddedToAlbum.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 29/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_FriendAddedToAlbum: Equatable {
    
    static var selectedFriends:[T_FriendAddedToAlbum] = []
    
    var name:String
    var picture:UIImage
    
    private
    var selected:Bool
    
    init(n: String, p: UIImage)
    {
        self.name = n
        self.picture = p
        self.selected = false
        
        self.selected = false
    }
    
    deinit
    {
    }
    
    func changeStateFriendSelected()
    {
        if(self.selected)
        {
            self.selected = false
            
            if let index = T_FriendAddedToAlbum.selectedFriends.indexOf(self)
            {
                T_FriendAddedToAlbum.selectedFriends.removeAtIndex(index)
            }
        }
        else {
            self.selected = true
            if (T_FriendAddedToAlbum.selectedFriends.indexOf(self) == nil)
            {
                T_FriendAddedToAlbum.selectedFriends.append(self)
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
}

func ==(lhs: T_FriendAddedToAlbum, rhs: T_FriendAddedToAlbum) -> Bool
{
    if (lhs.name == rhs.name) {
        return true
    }
    else {
        return false
    }
}

