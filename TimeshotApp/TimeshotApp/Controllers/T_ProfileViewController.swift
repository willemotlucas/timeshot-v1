//
//  T_ProfileViewController.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 20/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

enum ContentType {
    case Friends, Notifications
}

class T_ProfileViewController: UIViewController {
    // MARK: IBOutlet
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedView: UIView!
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK : Properties
    var friends: [String] = ["Lucas Willemot", "Valentin Paul", "Romain Pellerin", "Paul Jeannot", "Gabriel Hurtado", "Maxime Churin", "Karim Lamouri"]
    var contentToDisplay : ContentType = .Friends

    // MARK: Overrided functions
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        T_DesignHelper.colorHeaderTableView(profileView)
        //T_DesignHelper.colorSegmentedControl(segmentedControl)
        T_DesignHelper.colorNavBar(self.navigationController!.navigationBar)
        tableView.tableHeaderView = profileView
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: IBAction
    
    @IBAction func segmentedControlIndexChanged(sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0: contentToDisplay = .Friends
        case 1: contentToDisplay = .Notifications
        default: break
        }
        
        tableView.reloadData()
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

extension T_ProfileViewController: UITableViewDelegate {
    
}

extension T_ProfileViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch contentToDisplay {
        case .Friends:
            let cell = tableView.dequeueReusableCellWithIdentifier("T_ProfileTableViewCell", forIndexPath: indexPath) as! T_ProfileTableViewCell
            cell.textLabelCell.text = friends[indexPath.row]
            return cell
        case .Notifications:
            let cell = UITableViewCell()
            cell.textLabel?.text = "Valentin a commenté votre photo"
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch contentToDisplay {
        case .Friends:
            return friends.count
        case .Notifications:
            return 40
        }
    }
}

extension T_ProfileViewController: UIScrollViewDelegate {
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

