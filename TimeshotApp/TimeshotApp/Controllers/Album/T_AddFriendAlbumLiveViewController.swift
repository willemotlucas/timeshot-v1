//
//  T_AddFriendAlbumLiveViewController.swift
//  TimeshotApp
//
//  Created by Karim Lamouri on 31/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_AddFriendAlbumLiveViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var addFriendButtonView: UIView!
    
    @IBOutlet weak var addFriendButton: UIButton!
    var friends = ["Toto", "Tata", "Titi"]
    var selected : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        T_DesignHelper.colorUIView(addFriendButtonView)
        addFriendButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK : - TableView Delegate
extension T_AddFriendAlbumLiveViewController : UITableViewDelegate {
}

//MARK : - TableView Data Source
extension T_AddFriendAlbumLiveViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("T_AddFriendAlbumLiveTableViewCell", forIndexPath: indexPath) as! T_AddFriendAlbumLiveTableViewCell
        cell.friendNameLabel.text = friends[indexPath.row]
        cell.friendAddButton.tag = indexPath.row
        cell.friendAddButton.addTarget(self, action: #selector(self.buttonAddClicked(_:)), forControlEvents: .TouchUpInside)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    @IBAction func buttonAddClicked(sender: UIButton) {
        sender.selected = !sender.selected
        if sender.selected == true {
            selected.append(friends[sender.tag])
            addFriendButton.enabled = true
        }
        else {
            selected.removeAtIndex(selected.indexOf(friends[sender.tag])!)
            if selected.isEmpty {
                addFriendButton.enabled = false
            }
        }
    
    }
}

//MARK : - Navigation
extension T_AddFriendAlbumLiveViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === addFriendButton {
            //Some Action maybe
            //TODO Parse Save
        }
    }
    
}
