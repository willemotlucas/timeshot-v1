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
    
    var attendees : [T_User]?
    
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        tableView.allowsSelection = false
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

// MARK: - TableViewDelegate and Datasource
extension T_FriendsViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("attendeeCell", forIndexPath: indexPath) as! T_FriendsTableViewCell
        
        // On a un probleme pour le moment sur les attendees mais sinon ca fonctionne bien
        //attendees![indexPath.row].downloadImage()
        cell.user = attendees![indexPath.row]
        //cell.initWithUser(attendees![indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let attendees = attendees {
            return attendees.count
        }
        
        return 0
    }
    
}
