//
//  T_FriendsViewController.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 20/04/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import Parse

class T_FriendsViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var addFriendsButton: UIButton!
    
    var attendees : [T_User]?
    var album: T_Album?
    
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(T_Album.isLiveAlbumAssociatedToUser(album)) {
            T_DesignHelper.colorUIView(buttonView)
            addFriendsButton.hidden = false;
        } else {
            addFriendsButton.hidden = true
            buttonView.backgroundColor = UIColor.clearColor()
        }

        // Permits to not show empty cells
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        tableView.allowsSelection = false
    }
    
    // MARK: Action
    @IBAction func addFriendsToAlbum(sender: UIButton) {
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addFriends" {
            let addFriendsVC = segue.destinationViewController as! T_AddFriendToAlbumViewController
            addFriendsVC.album = album!
        }
    }

}

// MARK: - TableViewDelegate and Datasource
extension T_FriendsViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("attendeeCell", forIndexPath: indexPath) as! T_FriendsTableViewCell
        
        attendees![indexPath.row].downloadImage()
        cell.user = attendees![indexPath.row]
        cell.initWithUser(attendees![indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let attendees = attendees {
            return attendees.count
        }
        
        return 0
    }
    
}
