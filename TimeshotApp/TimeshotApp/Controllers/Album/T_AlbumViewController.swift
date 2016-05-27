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
import PullToRefresh

class T_AlbumViewController: UIViewController{
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    var timelineComponent: TimelineComponent<T_Album, T_AlbumViewController>!
    let defaultRange = 0...4
    let additionalRangeSize = 5
    var isLoading = false
    var errorLoading = false
    
    let refresher = PullToRefresh()
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialisation of timelineComponent
        timelineComponent = TimelineComponent(target: self)
        
        // For DZNEmptyState
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        //Add pull to refresh
        tableView.addPullToRefresh(refresher, action: {
            self.timelineComponent.loadInitialIfRequired()
            self.tableView.endRefreshing()
        })
        
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
        print("Je veux checker notre vue")
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
            _ =  segue.destinationViewController as! T_AlbumLiveViewController
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
        
//        if T_Album.isLiveAlbumAssociatedToUser(album) {
//            let cell = tableView.dequeueReusableCellWithIdentifier("liveAlbum") as! T_AlbumLiveTableViewCell
//            cell.album = album
//            cell.initCellWithMetaData(album.createdAt!, title: album.title)
//            
//            return cell
//        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("finishAlbum") as! T_AlbumFinishTableViewCell
            cell.album = album
            cell.initCellWithMetaData(album.createdAt!, title: album.title)
            
            return cell
        //}
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        timelineComponent.targetWillDisplayEntry(indexPath.row)
    }
}

// MARK: - DZNEmptyState
extension T_AlbumViewController : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        // On est dans le cas ou on a pas encore de photos dans l'album
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        var str = ""
        
        if !isLoading && !errorLoading {
            str = NSLocalizedString("Wait ...", comment: "")
        } else if errorLoading {
            str = NSLocalizedString("There's a problem Captain", comment: "")
        } else if isLoading {
            str = NSLocalizedString("Ohhh noo", comment: "")
        }
        
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        var str = ""
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        
        if !isLoading && !errorLoading{
            str = NSLocalizedString("We're retrieving your albums", comment: "")
        } else if errorLoading{
            str = NSLocalizedString("Network is not available ... ", comment: "")
        } else if isLoading {
            str = NSLocalizedString("Oh noo ... You don't have any albums as for now ... ", comment: "")
        }
        
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        var image = UIImage()
        image.accessibilityFrame = CGRect(origin: CGPoint(x: scrollView.center.x,y: scrollView.center.y - 20), size: CGSize(width: 200, height: 200))
        if !isLoading && !errorLoading{
            image = UIImage.gifWithName("LoadingView")!
        }else if errorLoading{
            image = UIImage(named: "NoNetwork")!
        } else if isLoading {
            image = UIImage(named: "EmptyAlbumIcon")!
        }
        return image
    }
    
}

// MARK: -TimelineComponentTarget
extension T_AlbumViewController: TimelineComponentTarget {
    
    func loadInRange(range: Range<Int>, completionBlock: ([T_Album]?) -> Void) {
        T_AlbumCacheHelper.queryAllAlbums(range) { (result: [PFObject]?, error: NSError?) -> Void in
            print(T_User.albumListCache[(T_ParseUserHelper.getCurrentUser()?.username)!]?.count)
            if let _ = error {
                if self.timelineComponent.content.count == 0 {
                    self.errorLoading = true
                    self.tableView.reloadEmptyDataSet()
                }
            } else {
                self.isLoading = true
                let posts = result as? [T_Album] ?? []
                // Completion block utilisé pour timelineComponent
                completionBlock(posts)
                
            }
            
        }
    }
    
}
