//
//  PhotosCollectionViewController.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 07/04/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import Parse
import AFDateHelper

class T_PhotosCollectionViewController: UIViewController {
    
    struct Post {
        var fromUser : String!
        var createdAt : NSDate!
        var image : UIImage!
    }

    
    
    // MARK: Properties
    @IBOutlet weak var collectionView: UICollectionView!
    
    var albumPhotos : T_Album?
    var posts:[T_Post] = []
    var storyIndex = 0

    // Used for the slider
    // numberSectionsPhoto.count -> number of sections in our gallery
    // numberSectionsPhoto[i] -> number of photo in the section i
    var photoNumberInSections = [Int]()
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For DZNEmptyState
        collectionView.emptyDataSetDelegate = self
        collectionView.emptyDataSetSource = self
        
        // On veut un tableau de la taille du nombre d'heure que l'on a !
        // Car chaque heure est une section
        if let album = albumPhotos {
            for _ in 0..<album.duration {
                photoNumberInSections.append(0)
            }
        }
        
        T_ParsePostHelper.postsForCurrentAlbum(albumPhotos!) {(result: [PFObject]?, error: NSError?) -> Void in
            self.posts = result as? [T_Post] ?? []
            
            // Initialisation du nombre de photos
            // et de la section en cours
            var numberOfPictInSection = 0
            var section = 0
            
            // Pour chaque post on doit alors savoir dans quelle section il est mais aussi 
            // charger son image
            for post in self.posts {
                let date = post.createdAt!
                
                // On regarde maintenant la diff entre la date de la photo et la date de la derniere photo du tableau
                // pour savoir si l'on commence une nouvelle section ou pas
                if let indexPost = self.posts.indexOf(post) where indexPost == 0 {
                    // On est a la premiere photo de notre album ! Donc on initialise
                    numberOfPictInSection += 1
                    section = 0
                    
                    // Si on a qu'une seule photo dans l'album on le stocke direct dans la section
                    if indexPost ==  self.posts.count - 1 {
                        self.photoNumberInSections[section] = numberOfPictInSection
                    }
                } else if let indexPost = self.posts.indexOf(post) where indexPost == (self.posts.count-1) {
                    // On est a la derniere photo de notre album donc on ajoute et on arrete
                    numberOfPictInSection += 1
                    self.photoNumberInSections[section] = numberOfPictInSection
                } else if let indexPost = self.posts.indexOf(post) where indexPost > 0 {
                    // Si on est ni a la premiere ni a la derniere on regarde si elle correspond a la section actuelle
                    // ou si elle correspond a une autre section car prise à une nouvelle heure
                    let diff = date.hoursAfterDate(self.posts[indexPost - 1].createdAt!)
                    if diff > 0 {
                        self.photoNumberInSections[section] = numberOfPictInSection
                        numberOfPictInSection = 1
                        section += 1
                    } else {
                        numberOfPictInSection += 1
                    }
                } else  {
                    print("il y a une erreur ou cas non pris en compte")
                }
            }
            
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        // Do any additional setup after loading the view.
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Function
    func getPhotoIndex(indexPath : NSIndexPath) -> Int {
        var indexCell = 0
        for i in 0 ..< (indexPath.section-1){
            indexCell = indexCell + photoNumberInSections[i]
        }
        
        indexCell += indexPath.row
        
        return indexCell
    }
    
    // MARK: Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowSlider" {
            let slideDetailVC = segue.destinationViewController as! T_SliderViewController
            
            // Get the cell that generated this segue
            if let selectedPicture = sender as? T_PhotoCollectionViewCell {
                let indexPath = collectionView.indexPathForCell(selectedPicture)
                
                let indexCell = getPhotoIndex(indexPath!) - 1
                slideDetailVC.currentSlide = indexCell
                slideDetailVC.slideImages = self.posts
            }
        } else if segue.identifier == "ShowStory" {
            let slideDetailVC = segue.destinationViewController as! T_StoryViewController
            slideDetailVC.pageImages = []//self.photosArray
            slideDetailVC.currentPage = storyIndex
        }
    }
    
    @IBAction func unwindToStoryView(sender: UIStoryboardSegue) {
        // We nedd the update our view and now where the user stopped the story
        if let sourceViewController = sender.sourceViewController as? T_StoryViewController {
            if sourceViewController.currentPage > 0 {
                storyIndex = sourceViewController.currentPage - 1
            } else {
                storyIndex = sourceViewController.currentPage
            }
            
        }
    }
}

// MARK: - UICollectionView DataSource,Delegate,DelegateFlowLayout
extension T_PhotosCollectionViewController : UICollectionViewDataSource , UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photoNumberInSections.count > 0 {
            if section == 0{
                return 1
            } else if photoNumberInSections[section - 1] > 0 {
                // Returning the number of pictures inside each section
                // photoNumberInSections[section - 1] -> section 1 in our collectionView is section 0 in our Array because we have a story section in the collectionView
                //  + 1 -> the cell for the hour
                return photoNumberInSections[section - 1] + 1
            } else {
                return 0
            }
        } else {
            return 0
        }
    
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // Story section
        if indexPath.section == 0 {
    
            let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("storyCell", forIndexPath: indexPath) as! T_StoryCollectionViewCell
            
            cell.layer.cornerRadius = 15
            cell.imageView.image = posts[storyIndex].image.value
            //cell.imageView.image = photosArray[storyIndex].image
            
            return cell
        } else {
        // Photos sections
            // Row O = Hour Cell
            if indexPath.row == 0 {
                let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("hourCell", forIndexPath: indexPath) as! T_HourCollectionViewCell
                
                cell.layer.cornerRadius = 5
                
                // Find the position of the photo in our Array
                let indexCell = getPhotoIndex(indexPath)
                
                //let date = photosArray[indexCell].createdAt
                let date = posts[indexCell].createdAt!
                cell.initHourLabel(date)
                
                return cell
                
            } else {
            // Else = PhotoCell
                let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! T_PhotoCollectionViewCell
                
                cell.layer.cornerRadius = 5
                
                let indexCell = getPhotoIndex(indexPath)
                // -1 -> because we don't have the hourImage in our Array of picture but it's present in the collectionView
                //cell.imageView.image = photosArray[indexCell - 1].image
                let post = posts[indexCell - 1]
                post.downloadImage()
                cell.post = post
                return cell
            }
            
        }
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if posts.count > 0 {
            // Return the size of our array + the story section
            return photoNumberInSections.count + 1
        } else {
            return 0
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "headerCollection", forIndexPath: indexPath) as! T_HeaderCollectionReusableView
        
        var title : String
        if indexPath.section == 0 {
            title = NSLocalizedString("  Story  ", comment: "")
        } else {
            title = NSLocalizedString("  Photos  ", comment: "")
        }
        headerView.sectionNameLabel.text = title
        T_DesignHelper.colorUIView(headerView.lineView)
        return headerView
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section > 1 {
            return CGSizeZero
        } else {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
    }
    // For dynamic size of the photo cells
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.section == 0 {
            let width = self.view.frame.size.width - 20
            
            return CGSize(width: width, height: 80)
        }else {
            let width = self.view.frame.size.width / 3.0 - 8
            
            return CGSize(width: width, height: width)
        }
    }
    
    
}


// MARK: - DZNEmptyDataState 
extension T_PhotosCollectionViewController : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
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


