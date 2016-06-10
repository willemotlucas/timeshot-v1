//
//  T_ChooseDetailsAlbumViewController.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 10/06/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_ChooseDetailsAlbumViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var tinderContainerView: UIView!
    @IBOutlet weak var photosContainerView: UIView!
    
    var albumPhotos : T_Album?
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        title = albumPhotos?.title
        print("on va devoir checker les posts ici ! ")
    }
    
    override func viewDidDisappear(animated: Bool) {
        // Je dois clean toutes les uiimages de cet album
        print("Je disparait : ChooseDetailsVC")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "tinderContainer" {
            // Ici on va devoir mettre les attendees mais pour le moment on a des buggs apparement ..
            // Possible que ce soit lors de la creation d'album .. a verifier !
            //let friendsAlbumVC = segue.destinationViewController
            //as! T_FriendsViewController
            //friendsAlbumVC.attendees = albumPhotos?.attendees
            //friendsAlbumVC.album = albumPhotos
        } else if segue.identifier == "photosContainer" {
            let finishAlbumVC =  segue.destinationViewController as! T_PhotosCollectionViewController
            finishAlbumVC.containerDelegate = self
            finishAlbumVC.albumPhotos = albumPhotos
        } else {
            print("coucou c'est moi !!!")
        }
    }

}

extension T_ChooseDetailsAlbumViewController : ContainerDelegateProtocol {
    func hidePhotoCollectionView() {
        photosContainerView.hidden = true;
    }
}
