//
//  T_ProfileViewController.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 20/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
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
    var friends = ["Lucas Willemot", "Valentin Paul", "Romain Pellerin", "Paul Jeannot", "Gabriel Hurtado", "Maxime Churin", "Karim Lamouri"]
    var pendingRequests = ["Marie Daguin", "Alphonso Lupi"]
    var sectionTitles = ["Pending requests", "Friends"]
    var contentToDisplay : ContentType = .Friends
    let contacts = T_ContactsHelper.getAllContacts()

    // MARK: Overrided functions
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        T_DesignHelper.colorUIView(profileView)
        T_DesignHelper.colorUIView(addFriendsButtonView)
        T_DesignHelper.colorNavBar(self.navigationController!.navigationBar)
        //T_DesignHelper.colorSegmentedControl(segmentedControl)

        tableView.tableHeaderView = profileView
        tableView.delegate = self
        tableView.dataSource = self
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension T_ProfileViewController: UITableViewDelegate {

}

extension T_ProfileViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        switch contentToDisplay {
        case .Friends:
            return sectionTitles.count
        case .Notifications:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch contentToDisplay {
        case .Friends:
            return sectionTitles[section]
        case .Notifications:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch contentToDisplay {
        case .Friends:
            if indexPath.section == 0 {
                //Pending request cell
                let cell = tableView.dequeueReusableCellWithIdentifier("T_FriendRequestTableViewCell", forIndexPath: indexPath) as! T_FriendRequestTableViewCell
                cell.friendNameLabel.text = pendingRequests[indexPath.row]
                return cell
            } else {
                //Friend cell
                let cell = tableView.dequeueReusableCellWithIdentifier("T_FriendTableViewCell", forIndexPath: indexPath) as! T_FriendTableViewCell
                cell.friendNameLabel.text = friends[indexPath.row]
                return cell
            }
        case .Notifications:
            let cell = UITableViewCell()
            cell.textLabel?.text = "Valentin a commenté votre photo"
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch contentToDisplay {
        case .Friends:
            if section == 0 {
                return pendingRequests.count
            }
            else {
                return friends.count
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

