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
import DZNEmptyDataSet
import PullToRefresh

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
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var addFriendsButton: UIButton!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    // MARK : Properties
    var contentToDisplay : ContentType = .Friends //Useful for segmented control

    var friends: [T_User] = []
    var pendingRequests: [T_FriendRequest] = []
    var sectionTitles = ["Pending requests", "Friends"]
    
    var albumRequests: [T_AlbumRequest] = []
    var currentAlbumRequest: T_AlbumRequest?
    
    let contacts = T_ContactsHelper.getAllContacts() //All the contacts of the current user
    
    var currentUser: T_User?
    
    var photoTakingHelper: T_PhotoTakingHelper?
    
    let refresher = PullToRefresh()
    

    // MARK: Overrided functions
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let userLogged = PFUser.currentUser() {
            self.currentUser = userLogged as? T_User
            self.title = self.currentUser!.firstName! + " " + self.currentUser!.lastName!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = profileView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        //Add pull to refresh
        self.tableView.addPullToRefresh(refresher, action: {
            self.loadFriendsData()
            self.loadNotificationsData()
        })
        
        //Load table view data
        self.loadFriendsData()
        self.loadNotificationsData()
        
        //Load profile picture
        T_ParseUserHelper.getCurrentUser()?.downloadImage()
        T_ParseUserHelper.getCurrentUser()?.image.bindTo(self.profileImageView.bnd_image)
        
        // Set design with colors and gradient
        T_DesignHelper.colorUIView(profileView)
        T_DesignHelper.colorUIView(addFriendsButtonView)
        T_DesignHelper.colorNavBar(self.navigationController!.navigationBar)
        
        //Set username in label
        self.usernameLabel.text = "@\(T_ParseUserHelper.getCurrentUser()!.username!)"
        
        //Set profile picture design
        T_DesignHelper.makeRoundedImageView(self.profileImageView)
        self.profileImageView.layer.borderWidth = 2.0
        self.profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAlbumRequestSegue" {
            let albumRequestVC = segue.destinationViewController as! T_AlbumRequestViewController
            
            // Get the cell that generated this segue
            if let selectedAbumRequest = sender as? T_NotificationsTableViewCell {
                let indexPath = self.tableView.indexPathForCell(selectedAbumRequest)
                let albumRequest = self.albumRequests[(indexPath?.row)!]
                
                let album = albumRequest.toAlbum
                
                albumRequestVC.albumRequest = albumRequest
                albumRequestVC.album = album
                albumRequestVC.delegate = self
            }
        }
    }
    
    // MARK: Methods
    
    func loadFriendsData(){
        //Load the friends
        if self.friends.isEmpty {
            T_ParseUserHelper.getCurrentUser()?.getAllFriends({ (friends) in
                self.friends = friends
                self.tableView.reloadData()
                self.tableView.endRefreshing()
            })
        } else {
            T_ParseUserHelper.getCurrentUser()?.getAllFriendsFromParse({ (friends) in
                self.friends = friends
                self.tableView.reloadData()
                self.tableView.endRefreshing()
            })
        }
        
        //Load the friends pending requests
        T_FriendRequestParseHelper.getPendingFriendRequestToCurrentUser { (result: [PFObject]?, error:NSError?) in
            self.pendingRequests = result as? [T_FriendRequest] ?? []
            print(self.pendingRequests.count)
            self.tableView.reloadData()
            self.tableView.endRefreshing()
        }
    }
    
    func loadNotificationsData(){
        //Load the album pending requests
        T_ParseAlbumRequestHelper.getPendingAlbumRequestToCurrentUser { (result: [PFObject]?, error:NSError?) in
            self.albumRequests = result as? [T_AlbumRequest] ?? []
            self.tableView.reloadData()
            self.tableView.endRefreshing()
        }
    }
    
    // MARK: IBAction
    
    @IBAction func segmentedControlIndexChanged(sender: UISegmentedControl) {
        // Change the content of table view according to the segmented control
        switch segmentedControl.selectedSegmentIndex {
        case 0: contentToDisplay = .Friends
            self.tableView.allowsSelection = false
        case 1:
            contentToDisplay = .Notifications
            self.tableView.allowsSelection = true
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
                // Display alert to warn user that the app doesn't have access to his contact
                T_ContactsHelper.displayCantAddContactAlert(self)
            case .Authorized:
                // Show the contact list
                self.performSegueWithIdentifier("showContactSearch", sender: nil)
                
            case .NotDetermined:
                // Show the request access to address book
                T_ContactsHelper.promptForAddressBookRequestAccess(self)
            }
        }
        alertController.addAction(addressBookAction)
        
        let usernameAction = UIAlertAction(title: "Add by Username", style: .Default) {
            (action) in
            // Show the username search view
            self.performSegueWithIdentifier("showUserSearch", sender: nil)
        }
        alertController.addAction(usernameAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func changeProfilPictureButtonTapped(sender: UIButton) {
        photoTakingHelper = T_PhotoTakingHelper(viewController: self){
            (image: UIImage?) in
            T_ParseUserHelper.getCurrentUser()?.image.value = image
            T_ParseUserHelper.getCurrentUser()?.uploadImage()
            self.profileImageView.image = image
        }
    }
    
    @IBAction func cameraButtonTapped(sender: UIBarButtonItem) {
        T_HomePageViewController.showCameraViewControllerFromProfile()
    }
}

// MARK: extension

extension T_ProfileViewController: ModalViewControllerDelegate {
    func refreshTableView() {
        self.loadNotificationsData()
    }
}

extension T_ProfileViewController: UITableViewDelegate {

}

extension T_ProfileViewController: UITableViewDataSource {
    /*
    * According to the content to display, the number of section changes.
    * It can be between 0 & 2 for friends (nothing, pending request or friend, pending request & friend)
    * There is only one section for notifications
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        switch contentToDisplay {
        case .Friends:
            //If there are pending requests & friends to display, then there are 2 sections
            if self.pendingRequests.count > 0 && self.friends.count > 0 {
                return sectionTitles.count
            } else {
                return 1
            }
        case .Notifications:
            return 1
        }
    }
    
    /*
    * We get the title from the array sectionTitles. There are 2 possibilities : "Pending requests" or "Friends"
    * We display these titles according to pending requests and friends
    * For notifications tabs, we display no title
    */
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch contentToDisplay {
        case .Friends:
            // There are pending requests & friends, we display both titles
            if self.pendingRequests.count > 0 && self.friends.count > 0 {
                return sectionTitles[section]
            } // There is only pending request
            else if self.pendingRequests.count > 0 && self.friends.count == 0 {
                return sectionTitles[0]
            } //There is only friends
            else if self.pendingRequests.count == 0 && self.friends.count > 0 {
                return sectionTitles[1]
            } //There is nothing to display
            else {
                return ""
            }
        case .Notifications:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch contentToDisplay {
        case .Friends:
            // There are pending request & friends to display
            if self.pendingRequests.count > 0 && self.friends.count > 0 {
                // According to the section, we return the number of elements in pending requests or friends
                if section == 0 {
                    return self.pendingRequests.count
                } else {
                    return self.friends.count
                }
            } // There is only pending requests to display
            else if self.pendingRequests.count > 0 && self.friends.count == 0 {
                return self.pendingRequests.count
            } // There is only friends to display
            else if self.pendingRequests.count == 0 && self.friends.count > 0 {
                return self.friends.count
            } else {
                return 0
            }
        case .Notifications:
            return self.albumRequests.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch contentToDisplay {
        case .Friends:
            // There are pending request and friends to display
            if self.pendingRequests.count > 0 && self.friends.count > 0 {
                // The current cell to display is in first section, so it is a pending request
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
            if self.albumRequests.count > 0 {
                return createNotificationCell(indexPath)
            }
            else {
                return UITableViewCell()
            }
        }
    }
    
    /*
     * Creates a friend request cell and fill in with the full name of the user who send the request
     * Params:
     * - @indexPath : indexPath of the row to retrieve the user
     */
    func createFriendRequestCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("T_FriendRequestTableViewCell", forIndexPath: indexPath) as! T_FriendRequestTableViewCell
        let user = self.pendingRequests[indexPath.row].fromUser! as! T_User
        user.downloadImage()
        
        cell.delegate = self
        cell.friendRequest = self.pendingRequests[indexPath.row]
        cell.friend = user
        
        return cell
    }
    
    /*
     * Creates a friend cell and fill in with the full name of the user
     * Params:
     * - @indexPath : indexPath of the row to retrieve the user
     */
    func createFriendCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("T_FriendTableViewCell", forIndexPath: indexPath) as! T_FriendTableViewCell
        let user = self.friends[indexPath.row]
        user.downloadImage()
        cell.friend = user
        return cell
    }
    
    
    /*
     * Creates a friend cell and fill in with the full name of the user
     * Params:
     * - @indexPath : indexPath of the row to retrieve the user
     */
    func createNotificationCell(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("T_NotificationsTableViewCell", forIndexPath: indexPath) as! T_NotificationsTableViewCell
        let albumRequest = self.albumRequests[indexPath.row]
        let user = albumRequest.fromUser! as! T_User
        user.downloadImage()
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.friend = user
        cell.albumRequest = albumRequest
        cell.notificationTextLabel.text = "@\(user.username!) invited you to join \(albumRequest.toAlbum!.title!)!"
        cell.notificationHelpTextLabel.text = "Click to answer to the request"
        return cell
    }
}

extension T_ProfileViewController: UIScrollViewDelegate {
    /*
     * Fixes the segmented control to the top of the view when scrolling the profile
     */
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

extension T_ProfileViewController: DZNEmptyDataSetSource {
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        if contentToDisplay == .Friends {
            let str = "You have no friends yet 😟"
            let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
            return NSAttributedString(string: str, attributes: attrs)
        } else {
            let str = "You have no notifications..."
            let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
            return NSAttributedString(string: str, attributes: attrs)
        }
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        if contentToDisplay == .Friends {
            let str = "Invite some friends, it's more fun!"
            let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
            return NSAttributedString(string: str, attributes: attrs)
        } else {
            let str = "Create an album and share your photos!"
            let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
            return NSAttributedString(string: str, attributes: attrs)
        }
    }
    
    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return self.headerView.frame.size.height/2.0
    }
}

extension T_ProfileViewController: DZNEmptyDataSetDelegate {
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return true
    }
}

/*
 * Custom protocol defined in T_FriendRequestTableViewCell allowing us to communicate with view controller
 * when clicking on a button of specific cell
 */
extension T_ProfileViewController: TableViewUpdater {
    /*
     * Update the pending request section after accepting a pending request
     * Params:
     * - @pendingRequest : the pending request to remove of the section and to add in friends section
     */
    func updatePendingRequestsAfterAccepting(pendingRequest: T_FriendRequest) {
        self.pendingRequests.removeAtIndex(self.pendingRequests.indexOf(pendingRequest)!)
        let friend = pendingRequest.fromUser as! T_User
        self.friends.append(friend)
        tableView.reloadData()
    }
    
    /*
     * Update the pending request section after rejecting a pending request
     * Params:
     * - @pendingRequest : the pending request to remove of the section
     */
    func updatePendingRequestsAfterRejecting(pendingRequest: T_FriendRequest) {
        self.pendingRequests.removeAtIndex(self.pendingRequests.indexOf(pendingRequest)!)
        tableView.reloadData()
    }
}

