//
//  T_StoryViewController.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 07/04/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import KYCircularProgress


class T_StoryViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var fromUserLabel: UILabel!
    @IBOutlet weak var circleView: UIView!
    
    var pageImages:[T_Post] = []
    var pageViews: [UIImageView?] = []
    var currentPage: Int = 0
    var currentTime: Double = 0.0
    var timer: NSTimer!
    var timer2: NSTimer!
    var circularProgress1: KYCircularProgress?
    var circularProgress2: KYCircularProgress?
    
    
    // MARK: Status Bar Properties
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: Design Circle
    private func configureCircle1() {
        //let circleFrame = CGRectMake(0, 0, 20, 20)
        circularProgress1 = KYCircularProgress(frame: CGRect(x:6, y: 6, width: circleView.bounds.width-12, height: circleView.bounds.height-12))
        circularProgress1?.lineWidth = 6
        circularProgress1?.startAngle = -M_PI_2
        circularProgress1?.endAngle = -M_PI_2
        
        circleView.addSubview(circularProgress1!)
    }
    
    private func configureCircle2() {
        circularProgress2 = KYCircularProgress(frame: self.circleView.bounds)
        circularProgress2?.lineWidth = 5
        circularProgress2?.colors = [UIColor.init(colorLiteralRed: 243.0/255.0, green: 199.0/255.0, blue: 161.0/255.0, alpha: 1.0),UIColor.init(colorLiteralRed: 232.0/255.0, green: 121.0/255.0, blue: 117.0/255.0, alpha: 1.0)]
        circularProgress2?.startAngle = -M_PI_2
        circularProgress2?.endAngle = -M_PI_2
        
        circleView.addSubview(circularProgress2!)
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // create KYCircularProgress
        configureCircle1()
        configureCircle2()
        
        let pageCount = pageImages.count
        
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        // Really important ! Need to initialize width of the scrollView
        // Fix the size of the scrollView
        scrollView.frame.size = view.frame.size
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count), height: pagesScrollViewSize.height)
        
        // Need to lauch the first action because with sceduledTimer it will start in 4 sec
        newImage()
        timer = NSTimer.scheduledTimerWithTimeInterval(3.8, target: self, selector: #selector(newImage), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        // Do any additional setup after loading the view.
        navigationController?.navigationBarHidden = true
        
        UIApplication.sharedApplication().statusBarHidden=true
    }
    
    // Need to stop all the timer when we quit this view
    override func viewWillDisappear(animated: Bool) {
        timer.invalidate()
        timer2.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Functions
    func newImage() {
        if currentPage < pageImages.count {
            loadNextPages(currentPage)
            currentPage += 1
            circularProgress1!.progress = 1 - (Double(currentPage)/Double(pageImages.count))
            
            timer2 = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(timeImage), userInfo: nil, repeats: true)
        } else {
            timer.invalidate()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func timeImage(){
        if currentTime <= 3.65 {
            currentTime += 0.05
            circularProgress2?.progress = 1 - currentTime/3.65
        } else {
            currentTime = 0.0
            timer2.invalidate()
        }
    }
    
    
    func loadPage(page:Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Check if we have already loaded the view
        if let _ = pageViews[page] {
            // Do nothing the view is already loaded
        } else {
            // Need to create the view
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            // Design of the view
            let newPageView = UIImageView(image: pageImages[page].image.value)
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
            
            scrollView.addSubview(newPageView)
            
            // Add the view to the slider
            pageViews[page] = newPageView
        }
    }
    
    func purgePage(page:Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page]{
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    
    func loadNextPages(pageIndex: Int? ) {
        // First, determine which page is currently visible
        let pageWidth = scrollView.frame.size.width
        
        // If we have a pageIndex, then we need to display the specific slide
        if let pageIndex = pageIndex {
            scrollView.contentOffset.x = pageWidth * CGFloat(pageIndex)
        }
        
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Change the label of the page to be the good one
        fromUserLabel.text = pageImages[page].fromUser.username
        
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.components([.Hour, .Minute], fromDate: pageImages[page].createdAt!)
        hourLabel.text = "-  \(comp.hour):\(comp.minute)"
        
        // Work out which pages you want to load
        let firstPage = page
        let lastPage = page + 2
        
        
        // Purge anything before the first page
        for index in 0 ..< firstPage {
            purgePage(index)
        }
        
        // Load pages in our range
        for index in firstPage...lastPage {
            loadPage(index)
        }
        
        // Purge anything after the last page
        for index in (lastPage + 1).stride(to:pageImages.count, by:1)  {
            purgePage(index)
        }
        
    }
    
    
    // MARK: Action
    @IBAction func userTapped(recognizer: UITapGestureRecognizer) {
        // Stop the current timers
        timer.invalidate()
        timer2.invalidate()
        currentTime = 0.0
        // Launch the new timers
        // And we launch the first one
        newImage()
        timer = NSTimer.scheduledTimerWithTimeInterval(3.8, target: self, selector: #selector(newImage), userInfo: nil, repeats: true)
    }
    
    @IBAction func exitStory(recognizer: UISwipeGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
