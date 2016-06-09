//
//  T_PhotosAlbumLiveViewController.swift
//  TimeshotApp
//
//  Created by Karim Lamouri on 31/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import Koloda
import pop

class T_PhotosAlbumLiveViewController: UIViewController {
    @IBOutlet weak var dislikeButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    // MARK: Properties
    private let frameAnimationSpringBounciness:CGFloat = 5
    private let frameAnimationSpringSpeed:CGFloat = 10
    private let kolodaCountOfVisibleCards = 3
    private let kolodaAlphaValueSemiTransparent:CGFloat = 0.2
    private var posts : [T_Post]?

    @IBOutlet weak var kolodaView: KolodaView!
    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        T_ParseAlbumHelper.queryAlbumPinned{albumLive -> Void in
            T_ParsePostHelper.getAllPostNotVoted(T_User.currentUser()!, albumLive!, { posts -> Void in
                self.posts = posts
                self.kolodaView.resetCurrentCardIndex()
                if let posts = self.posts {
                    for post in posts {
                        post.downloadImage()
                        post.image.observe{_ in self.kolodaView.reloadData()}
                    }
                }
            })
        }
        T_ParseVoteHelper.getLiveAlbum()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print(kolodaView.currentCardIndex)
        /*for i in 0..<kolodaView.currentCardIndex {
            photos[i] = nil
        }
        photos.append("selfie4.jpg")
        photos.append("selfie5.jpg")
        photos.append("selfie6.jpg")
        photos.append("selfie7.jpg")
        photos.append("selfie8.jpg")
        kolodaView.resetCurrentCardIndex()*/
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dislikeTapped(sender: AnyObject) {
        //kolodaView.reloadData()
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
extension T_PhotosAlbumLiveViewController : KolodaViewDataSource {

    func kolodaNumberOfCards(koloda: KolodaView) -> UInt {
        print(posts?.count ?? 0)
        return UInt(posts?.count ?? 0)
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
//        let imageName = photos[Int(index) % photos.count]
//        let image = UIImage(named: imageName)
        if let posts = self.posts{
            let place = UIImage(named: "default-friend-picture")
            let img = posts[Int(index)].image.value
            let imageView = UIImageView(image: img ?? place)
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.clipsToBounds = true
            return imageView
        }
       
        //print(imageView)
        return UIView()
        
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        //return OverlayView()
        //return CustomKolodaView() as? OverlayView
        return NSBundle.mainBundle().loadNibNamed("KolodaBanner",
                                                  owner: self, options: nil)[0] as? OverlayView
    }
    
}

// MARK: - KolodaViewDelegate
extension T_PhotosAlbumLiveViewController : KolodaViewDelegate {
    func koloda(koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        if direction == SwipeResultDirection.Left {
            print("Swipe Left")
            //T_ParseVoteHelper.disliked(posts![Int(index)], user: T_User.currentUser()!)
        }
        else if direction == SwipeResultDirection.Right {
            print("Swipe Right")
            //T_ParseVoteHelper.liked(posts![Int(index)], user: T_User.currentUser()!)
        }
    }
    
    func kolodaDidRunOutOfCards(koloda: KolodaView){
        print("kolodaDidRunOutOfCards")
    }
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt){
        //print("didSelectCardAtIndex, index=\(index)")
    }
    
    func koloda(kolodaDidResetCard koloda: KolodaView){
        print("kolodaDidResetCard")
        
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


