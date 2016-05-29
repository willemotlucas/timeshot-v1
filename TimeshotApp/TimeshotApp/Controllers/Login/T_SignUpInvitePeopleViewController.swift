//
//  T_SignUpInvitePeopleViewController.swift
//  TimeshotApp
//
//  Created by Karim Lamouri on 14/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import MBProgressHUD

class T_SignUpInvitePeopleViewController: UIViewController {
    
    @IBOutlet weak var yesIWantButton: UIButton!
    @IBOutlet weak var finishUp: UIButton!
    @IBOutlet weak var overlayView: UIView!
    var user : T_User?
    var viaFacebook : Bool?
    
    var progressHUD:MBProgressHUD?
    
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
        T_DesignHelper.addRoundBorder(finishUp)
        T_DesignHelper.colorBorderButton(finishUp)
        
        T_DesignHelper.colorUIView(overlayView)
        
    }
    
    // MARK: Methods
    func freezeUI() {
        progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHUD?.mode = .Indeterminate
    }
    
    func unfreezeUI() {
        progressHUD?.hide(true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    /*override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if sender === yesIWantButton {
            T_ContactsHelper.promptForAddressBookRequestAccess(self)
            return false
        }
        return true
    }*/
    @IBAction func inviteFriend(sender: AnyObject) {
        T_ContactsHelper.promptForAddressBookRequestAccess(self)
    }
    
    @IBAction func finishSignUp(sender: AnyObject) {
        freezeUI()
        if let viaFb = viaFacebook where viaFb == true{
            do {
                try user?.save()
                unfreezeUI()
            }
            catch _ {
                unfreezeUI()
            }
        }
        else {
            do {
                try user?.signUp()
                unfreezeUI()
            }
            catch _ {
                unfreezeUI()
            }
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("HomePageViewController") as UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
}