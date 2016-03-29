//
//  T_FriendAddedToAlbum.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 29/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_FriendAddedToAlbum: Equatable {
    
    static var nbSelected:Int = 0
    static var count:Int = 0
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
        T_FriendAddedToAlbum.count += 1
    }
    
    func changeStateFriendSelected()
    {
        if(self.selected)
        {
            self.selected = false
            T_FriendAddedToAlbum.nbSelected -= 1
            
            if let index = T_FriendAddedToAlbum.selectedFriends.indexOf(self)
            {
                T_FriendAddedToAlbum.selectedFriends.removeAtIndex(index)
            }
        }
        else {
            self.selected = true
            T_FriendAddedToAlbum.nbSelected += 1
            if let index = T_FriendAddedToAlbum.selectedFriends.indexOf(self)
            {
            }
            else
            {
                T_FriendAddedToAlbum.selectedFriends.append(self)
            }
        }
    }
    
    func isSelected() -> Bool
    {
        return selected
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

