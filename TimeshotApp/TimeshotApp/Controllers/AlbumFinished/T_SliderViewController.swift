//
//  T_SliderViewController.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 07/04/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_SliderViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dotsButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var fromUserLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    
    //var slideImages:[T_PhotosCollectionViewController. ] = []
    var slideImages: [T_Post] = []
    var slideViews: [T_PhotoImageView?] = []
    var currentSlide: Int = 0
    
    // MARK: Status Bar Properties
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: Life View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sliderCount = slideImages.count
        
        for _ in 0..<sliderCount {
            slideViews.append(nil)
        }
        
        // Really important ! Need to initialize width of the scrollView
        // Fix the size of the scrollView
        scrollView.frame.size = view.frame.size
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(slideImages.count), height: pagesScrollViewSize.height)
        
        // Loading the first slide
        loadVisibleSlides(currentSlide)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // Do any additional setup after loading the view.
        navigationController?.navigationBarHidden = true
        
        UIApplication.sharedApplication().statusBarHidden=true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Functions
    func loadSlide(page:Int) {
        if page < 0 || page >= slideImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Check if we have already loaded the view
        if let _ = slideViews[page] {
            // Do nothing the view is already loaded
        } else {
            // Need to create the view
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            // Design of the view
            let newPageView = T_PhotoImageView()
            newPageView.post = slideImages[page]
            if let image = slideImages[page].image.value {
                newPageView.image = image
            } else {
                slideImages[page].downloadImage()
            }
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
            
            scrollView.addSubview(newPageView)
            
            // Add the view to the slider
            slideViews[page] = newPageView
        }
    }
    
    func purgeSlide(page:Int) {
        if page < 0 || page >= slideImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = slideViews[page]{
            pageView.removeFromSuperview()
            slideViews[page] = nil
        }
    }
    
    func loadVisibleSlides(pageIndex: Int? ) {
        // First, determine which page is currently visible
        let pageWidth = scrollView.frame.size.width
        
        // If we have a pageIndex, then we need to display the specific slide
        if let pageIndex = pageIndex {
            scrollView.contentOffset.x = pageWidth * CGFloat(pageIndex)
        }
        
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Change the label of the page to be the good one
        fromUserLabel.text = slideImages[page].fromUser.username
        
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.components([.Hour, .Minute], fromDate: slideImages[page].createdAt!)
        hourLabel.text = "-  \(comp.hour):\(comp.minute)"
        
        
        // Work out which slides you want to load
        let previousSlide = page - 1
        let nextSlide = page + 1
        
        
        // Purge anything before the first page
        for index in 0.stride(to:previousSlide, by:1) {
            purgeSlide(index)
        }
        
        // Load pages in our range
        for index in previousSlide...nextSlide {
            loadSlide(index)
        }
        
        // Purge anything after the last page
        for index in (nextSlide + 1).stride(to:slideImages.count, by:1)  {
            purgeSlide(index)
        }
        
    }
    
    // Call when the image was downloaded by the user
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            let ac = UIAlertController(
                title: NSLocalizedString("Saved !", comment: ""),
                message: NSLocalizedString("The picture has been saved to your photos.", comment: ""),
                preferredStyle: .Alert)
            
            ac.addAction(UIAlertAction(
                title: NSLocalizedString("OK", comment: ""),
                style: .Default, handler: nil))
            
            presentViewController(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: NSLocalizedString("Save error", comment: ""), message: error?.localizedDescription, preferredStyle: .Alert)
            
            ac.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    // MARK: Actions
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func dotsAction(sender: UIButton) {
        // Constructs the UIAlert
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        //Add actions to the UIAlert
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let reportAction = UIAlertAction(title: NSLocalizedString("Report", comment: ""), style: .Default){
            (action) in
            // Add the action to report the picture
        }
        alertController.addAction(reportAction)
        
        let downloadAction = UIAlertAction(title: NSLocalizedString("Download", comment: ""), style: .Default) {
            (action) in
            let pageWidth = self.scrollView.frame.size.width
            let page = Int(floor((self.scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
            
            // Avoid freezing the app by doing the download of the image in another queue
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                UIImageWriteToSavedPhotosAlbum(self.slideImages[page].image.value!,self,#selector(T_SliderViewController.image(_:didFinishSavingWithError:contextInfo:)),nil);
            });
        }
        alertController.addAction(downloadAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func showInformationDetail(recognizer: UITapGestureRecognizer) {
        if cancelButton.hidden {
            cancelButton.hidden = false
            dotsButton.hidden = false
            fromUserLabel.hidden = false
            hourLabel.hidden = false
        } else {
            cancelButton.hidden = true
            dotsButton.hidden = true
            fromUserLabel.hidden = true
            hourLabel.hidden = true
        }
    }
    
    //    // MARK: Navigation
    //    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //        // Get the new view controller using segue.destinationViewController.
    //        // Pass the selected object to the new view controller.
    //    }
    
}

// MARK: - ScrollViewDelegate
extension T_SliderViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Load the pages that are now on screen
        loadVisibleSlides(nil)
    }
    
    
}

