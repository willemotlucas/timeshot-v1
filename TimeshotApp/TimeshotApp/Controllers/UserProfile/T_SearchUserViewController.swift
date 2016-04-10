//
//  T_SearchUserViewController.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 22/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import Parse

class T_SearchUserViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var filteredUsers: [T_User] = []
    var users: [T_User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        T_DesignHelper.colorNavBar(self.navigationController!.navigationBar)
        
        T_UserParseHelper.gettAllUsers { (result: [PFObject]?, error: NSError?) in
            self.users = result as? [T_User] ?? []
            self.tableView.reloadData()
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
        cell.userFirstAndLastNameLabel.text = user.firstName! + " " + user.lastName!
        cell.usernameLabel.text = user.username
        cell.user = user
        
        return cell
    }
}



extension T_SearchUserViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            let filteredUsername = searchText.isEmpty ? users: users.filter({(user: T_User) -> Bool in
                return user.username!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            })
            let filteredFirstName = searchText.isEmpty ? users: users.filter({(user: T_User) -> Bool in
                if !filteredUsername.contains(user) {
                    return user.firstName!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
                } else {
                    return false
                }
            })
            let filteredLastName = searchText.isEmpty ? users: users.filter({(user: T_User) -> Bool in
                if !filteredUsername.contains(user) {
                    return user.lastName!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
                } else {
                    return false
                }
            })
            
            self.filteredUsers = filteredUsername + filteredFirstName + filteredLastName
        } else {
            filteredUsers = []
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
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
}

extension T_SearchUserViewController: AddNewFriends {
    func sendUserSelected(userSelected: T_User) {
        print("send user selected")
        T_FriendRequestParseHelper.sendFriendRequest(userSelected)
    }
}
