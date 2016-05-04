//
//  T_SignUpContactViewController.swift
//  TimeshotApp
//
//  Created by Karim Lamouri on 01/05/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_SignUpContactViewController: T_SearchContactViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func finish(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("HomePageViewController") as UIViewController
        presentViewController(vc, animated: true, completion: nil)
    }
}
