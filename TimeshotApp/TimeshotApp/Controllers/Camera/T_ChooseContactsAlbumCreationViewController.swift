//
//  T_ChooseContactsAlbumCreationViewController.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 28/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_ChooseContactsAlbumCreationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var friendAddedItem: UIBarButtonItem!
    var friendAddedLabel:UILabel!
    
    @IBOutlet weak var bottomBar: UIToolbar!
    
    var createButton:UIBarButtonItem!
    
    let friends = ["Laurie Boulanger", "Antoine Jeannot", "Valentin Paul", "Lucas Willemot", "Karim Lamouri", "Antoine Chwatacz", "Clément Dubois", "Alexandre Delarouzée", "Théo Hordequin", "Florian Cartier", "Thibaut Sannier", "Tanguy Lucci", "Romain Marlot", "Pauline Bento", "Pauline Burg", "Théo Bastoul", "Laurène Gigandet"]
    
    var friendCells:[T_FriendAddedToAlbum] = []
    
    //MARK: Outlets methods
    
    @IBAction func actionBackButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: {});
    }
    
    func actionCreateButton(sender: AnyObject) {
    
        print("Album Created with : \n")
        for friend in T_FriendAddedToAlbum.selectedFriends
        {
            print("   - \(friend.name)")
        }
        self.presentingViewController?.presentingViewController!.dismissViewControllerAnimated(false, completion: {})
    }
    
    //MARK: System Methods
    override func prefersStatusBarHidden() -> Bool {
        return false
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
        
        self.createButton = UIBarButtonItem(title: "Creer   ", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(T_ChooseContactsAlbumCreationViewController.actionCreateButton(_:)))
        
        self.createButton.tintColor = UIColor.blackColor()
        
        self.friendAddedLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        self.friendAddedLabel.text = "Select some friends to start !"
        self.friendAddedLabel.sizeToFit()
        self.friendAddedLabel.backgroundColor = UIColor.clearColor()
        self.friendAddedLabel.textAlignment = .Left
        self.friendAddedItem.customView = self.friendAddedLabel
        
        for i in 0..<friends.count {
            self.friendCells.append(T_FriendAddedToAlbum(n: friends[i], p: UIImage(named: "SelfySample")!))
        }
    }

    //MARK: - TableView Datasource and Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("addFriendToAlbumCell", forIndexPath: indexPath) as! T_AddFriendToAlbumTableViewCell

        if (friendCells[indexPath.row].isSelected()) {
            selectFriendDesign(cell)
        }
        else {
            unselectFriendDesign(cell)
        }
        
        cell.backgroundColor = UIColor.whiteColor()
        cell.label.text = "\(friendCells[indexPath.row].name)"
        cell.selectionStyle = .None
        cell.setProfilPicture(friendCells[indexPath.row].picture)
        return cell
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
        
        updateLabel()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func selectFriendDesign(cell: T_AddFriendToAlbumTableViewCell)
    {
        cell.checkbox.image = UIImage(named: "checkbox-active")
        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        cell.label.font = UIFont.boldSystemFontOfSize(15)
    }
    
    func unselectFriendDesign(cell: T_AddFriendToAlbumTableViewCell)
    {
        cell.checkbox.image = UIImage(named: "checkbox")
        cell.backgroundColor = UIColor.whiteColor()
        cell.label.font = UIFont.systemFontOfSize(15)
    }

    func updateLabel()
    {
        if (T_FriendAddedToAlbum.nbSelected == 0) {
            self.friendAddedLabel.text = "Select some friends to start !"
            self.friendAddedLabel.sizeToFit()
            if (self.bottomBar.items?.indexOf(self.createButton) != nil)
            {
                self.bottomBar.items?.removeLast()
            }
        }
        else {
            if (T_FriendAddedToAlbum.nbSelected == 1)
            {
                self.friendAddedLabel.text = "\(T_FriendAddedToAlbum.nbSelected) friend selected"
            }
            else
            {
                self.friendAddedLabel.text = "\(T_FriendAddedToAlbum.nbSelected) friends selected"
            }
            self.friendAddedLabel.sizeToFit()
            
            if (self.bottomBar.items?.indexOf(self.createButton) == nil)
            {
                self.bottomBar.items?.append(self.createButton)
            }

        }
    }
}