//
//  T_ChooseContactsAlbumCreationViewController.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 28/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import Parse
import Bond
import DZNEmptyDataSet

class T_ChooseContactsAlbumCreationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var createButtonView: UIView!
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var friendAddedItem: UIBarButtonItem!
    var friendAddedLabel:UILabel!
    
    
    var friendCells:[T_User]! = []
    
    var duration:Int!
    var cover:UIImage!
    var albumTitle:String!
    
    //MARK: Outlets methods
    
    @IBAction func actionBackButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: {});
    }
    
    @IBAction func createAlbumButtonTapped(sender: AnyObject) {
        T_CameraViewController.instance.showCameraView()
        T_CameraViewController.instance.freezeUI(NSLocalizedString("Creating album ...", comment: ""))
        T_Album.createAlbum(self.cover, duration: self.duration, albumTitle: self.albumTitle)
        self.presentingViewController?.dismissViewControllerAnimated(false, completion: nil)
    }
    
    //MARK: System Methods
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.setAnimationsEnabled(true)
    }

    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden=false
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    }
    
    override func viewDidLoad() {
        T_DesignHelper.colorNavBar(self.navigationController!.navigationBar)
        self.backButton.tintColor = UIColor.whiteColor()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.emptyDataSetDelegate = self
        self.tableView.emptyDataSetSource = self
        self.tableView.tableFooterView = UIView()
        
        T_DesignHelper.colorUIView(self.createButtonView)
        
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

extension T_ChooseContactsAlbumCreationViewController {
    //MARK: - TableView Datasource and Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendCells.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("addFriendToAlbumCell", forIndexPath: indexPath) as! T_AddFriendToAlbumTableViewCell

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
        
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! T_AddFriendToAlbumTableViewCell
        
        friendCells[indexPath.row].changeStateFriendSelected()
        
        if (friendCells[indexPath.row].isSelected()) {
            selectFriendDesign(cell)
        }
        else {
            unselectFriendDesign(cell)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    //MARK: Methods for designing cells
    func selectFriendDesign(cell: T_AddFriendToAlbumTableViewCell)
    {
        cell.checkbox.image = UIImage(named: "Check")
        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        cell.label.font = UIFont.boldSystemFontOfSize(15)
    }
    
    func unselectFriendDesign(cell: T_AddFriendToAlbumTableViewCell)
    {
        cell.checkbox.image = UIImage(named: "Uncheck")
        cell.backgroundColor = UIColor.whiteColor()
        cell.label.font = UIFont.systemFontOfSize(15)
    }
}


extension T_ChooseContactsAlbumCreationViewController : DZNEmptyDataSetSource {
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "EmptyAlbumIcon")
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: NSLocalizedString("You don't have any friends ... Please invite some friends and share your albums with them!", comment: ""))
    }

    func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
        return UIColor.whiteColor()
    }
}

extension T_ChooseContactsAlbumCreationViewController : DZNEmptyDataSetDelegate {
    
}