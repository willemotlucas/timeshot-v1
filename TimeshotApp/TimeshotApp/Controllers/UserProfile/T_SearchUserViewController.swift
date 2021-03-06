//
//  T_SearchUserViewController.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 22/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import Parse
import DZNEmptyDataSet

class T_SearchUserViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var filteredUsers: [T_User] = []
    var users: [T_User] = []
    var friends: [T_User] = []
    var pendingFriends: [T_User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        T_DesignHelper.colorNavBar(self.navigationController!.navigationBar)
        
        // Retrieve all the users stored in Parse database
        T_ParseUserHelper.gettAllUsers { (result: [PFObject]?, error: NSError?) in
            self.users = result as? [T_User] ?? []
        }
        
        T_ParseUserHelper.getCurrentUser()?.getAllFriends({ (friends) in
            self.friends = friends
        })
        
        T_ParseUserHelper.getCurrentUser()?.getAllPendingFriends({ (friends) in
            self.pendingFriends = friends
        })
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK/ IBAction
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension T_SearchUserViewController: UITableViewDelegate {
    
}

extension T_SearchUserViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("T_SearchUserTableViewCell") as! T_SearchUserTableViewCell
        
        let user = self.filteredUsers[indexPath.row] as T_User
        cell.delegate = self
        user.downloadImage()
        
        if self.friends.contains(user) {
            cell.addUserButton.setImage(UIImage(named: "checkbox-checked"), forState: .Disabled)
            cell.addUserButton.enabled = false
        } else if self.pendingFriends.contains(user) {
            cell.addUserButton.setImage(UIImage(named: "check-pending"), forState: .Disabled)
            cell.addUserButton.enabled = false
        } else {
            cell.addUserButton.setImage(UIImage(named: "add-friends-button"), forState: .Normal)
            cell.addUserButton.enabled = true
        }
        
        cell.user = user
        
        return cell
    }
}



extension T_SearchUserViewController: UISearchBarDelegate {
    
    /*
     * Allows to search in all users according to the search text.
     * Search is carried out on username, first name and last name
     */
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // We search if the search text is empty
        if !searchText.isEmpty {
            // First, we search for username
            let filteredUsername = searchText.isEmpty ? users: users.filter({(user: T_User) -> Bool in
                return user.username!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            })
            // Secondly, we search for first name
            let filteredFirstName = searchText.isEmpty ? users: users.filter({(user: T_User) -> Bool in
                if !filteredUsername.contains(user) {
                    return user.firstName!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
                } else {
                    return false
                }
            })
            // To finish, we search for last name
            let filteredLastName = searchText.isEmpty ? users: users.filter({(user: T_User) -> Bool in
                if !filteredUsername.contains(user) {
                    return user.lastName!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
                } else {
                    return false
                }
            })
            
            // We append 3 arrays together to display the results
            self.filteredUsers = filteredUsername + filteredFirstName + filteredLastName
        } else {
            filteredUsers = []
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        // Allows to display cancel button in white rather than blue
        for ob: UIView in ((self.searchBar.subviews[0] )).subviews {
            if let z = ob as? UIButton {
                let btn: UIButton = z
                btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            }
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        filteredUsers = []
        tableView.reloadData()
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension T_SearchUserViewController: DZNEmptyDataSetSource {
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        if self.searchBar.text!.isEmpty {
            let str = "Search a user!"
            let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
            return NSAttributedString(string: str, attributes: attrs)
        } else {
            let str = "Nobody have been found ..."
            let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
            return NSAttributedString(string: str, attributes: attrs)
        }
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        if self.searchBar.text!.isEmpty {
            let str = "You can search by his full name or username."
            let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
            return NSAttributedString(string: str, attributes: attrs)
        } else {
            let str = "Try another username or invite contacts from your address book!"
            let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
            return NSAttributedString(string: str, attributes: attrs)
        }
    }
    
    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return -(self.tableView.frame.height/3)
    }
}

extension T_SearchUserViewController: DZNEmptyDataSetDelegate {
    
}

extension T_SearchUserViewController: AddNewFriends {
    func sendUserSelected(userSelected: T_User) {
        // Il faut ajouter le user aux pendings, sinon l'image ne va pas rester a pending
        pendingFriends.append(userSelected)
        T_FriendRequestParseHelper.sendFriendRequestNotification(userSelected)
        T_FriendRequestParseHelper.sendFriendRequest(userSelected)
    }
}
