//
//  T_AlbumLiveViewController.swift
//  TimeshotApp
//
//  Created by Karim Lamouri on 31/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_AlbumLiveViewController: UIViewController {
    @IBOutlet weak var segmentedView: UIView!
    @IBOutlet weak var photosContainerView: UIView!
    @IBOutlet weak var friendsContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        T_DesignHelper.colorUIView(segmentedView)
        

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
    
    @IBAction func valueChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            photosContainerView.hidden = false
            friendsContainerView.hidden = true
        case 1:
            photosContainerView.hidden = true
            friendsContainerView.hidden = false
        default:
            break
        }

    }
    //MARK: - Systems methods
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden=false
    }

}
