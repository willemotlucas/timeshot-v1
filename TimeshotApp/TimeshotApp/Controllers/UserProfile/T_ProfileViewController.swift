//
//  T_ProfileViewController.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 20/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import Parse
import AddressBook
import AddressBookUI

enum ContentType {
    case Friends, Notifications
}

class T_ProfileViewController: UIViewController {
    // MARK: IBOutlet
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var addFriendsButtonView: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var addFriendsButton: UIButton!
    
    // MARK : Properties
    var friends: [T_User] = []
    var pendingRequests: [T_FriendRequest] = []
    var sectionTitles = ["Pending requests", "Friends"]
    var contentToDisplay : ContentType = .Friends
    let contacts = T_ContactsHelper.getAllContacts()
    var currentUser: T_User?

    // MARK: Overrided functions
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = profileView
        tableView.delegate = self
        tableView.dataSource = self
        
        if let userLogged = PFUser.currentUser() {
            self.currentUser = userLogged as? T_User
            self.title = self.currentUser!.firstName! + " " + self.currentUser!.lastName!
        }
        
        T_DesignHelper.colorUIView(profileView)
        T_DesignHelper.colorUIView(addFriendsButtonView)
        T_DesignHelper.colorNavBar(self.navigationController!.navigationBar)
        
        //Load the friends
        T_FriendRequestParseHelper.getAcceptedFriendRequest { (result: [PFObject]?, error:NSError?) in
            let acceptedRequests = result as? [T_FriendRequest] ?? []
            self.friends = T_FriendRequestParseHelper.getFriendsFromAcceptedRequests(acceptedRequests)
            self.tableView.reloadData()
        }
        
        //Load the pending requests
        T_FriendRequestParseHelper.getPendingFriendRequest { (result: [PFObject]?, error:NSError?) in
            self.pendingRequests = result as? [T_FriendRequest] ?? []
            self.tableView.reloadData()
        }
    }
    
    // MARK: IBAction
    
    @IBAction func segmentedControlIndexChanged(sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0: contentToDisplay = .Friends
        case 1: contentToDisplay = .Notifications
        default: break
        }
        
        tableView.reloadData()
    }
    
    @IBAction func addFriendsButtonTapped(sender: UIButton) {
        // Constructs the UIAlert
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        //Add actions to the UIAlert
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let addressBookAction = UIAlertAction(title: "Add from Address Book", style: .Default){
            (action) in
            // Callback function (closure) called when user selects address book
            let authorizationStatus = ABAddressBookGetAuthorizationStatus()
            
            switch authorizationStatus {
            case .Denied, .Restricted:
                T_ContactsHelper.displayCantAddContactAlert(self)
            case .Authorized:
                //let personViewController = ABPeoplePickerNavigationController()
                //self.presentViewController(personViewController, animated: true, completion: nil)
                self.performSegueWithIdentifier("showContactSearch", sender: nil)
                
            case .NotDetermined:
                T_ContactsHelper.promptForAddressBookRequestAccess(self)
            }
        }
        alertController.addAction(addressBookAction)
        
        let usernameAction = UIAlertAction(title: "Add by Username", style: .Default) {
            (action) in
            self.performSegueWithIdentifier("showUserSearch", sender: nil)
        }
        alertController.addAction(usernameAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

extension T_ProfileViewController: UITableViewDelegate {

}

extension T_ProfileViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        switch contentToDisplay {
        case .Friends:
            if self.pendingRequests.count > 0 && self.friends.count > 0 {
                return sectionTitles.count
            } else {
                return 1
            }
        case .Notifications:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch contentToDisplay {
        case .Friends:
            if self.pendingRequests.count > 0 && self.friends.count > 0 {
                return sectionTitles[section]
            } else if self.pendingRequests.count > 0 && self.friends.count == 0 {
                return sectionTitles[0]
            } else if self.pendingRequests.count == 0 && self.friends.count > 0 {
                return sectionTitles[1]
            } else {
                return ""
            }
        case .Notifications:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch contentToDisplay {
        case .Friends:
            if self.pendingRequests.count > 0 && self.friends.count > 0 {
                if indexPath.section == 0 {
                    //Pending request cell
                    return createFriendRequestCell(indexPath)
                } else {
                    //Friend cell
                    return createFriendCell(indexPath)
                }
            } else if self.pendingRequests.count > 0 && self.friends.count == 0 {
                return createFriendRequestCell(indexPath)
            } else if self.pendingRequests.count == 0 && self.friends.count > 0 {
                return createFriendCell(indexPath)
            } else {
                return UITableViewCell()
            }
        case .Notifications:
            let cell = UITableViewCell()
            cell.textLabel?.text = "Valentin a commenté votre photo"
            return cell
        }
    }
    
    func createFriendRequestCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("T_FriendRequestTableViewCell", forIndexPath: indexPath) as! T_FriendRequestTableViewCell
        let user = self.pendingRequests[indexPath.row].fromUser! as! T_User
        cell.delegate = self
        cell.friendNameLabel.text = user.firstName! + " " + user.lastName!
        cell.friendRequest = self.pendingRequests[indexPath.row]
        return cell
    }
    
    func createFriendCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("T_FriendTableViewCell", forIndexPath: indexPath) as! T_FriendTableViewCell
        let user = self.friends[indexPath.row]
        cell.friendNameLabel.text = user.firstName! + " " + user.lastName!
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch contentToDisplay {
        case .Friends:
            if self.pendingRequests.count > 0 && self.friends.count > 0 {
                if section == 0 {
                    return self.pendingRequests.count
                } else {
                    return self.friends.count
                }
            } else if self.pendingRequests.count > 0 && self.friends.count == 0 {
                return self.pendingRequests.count
            } else if self.pendingRequests.count == 0 && self.friends.count > 0 {
                return self.friends.count
            } else {
                return 0
            }
        case .Notifications:
            return 40
        }
    }
}

extension T_ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + headerView.bounds.height
        
        // Segment control
        let segmentViewOffset = profileView.frame.height - segmentedView.frame.height - offset
        var segmentTransform = CATransform3DIdentity
        
        // Scroll the segment view until its offset reaches the same offset at which the header stopped shrinking
        segmentTransform = CATransform3DTranslate(segmentTransform, 0, max(segmentViewOffset, -profileView.frame.height + segmentedView.frame.height), 0)
        
        segmentedView.layer.transform = segmentTransform
    }
}

extension T_ProfileViewController: TableViewUpdater {
    func updatePendingRequestsAfterAccepting(pendingRequest: T_FriendRequest) {
        self.pendingRequests.removeAtIndex(self.pendingRequests.indexOf(pendingRequest)!)
        let friend = pendingRequest.fromUser as! T_User
        self.friends.append(friend)
        tableView.reloadData()
    }
    
    func updatePendingRequestsAfterRejecting(pendingRequest: T_FriendRequest) {
        self.pendingRequests.removeAtIndex(self.pendingRequests.indexOf(pendingRequest)!)
        tableView.reloadData()
    }
}

