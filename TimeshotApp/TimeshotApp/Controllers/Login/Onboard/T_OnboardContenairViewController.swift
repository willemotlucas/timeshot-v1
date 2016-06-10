//
//  T_OnboardContenairViewController.swift
//  TimeshotApp
//
//  Created by Karim Lamouri on 06/06/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import BWWalkthrough
import Parse

class T_OnboardContenairViewController: BWWalkthroughViewController, BWWalkthroughViewControllerDelegate {

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
    func walkthroughCloseButtonPressed(){
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let startViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! UINavigationController
        self.presentViewController(startViewController, animated: true, completion: nil)
    }
    func walkthroughNextButtonPressed(){
        
    }
    func walkthroughPrevButtonPressed(){
        
    }
    func walkthroughPageDidChange(pageNumber:Int){

    }

}
