//
//  T_AlbumViewController.swift
//  TimeshotApp
//
//  Created by Valentin Paul on 17/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import Parse
import ConvenienceKit

class T_AlbumViewController: UIViewController{
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    var timelineComponent: TimelineComponent<T_Album, T_AlbumViewController>!
    let defaultRange = 0...4
    let additionalRangeSize = 5
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialisation of timelineComponent
        timelineComponent = TimelineComponent(target: self)
        
        // For DZNEmptyState
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        // For tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        // Design the navbar
        T_DesignHelper.colorNavBar(self.navigationController!.navigationBar)
        
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        //If the component has already queried the server and stored a user's posts, this method call does nothing at all.
        //After the initial load, posts will only be reloaded if the user manually chooses to do so (by using the pull-to
        //refresh mechanism).
        timelineComponent.loadInitialIfRequired()
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
                let selectedAlbum = timelineComponent.content[indexPath.row]
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
        return timelineComponent.content.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let album = timelineComponent.content[indexPath.row]
        
        album.downloadCoverImage()
        
        if T_Album.isLiveAlbumAssociatedToUser(album) {
            let cell = tableView.dequeueReusableCellWithIdentifier("liveAlbum") as! T_AlbumLiveTableViewCell
            cell.album = album
            
            cell.initCellWithMetaData(album.createdAt!, title: album.title)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("finishAlbum") as! T_AlbumFinishTableViewCell
            cell.album = album
            cell.initCellWithMetaData(album.createdAt!, title: album.title)
            return cell
            
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        timelineComponent.targetWillDisplayEntry(indexPath.row)
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

// MARK: -TimelineComponentTarget
extension T_AlbumViewController: TimelineComponentTarget {
    
    func loadInRange(range: Range<Int>, completionBlock: ([T_Album]?) -> Void) {
        //
        T_ParseAlbumHelper.queryAllAlbumsOnParse(range) { (result: [PFObject]?, error: NSError?) -> Void in
            // 2
            let posts = result as? [T_Album] ?? []
            // 3
            completionBlock(posts)
        }
    }
    
}
