//
//  T_SignUpInvitePeopleViewController.swift
//  TimeshotApp
//
//  Created by Karim Lamouri on 14/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_SignUpInvitePeopleViewController: UIViewController {

    @IBOutlet weak var yesIWantButton: UIButton!
    @IBOutlet weak var skipBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var cameraView: UIView!
    var user : T_User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {        
        T_DesignHelper.addRoundBorder(yesIWantButton)
        T_DesignHelper.colorBorderButton(yesIWantButton)
        
        T_DesignHelper.colorUIView(overlayView)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        user?.signUpInBackgroundWithBlock{ success , errors -> Void in
        }
    }
    
    @IBAction func skipTapped(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("HomePageViewController") as UIViewController
        presentViewController(vc, animated: true, completion: nil)
    }

}
