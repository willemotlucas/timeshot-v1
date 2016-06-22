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
import MBProgressHUD

protocol StoryDelegateProtocol {
    func updateStory(indexStory : Int)
}


class T_StoryViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var fromUserLabel: UILabel!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var actualImageView: UIImageView!
    
    var actualPost : T_Post? {
        didSet {
            // free memory of image stored with post that is no longer displayed
            if let oldValue = oldValue where oldValue != actualPost {
                oldValue.image.value = nil
            }
            
            if let post = actualPost {
                post.image.bindTo(self.actualImageView.bnd_image)
                
                if post.image.value != nil {
                    self.launchTimer()
                } else {
                    self.freezeUI()
                    self.actualImageView.bnd_image.observeNew { image in
                        if image != nil {
                            self.unfreezeUI()
                            self.launchTimer()
                        }
                    }
                }
            }
        }
    }
    var storyDelegate: StoryDelegateProtocol?
    var progressHUD:MBProgressHUD?
    var pageImages:[T_Post] = []
    var currentPage: Int = 0
    var currentTime: Double = 0.0
    var timer: NSTimer?
    var timer2: NSTimer!
    var circularProgress1: KYCircularProgress?
    var circularProgress2: KYCircularProgress?
    
    
    // MARK: Status Bar Properties
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: Design Circle
    private func configureCircle1() {
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
        showCurrentImage()
    }
    
    override func viewWillAppear(animated: Bool) {
        // Do any additional setup after loading the view.
        navigationController?.navigationBarHidden = true
        
        UIApplication.sharedApplication().statusBarHidden=true
    }
    
    // Need to stop all the timer when we quit this view
    override func viewWillDisappear(animated: Bool) {
        storyDelegate?.updateStory(currentPage)
        timer?.invalidate()
        timer2.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Methods
    func freezeUI() {
        progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHUD?.mode = .Indeterminate
    }
    
    func unfreezeUI() {
        progressHUD?.hide(true)
    }

    // MARK: Functions
    func showCurrentImage() {
        // On change le currentPost
        if currentPage < pageImages.count {
            actualPost = pageImages[currentPage]
        
            // Change the label of the page to be the good one
            fromUserLabel.text = actualPost!.fromUser.username
        
            let calendar = NSCalendar.currentCalendar()
            let comp = calendar.components([.Hour, .Minute], fromDate: actualPost!.createdAtDate)
            hourLabel.text = "\(comp.hour):\(comp.minute)"
        
            // Work out which pages you want to load
            let firstPage = currentPage
            let lastPage = currentPage + 2
        
            // Load pages in our range
            for index in firstPage...lastPage {
                loadImage(index)
            }
            currentPage += 1;
        } else {
            timer?.invalidate()
            currentPage = 0
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    func launchTimer(){
        if let myTimer = timer {
            if !myTimer.valid {
                timer = NSTimer.scheduledTimerWithTimeInterval(3.8, target: self, selector: #selector(showCurrentImage), userInfo: nil, repeats: true)
            }
        } else {
            timer = NSTimer.scheduledTimerWithTimeInterval(3.8, target: self, selector: #selector(showCurrentImage), userInfo: nil, repeats: true)
        }
        circularProgress1!.progress = 1 - (Double(currentPage + 1)/Double(pageImages.count))
        timer2 = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(timeImage), userInfo: nil, repeats: true)
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
    
    // MARK: Action
    @IBAction func userTapped(recognizer: UITapGestureRecognizer) {
        if let progress = progressHUD {
            if progress.hidden {
                // Stop the current timers
                timer?.invalidate()
                timer2.invalidate()
                currentTime = 0.0
                // Launch the new timers
                // And we launch the first one
                showCurrentImage()
            } else {
                print("Ca charge ca marche attend un peu")
            }
            
        }else {
            // Stop the current timers
            timer?.invalidate()
            timer2.invalidate()
            currentTime = 0.0
            // Launch the new timers
            // And we launch the first one
            showCurrentImage()
        }
        
    }
    
    @IBAction func exitStory(sender: AnyObject) {
        currentPage = currentPage - 1
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

