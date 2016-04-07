//
//  T_FriendsAlbumLiveViewController.swift
//  TimeshotApp
//
//  Created by Karim Lamouri on 31/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_FriendsAlbumLiveViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addFriendsButtonView: UIView!
    var friends = ["Lucas Willemot", "Valentin Paul", "Romain Pellerin", "Paul Jeannot", "Gabriel Hurtado", "Maxime Churin", "Karim Lamouri"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        T_DesignHelper.colorUIView(addFriendsButtonView)
        // Do any additional setup after loading the view.
        //TODO Load Parse Friends
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToFriendsAlbumLive(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? T_AddFriendAlbumLiveViewController {
            let addedFriend = sourceViewController.selected
            friends += addedFriend
            //TODO Refresh view
            
        }
    }
}

extension T_FriendsAlbumLiveViewController : UITableViewDelegate {
    
}

extension T_FriendsAlbumLiveViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("T_FriendTableViewCell", forIndexPath: indexPath) as! T_FriendTableViewCell
        cell.friendNameLabel.text = friends[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
}
