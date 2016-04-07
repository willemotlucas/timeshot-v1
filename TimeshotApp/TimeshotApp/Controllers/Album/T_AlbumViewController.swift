//
//  T_AlbumViewController.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 17/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_AlbumViewController: UIViewController{
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    // Test arrays for the size of each cell
    var imageArray = ["festival.jpg","mariage.jpg","soiree.jpg","voyage.jpg"]
    var titleArray = ["Imaginarium Festival 2016", "Mariage Lulu et Marie", "EVG Lucas", "Voyage SurfUt posey"]
    var liveArray = [true, false, false,false]
    var dateArray = ["13 mai","10 avril","19 mars", "3 janvier"]
    
    var navigationBar : UINavigationBar?
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationBar = self.navigationController?.navigationBar
        
        // Design the navbar
        T_DesignHelper.colorNavBar(self.navigationController!.navigationBar)
        
        

        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden=false
        
        navigationController?.navigationBarHidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationBar!.frame =  CGRectMake(0, 0, self.view.frame.size.width, CGFloat(64))
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationBar!.frame =  CGRectMake(0, 0, self.view.frame.size.width, CGFloat(64))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK:  Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Systems methods
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    



}

// MARK: - UITableViewDelegate
extension T_AlbumViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if liveArray[indexPath.row] == true {
            let cell = tableView.dequeueReusableCellWithIdentifier("liveAlbum") as! T_AlbumLiveTableViewCell

            cell.initCell(UIImage(named: imageArray[indexPath.row])!,
                           date: dateArray[indexPath.row],
                           title: titleArray[indexPath.row])
            
            return cell

        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("finishAlbum") as! T_AlbumFinishTableViewCell
            
            cell.initCell(UIImage(named: imageArray[indexPath.row])!,
                date: dateArray[indexPath.row],
                title: titleArray[indexPath.row])
            
            return cell

        }
    }
}
