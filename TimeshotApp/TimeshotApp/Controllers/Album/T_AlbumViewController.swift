//
//  T_AlbumViewController.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 17/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import Parse

class T_AlbumViewController: UIViewController{
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    // Test arrays for the size of each cell
    var imageArray : [String] = ["festival.jpg","mariage.jpg","soiree.jpg","voyage.jpg"]
    var titleArray : [String] = ["Imaginarium Festival 2016", "Mariage Lulu et Marie", "EVG Lucas", "Voyage SurfUt posey"]
    var liveArray : [Bool] = [true, false, false,false]
    var dateArray : [String] = ["13 mai","10 avril","19 mars", "3 janvier"]
    
    var albumsArray : [T_Album] = [T_Album]()
    
    var navigationBar : UINavigationBar?
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        // For DZNEmptyState
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        navigationBar = self.navigationController?.navigationBar
        
        // Design the navbar
        T_DesignHelper.colorNavBar(self.navigationController!.navigationBar)
        
        
        // ========================
        // ==== TEST PARSE ========
        // ========================
        T_ParseAlbumHelper.queryAllAlbumsOnParse { (result : [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.albumsArray = result as? [T_Album] ?? []
                
                self.tableView.reloadData()
            } else {
                print("Erreur")
            }
        }

        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK:  Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "liveSegue" {
            print("Album live selectionné")
        } else if segue.identifier == "finishSegue" {
            let finishAlbumVC =  segue.destinationViewController as! T_AlbumFinishedViewController
            
            // Get the album of the cell clicked
            if let selectedCell = sender as? T_AlbumFinishTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedCell)!
                let selectedAlbum = albumsArray[indexPath.row]
                finishAlbumVC.albumPhotos = selectedAlbum
            }
        }
    }
    
    // MARK: Actions
    @IBAction func actionButtonCamera(sender: UIBarButtonItem) {
        T_HomePageViewController.showCameraViewControllerFromAlbum()
    }
    



}

// MARK: - UITableViewDelegate
extension T_AlbumViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumsArray.count
        //return imageArray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("finishAlbum") as! T_AlbumFinishTableViewCell
        
        let album = albumsArray[indexPath.row]
        
        album.downloadCoverImage()
        
        cell.album = album
        cell.initCellWithMetaData(album.createdAt!, title: album.title)
        return cell
        
//        if liveArray[indexPath.row] == true {
//            let cell = tableView.dequeueReusableCellWithIdentifier("liveAlbum") as! T_AlbumLiveTableViewCell
//
//            cell.initCell(UIImage(named: imageArray[indexPath.row])!,
//                           date: dateArray[indexPath.row],
//                           title: titleArray[indexPath.row])
//            
//            return cell
//
//        } else {
//            let cell = tableView.dequeueReusableCellWithIdentifier("finishAlbum") as! T_AlbumFinishTableViewCell
//            
//            cell.initCell(UIImage(named: imageArray[indexPath.row])!,
//                date: dateArray[indexPath.row],
//                title: titleArray[indexPath.row])
//            
//            return cell
//
//        }
    }
}

// MARK: - DZNEmptyState
extension T_AlbumViewController : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = NSLocalizedString("Welcome", comment: "")
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = NSLocalizedString("Tap the button below to add your first dhaodaio", comment: "")
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
//    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
//        let image = UIImage(named: "selfie3")
//        image?.accessibilityFrame = CGRect(origin: scrollView.center, size: CGSize(width: 50, height: 50))
//        
//        
//        return image
//    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        let str = NSLocalizedString("Add fhiodfhiod", comment: "")
        return NSAttributedString(string: str, attributes: nil)
    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        let ac = UIAlertController(title: NSLocalizedString("Button tapped", comment: ""), message: nil, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: NSLocalizedString("Hurray", comment: ""), style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
}
