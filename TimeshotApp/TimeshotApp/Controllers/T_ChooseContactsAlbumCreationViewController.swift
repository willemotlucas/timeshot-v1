//
//  T_ChooseContactsAlbumCreationViewController.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 28/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_ChooseContactsAlbumCreationViewController: UITableViewController {

    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var createButton: UIBarButtonItem!

    let friends = ["Laurie Boulanger", "Antoine Jeannot", "Valentin Paul", "Lucas Willemot", "Karim Lamouri", "Antoine Chwatacz", "Clément Dubois", "Alexandre Delarouzée", "Théo Hordequin", "Florian Cartier", "Thibaut Sannier", "Tanguy Lucci", "Romain Marlot", "Pauline Bento", "Pauline Burg", "Théo Bastoul", "Laurène Gigandet"]
    
    var selectedFriends:[T_AddFriendToAlbumTableViewCell] = []
    
    //MARK: Outlets methods
    @IBAction func actionBackButton(sender: AnyObject) {
     self.dismissViewControllerAnimated(false, completion: {});
    }
    
    @IBAction func actionCreateButton(sender: AnyObject) {
    
        print("Album Created with : \n")
        for friend in selectedFriends
        {
            print("   - \(friend.label.text!)")
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
        
        self.createButton.enabled = false
    }

    override func viewDidAppear(animated: Bool) {

    }
    
    //MARK: - TableView Datasource and Delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("addFriendToAlbumCell", forIndexPath: indexPath) as! T_AddFriendToAlbumTableViewCell
        
        if (cell.friendSelected == true) {
            cell.checkbox.image = UIImage(named: "checkbox-active")
        }
        else {
            cell.checkbox.image = UIImage(named: "checkbox")
        }
        
        cell.label.text = "\(friends[indexPath.row])"
        cell.selectionStyle = .None
        cell.setProfilPicture(UIImage(named: "SelfySample")!)
        cell.label.font = UIFont.systemFontOfSize(15)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! T_AddFriendToAlbumTableViewCell
                
        cell.changeStateFriendSelected()
        
        if (cell.friendSelected == true) {
            selectFriend(cell)
        }
        else {
            unselectFriend(cell)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func selectFriend(cell: T_AddFriendToAlbumTableViewCell)
    {
        cell.checkbox.image = UIImage(named: "checkbox-active")
        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        cell.label.font = UIFont.boldSystemFontOfSize(15)
        self.selectedFriends.append(cell)
        
        if (self.selectedFriends.count > 0)
        {
            self.createButton.enabled = true
        }
    }
    
    func unselectFriend(cell: T_AddFriendToAlbumTableViewCell)
    {
        cell.checkbox.image = UIImage(named: "checkbox")
        cell.backgroundColor = UIColor.whiteColor()
        cell.label.font = UIFont.systemFontOfSize(15)
        self.selectedFriends.removeAtIndex(self.selectedFriends.indexOf(cell)!)
        
        if (self.selectedFriends.count == 0)
        {
            self.createButton.enabled = false
        }

    }
}
