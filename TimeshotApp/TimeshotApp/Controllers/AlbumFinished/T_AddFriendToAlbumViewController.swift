//
//  T_AddFriendToAlbumViewController.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 08/05/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

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
    
    //MARK: Outlets methods
    @IBAction func actionBackButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    func actionCreateButton(sender: AnyObject) {
        print("coucou je t'invite toi")
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
        self.friendAddedLabel.text = "Select some friends to invite them !"
        self.friendAddedLabel.sizeToFit()
        self.friendAddedLabel.backgroundColor = UIColor.clearColor()
        self.friendAddedLabel.textAlignment = .Left
        self.friendAddedItem.customView = self.friendAddedLabel
        
        //Load the friends
        
        T_ParseUserHelper.getCurrentUser()?.getAllFriends({ (friends) in
            self.friendCells = friends
            self.tableView.reloadData()
            
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
            self.friendAddedLabel.text = "Select some friends to start !"
            self.friendAddedLabel.sizeToFit()
            if (self.bottomBar.items?.indexOf(self.createButton) != nil)
            {
                self.bottomBar.items?.removeLast()
            }
        }
        else {
            if (T_User.selectedFriends.count == 1)
            {
                self.friendAddedLabel.text = "\(T_User.selectedFriends.count) friend selected"
            }
            else
            {
                self.friendAddedLabel.text = "\(T_User.selectedFriends.count) friends selected"
            }
            self.friendAddedLabel.sizeToFit()
            
            if (self.bottomBar.items?.indexOf(self.createButton) == nil)
            {
                self.bottomBar.items?.append(self.createButton)
            }
        }
    }
}

