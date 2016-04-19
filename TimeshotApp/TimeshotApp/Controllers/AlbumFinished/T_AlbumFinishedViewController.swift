//
//  AlbumFinishedViewController.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 07/04/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_AlbumFinishedViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var friendsContainerView: UIView!
    @IBOutlet weak var photosContainerView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var segmentedView: UIView!
    
    var albumPhotos : T_Album?
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        T_DesignHelper.colorNavBar((self.navigationController?.navigationBar)!)
        T_DesignHelper.colorUIView(segmentedView)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        title = albumPhotos?.title
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func changeMenuOption(sender: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            photosContainerView.hidden = false
            friendsContainerView.hidden = true
            
        } else {
            photosContainerView.hidden = true
            friendsContainerView.hidden = false
        }
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "attendeesContainer" {
            
        } else if segue.identifier == "photosContainer" {
            let finishAlbumVC =  segue.destinationViewController as! T_PhotosCollectionViewController
            finishAlbumVC.albumPhotos = albumPhotos
        }
     }
 

}
