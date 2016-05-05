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
    private var photos : [String?] = ["selfie1.jpg", "selfie2.jpg", "selfie3.jpg"]

    @IBOutlet weak var kolodaView: KolodaView!
    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        
        kolodaView.dataSource = self
        kolodaView.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print(kolodaView.currentCardIndex)
        for i in 0..<kolodaView.currentCardIndex {
            photos[i] = nil
        }
        photos.append("selfie4.jpg")
        photos.append("selfie5.jpg")
        photos.append("selfie6.jpg")
        photos.append("selfie7.jpg")
        photos.append("selfie8.jpg")
        kolodaView.resetCurrentCardIndex()
        // Dispose of any resources that can be recreated.
    }
    
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
extension T_PhotosAlbumLiveViewController : KolodaViewDataSource {

    func kolodaNumberOfCards(koloda: KolodaView) -> UInt {
        return UInt(photos.count)
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
//        let imageName = photos[Int(index) % photos.count]
//        let image = UIImage(named: imageName)
//        let imageView = UIImageView(image: image!)
//        imageView.contentMode = UIViewContentMode.ScaleAspectFit
//        imageView.clipsToBounds = true
        //print(imageView)
        return UIView()
        
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        return OverlayView()
        //return CustomKolodaView() as? OverlayView
        //return NSBundle.mainBundle().loadNibNamed("CustomOverlayView",
        //                                          owner: self, options: nil)[0] as? OverlayView
    }
    
}

// MARK: - KolodaViewDelegate
extension T_PhotosAlbumLiveViewController : KolodaViewDelegate {
    func koloda(koloda: KolodaView, didSwipedCardAtIndex index: UInt, inDirection direction: SwipeResultDirection){
        if direction == SwipeResultDirection.Left {
            print("Swipe Left")
        }
        else if direction == SwipeResultDirection.Right {
            print("Swipe Right")
        }
        else if direction == SwipeResultDirection.None {
            print("WOW - A None direction")
        }
    }
    
    func koloda(kolodaDidRunOutOfCards koloda: KolodaView){
        print("kolodaDidRunOutOfCards")
    }
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt){
        //print("didSelectCardAtIndex, index=\(index)")
    }
    
    func koloda(kolodaShouldMoveBackgroundCard koloda: KolodaView) -> Bool {
        return true
    }
    func koloda(kolodaShouldTransparentizeNextCard koloda: KolodaView) -> Bool {
        return true
    }
    func koloda(kolodaShouldApplyAppearAnimation koloda: KolodaView) -> Bool {
        return true
    }
    
    func koloda(kolodaDidResetCard koloda: KolodaView){
        //print("kolodaDidResetCard")
        
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


