//
//  T_AddFriendToAlbumViewController.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 08/05/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import Parse
import DZNEmptyDataSet

class T_AddFriendToAlbumViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var friendAddedItem: UIBarButtonItem!
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var friendAddedLabel:UILabel!
    var createButton:UIBarButtonItem!
    var friendCells:[T_User]! = []
    
    var duration:Int!
    var cover:UIImage!
    var albumTitle:String!
    var album: T_Album?
    
    var isLoading = false
    var errorLoading = false
    
    //MARK: Outlets methods
    @IBAction func actionBackButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    func actionCreateButton(sender: AnyObject) {
        let usersSelected = friendCells.filter{$0.isSelected()}
        
        for user in usersSelected {
            T_ParseAlbumRequestHelper.sendAlbumRequestNotification(user)
            T_ParseAlbumRequestHelper.sendFriendRequest(user, toAlbum: album!)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: System Methods
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.setAnimationsEnabled(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    }
    
    override func viewDidLoad() {
        T_DesignHelper.colorNavBar(self.navigationBar)
        //self.backButton.tintColor = UIColor.whiteColor()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.createButton = UIBarButtonItem(title: "Add   ", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(T_AddFriendToAlbumViewController.actionCreateButton(_:)))
        
        self.createButton.tintColor = UIColor.blackColor()
        
        self.friendAddedLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        self.friendAddedLabel.text = NSLocalizedString("Select some friends to invite them !", comment: "")
        self.friendAddedLabel.sizeToFit()
        self.friendAddedLabel.backgroundColor = UIColor.clearColor()
        self.friendAddedLabel.textAlignment = .Left
        self.friendAddedItem.customView = self.friendAddedLabel
        
        // For DZNEmptyState
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        // Load the friends
        T_ParseUserHelper.getCurrentUser()?.getAllFriends({ (friends) in
            self.friendCells = friends
            
            // On delete d'abord tous nos amis qui font deja parti de l'album
            for user in (self.album?.attendees)! {
                if self.friendCells.contains(user) {
                    let index = self.friendCells.indexOf(user)
                    self.friendCells.removeAtIndex(index!)
                }
            }
            
            // Si notre tableau d'amis n'est pas vide alors on va faire la requete sur parse pour recuperer
            // Les requetes d'ajout deja fait
            
            if self.friendCells.isEmpty {
                // Si on a pu d'amis de dispo il faudrait faire une empty view stylé en mode: Ajoute plus d'amis
                self.isLoading = true
                self.tableView.reloadData()
            } else {
                T_ParseAlbumRequestHelper.getPendingAlbumRequestToCurrentAlbum(self.album!) { (result: [PFObject]?, error:NSError?) in
                    
                    if let _ = error {
                        self.errorLoading = true
                    }else {
                        let albumRequests = result as? [T_AlbumRequest] ?? []
                        
                        // Recuperation de tous les request User
                        let requestUser = albumRequests.map({$0.toUser})
                        
                        // Filtre de nos amis avec ceux qui sont deja dans les requests
                        for user in requestUser {
                            if self.friendCells.contains(user!) {
                                let index = self.friendCells.indexOf(user!)
                                self.friendCells.removeAtIndex(index!)
                            }
                        }
                        
                        self.isLoading = true
                    }
                    
                    
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    deinit {
        self.friendCells.removeAll()
        T_User.selectedFriends.removeAll()
        T_User.selectedFriends = []
    }
    
}



extension T_AddFriendToAlbumViewController : UITableViewDataSource, UITableViewDelegate{
    //MARK: - TableView Datasource and Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendCells.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("addToAlbumCell", forIndexPath: indexPath) as! T_AddToAlbumTableViewCell
        
        if (friendCells[indexPath.row].isSelected()) {
            selectFriendDesign(cell)
        }
        else {
            unselectFriendDesign(cell)
        }
        
        cell.label.text = "\(friendCells[indexPath.row].firstName!) \(friendCells[indexPath.row].lastName!)"
        cell.selectionStyle = .None
        
        self.friendCells[indexPath.row].downloadImage()
        cell.user = self.friendCells[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //        let contactCell = cell as! T_AddFriendToAlbumTableViewCell
        //
        //        if (friendCells[indexPath.row].isSelected()) {
        //            selectFriendDesign(contactCell)
        //        }
        //        else {
        //            unselectFriendDesign(contactCell)
        //        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! T_AddToAlbumTableViewCell
        
        friendCells[indexPath.row].changeStateFriendSelected()
        
        if (friendCells[indexPath.row].isSelected()) {
            selectFriendDesign(cell)
        }
        else {
            unselectFriendDesign(cell)
        }
        
        updateLabel()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    //MARK: Methods for designing cells
    func selectFriendDesign(cell: T_AddToAlbumTableViewCell)
    {
        cell.checkbox.image = UIImage(named: "Check")
        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        cell.label.font = UIFont.boldSystemFontOfSize(15)
    }
    
    func unselectFriendDesign(cell: T_AddToAlbumTableViewCell)
    {
        cell.checkbox.image = UIImage(named: "Uncheck")
        cell.backgroundColor = UIColor.whiteColor()
        cell.label.font = UIFont.systemFontOfSize(15)
    }
    
    func updateLabel()
    {
        if (T_User.selectedFriends.count == 0) {
            self.friendAddedLabel.text = NSLocalizedString("Select some friends to start !", comment: "")
            self.friendAddedLabel.sizeToFit()
            if (self.bottomBar.items?.indexOf(self.createButton) != nil)
            {
                self.bottomBar.items?.removeLast()
            }
        }
        else {
            if (T_User.selectedFriends.count == 1)
            {
                self.friendAddedLabel.text = NSLocalizedString("\(T_User.selectedFriends.count) friend selected", comment: "")
            }
            else
            {
                self.friendAddedLabel.text = NSLocalizedString("\(T_User.selectedFriends.count) friends selected", comment: "")
            }
            self.friendAddedLabel.sizeToFit()
            
            if (self.bottomBar.items?.indexOf(self.createButton) == nil)
            {
                self.bottomBar.items?.append(self.createButton)
            }
        }
    }
}



// MARK: - DZNEmptyState
extension T_AddFriendToAlbumViewController : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        // On est dans le cas ou on a pas encore de photos dans l'album
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        var str = ""
        
        if !isLoading && !errorLoading {
            str = NSLocalizedString("Wait ...", comment: "")
        } else if errorLoading {
            str = NSLocalizedString("There's a problem Captain", comment: "")
        } else if isLoading {
            str = NSLocalizedString("Ohhh noo", comment: "")
        }
        
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        var str = ""
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        
        if !isLoading && !errorLoading{
            str = NSLocalizedString("We're retrieving your friends", comment: "")
        } else if errorLoading{
            str = NSLocalizedString("Network is not available ... ", comment: "")
        } else if isLoading {
            str = NSLocalizedString("All your friends have already been invited   in this album ", comment: "")
        }
        
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        var image = UIImage()
        image.accessibilityFrame = CGRect(origin: CGPoint(x: scrollView.center.x,y: scrollView.center.y - 20), size: CGSize(width: 200, height: 200))
        if !isLoading && !errorLoading{
            image = UIImage.gifWithName("LoadingView")!
        }else if errorLoading{
            image = UIImage(named: "NoNetwork")!
        } else if isLoading {
            image = UIImage(named: "EmptyAddFriends")!
        }
        return image
    }
    
}


