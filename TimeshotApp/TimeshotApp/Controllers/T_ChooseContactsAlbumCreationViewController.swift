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
    @IBAction func actionBackButton(sender: AnyObject) {
     self.dismissViewControllerAnimated(false, completion: {});
    }
    
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

    }
}
