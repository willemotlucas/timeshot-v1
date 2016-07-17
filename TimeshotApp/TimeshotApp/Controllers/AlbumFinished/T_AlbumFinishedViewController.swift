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
        
        // Disable pour le moment le swipe back ! 
        // Attendre la V1 pour pouvoir revoir tout ca ;)
        if self.navigationController!.respondsToSelector(Selector("interactivePopGestureRecognizer")) {
            self.navigationController!.interactivePopGestureRecognizer!.enabled = false
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        title = albumPhotos?.title
    }
    
    override func viewDidDisappear(animated: Bool) {
        // Je dois clean toutes les uiimages de cet album
        if isMovingFromParentViewController() {
            for i in self.childViewControllers {
                if let controller = i as? T_ChooseDetailsAlbumViewController {
                    for j in controller.childViewControllers {
                        if let view = j as? T_PhotosCollectionViewController {
                            for post in view.posts {
                                post.image.value = nil
                            }
                        }
                    }
                }
            }
        }
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
            let friendsAlbumVC = segue.destinationViewController as! T_FriendsViewController
            friendsAlbumVC.attendees = albumPhotos?.attendees
            friendsAlbumVC.album = albumPhotos
        } else if segue.identifier == "chooseContainer" {
            let finishAlbumVC =  segue.destinationViewController as! T_ChooseDetailsAlbumViewController
            finishAlbumVC.albumPhotos = albumPhotos
        } 
     }
 

}
