//
//  T_LoginHomePageViewController.swift
//  TimeshotApp
//
//  Created by Karim Lamouri on 28/05/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_LoginHomePageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let navbar = self.navigationController?.navigationBar {
            T_DesignHelper.colorNavBar(navbar)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.setNavigationBarHidden(true, animated: animated)
        
    }
    @IBAction func CGUButtonTapped(sender: AnyObject) {
        if let url = NSURL(string: "http://timeshot.co/terms.html"){
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    
    @IBAction func PolicyPrivacyButtonTapped(sender: AnyObject) {
        if let url = NSURL(string: "http://timeshot.co/policy.html"){
            UIApplication.sharedApplication().openURL(url)
        }
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
