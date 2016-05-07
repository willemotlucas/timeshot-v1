//
//  T_StoryViewController.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 07/04/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import Bond
import KYCircularProgress


class T_StoryViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var fromUserLabel: UILabel!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var actualImageView: T_PhotoImageView!
    
    var pageImages:[T_Post] = []
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
            loadCurrentPage(currentPage)
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

    func loadImage(page:Int) {
        if page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        // Check if we have already loaded the image
        if let _ = pageImages[page].image.value {
            // Do nothing the view is already loaded
        } else {
            pageImages[page].downloadImage()
        }
    }
    
    func loadCurrentPage(pageIndex: Int ) {
        if let image = pageImages[pageIndex].image.value {
            actualImageView.image = image
        }
        
        // Change the label of the page to be the good one
        fromUserLabel.text = pageImages[pageIndex].fromUser.username
        
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.components([.Hour, .Minute], fromDate: pageImages[pageIndex].createdAt!)
        hourLabel.text = "-  \(comp.hour):\(comp.minute)"
        // Work out which pages you want to load
        let firstPage = pageIndex
        let lastPage = pageIndex + 2
        
        // Load pages in our range
        for index in firstPage...lastPage {
            loadImage(index)
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

