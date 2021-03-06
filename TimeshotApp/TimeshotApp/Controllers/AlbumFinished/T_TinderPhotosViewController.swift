//
//  T_TinderPhotosViewController.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 10/06/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import UIKit
import Koloda
import pop
import Parse

class T_TinderPhotosViewController: UIViewController {
    @IBOutlet weak var dislikeButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    // MARK: Properties
    private let frameAnimationSpringBounciness:CGFloat = 5
    private let frameAnimationSpringSpeed:CGFloat = 10
    private let kolodaCountOfVisibleCards = 3
    private let kolodaAlphaValueSemiTransparent:CGFloat = 0.2
    private var posts : [T_Post]?
    var albumPhotos : T_Album?
        
    @IBOutlet weak var kolodaView: KolodaView!
    var containerDelegate: ContainerDelegateProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        posts = []
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        loadPost()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Loading Data Functions
    func loadPost() {
        T_AlbumCacheHelper.postsForCurrentAlbum(albumPhotos!) {(result: [PFObject]?, error: NSError?) -> Void in
            //self.containerDelegate?.hidePhotoCollectionView()
            if let error = error {
                print("\n\n\n")
                print(error)
                print("\n\n\n")
                
            } else {
                let allPosts = result as? [T_Post] ?? []
                let currentUser = T_ParseUserHelper.getCurrentUser()!
                for i in allPosts {
                    
                    let verifVote = i.hasVoted.filter{$0 == currentUser}
                    if verifVote.count == 0 {
                        // Post non voté
                        self.posts?.append(i)
                    }
                }
                self.kolodaView.reloadData()
            }
        }
    }

    
    // MARK: Actions
    @IBAction func dislikeTapped(sender: AnyObject) {
        kolodaView.swipe(.Left)
    }
    
    @IBAction func likeTapped(sender: AnyObject) {
        kolodaView.swipe(.Right)
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

    
// MARK: - KolodaViewDataSource
extension T_TinderPhotosViewController : KolodaViewDataSource {
        
    func kolodaNumberOfCards(koloda: KolodaView) -> UInt {
        return UInt(posts?.count ?? 0)
    }
        
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        if let posts = self.posts{
            // Need to create the view
            let frame = kolodaView.frame
            
            // Design of the view
            let newPageView = T_SliderImageView.init(frame: frame)
            newPageView.post = posts[Int(index)]
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
            
            if let image = posts[Int(index)].image.value {
                newPageView.image = image
            }else {
                posts[Int(index)].downloadImage()
            }
            
            return newPageView
        }
        return UIView()
    }
        
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("KolodaBanner",
                                                    owner: self, options: nil)[0] as? OverlayView
    }
    
}
    
// MARK: - KolodaViewDelegate
extension T_TinderPhotosViewController : KolodaViewDelegate {
    func koloda(koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        if direction == SwipeResultDirection.Left {
            print("Swipe Left")
            T_ParseVoteHelper.disliked(posts![Int(index)], user: T_User.currentUser()!)
        }
        else if direction == SwipeResultDirection.Right {
            print("Swipe Right")
            T_ParseVoteHelper.liked(posts![Int(index)], user: T_User.currentUser()!)
        }
    }
    
    func kolodaDidRunOutOfCards(koloda: KolodaView){
        print("kolodaDidRunOutOfCards")
        containerDelegate?.hideTinderVoteView()
        
    }
    
    
    func koloda(koloda: KolodaView, didShowCardAtIndex index: UInt){
        let _ = koloda.viewForCardAtIndex(Int(index))
    }
    
    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation.springBounciness = frameAnimationSpringBounciness
        animation.springSpeed = frameAnimationSpringSpeed
        return animation
    }
}

