//
//  PhotosCollectionViewController.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 07/04/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class PhotosCollectionViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var collectionView: UICollectionView!
    
    // A Remplacer par ParseObject
    struct Post {
        var fromUser : String!
        var createdAt : NSDate!
        var image : UIImage!
    }
    
    // Keep in memory where the user stop watching the story of the album
    var storyIndex:Int = 0
    
    var photosArray = [Post]()
    // Used for the slider
    // numberSectionsPhoto.count -> number of sections in our gallery
    // numberSectionsPhoto[i] -> number of photo in the section i
    var photoNumberInSections = [Int]()
    
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // ======== A ENLEVER APRES PARSE =============
        // ============================================
        
        //Reussir a savoir sur combien d'heure on a pris des photos ou l'intervalle entre 2 photos
        let calendar = NSCalendar.currentCalendar()
        let unit:NSCalendarUnit = .Hour
        
        var mySection: Int = 1
        // On charge les photos
        for i in 1...20 {
            let myDate = NSDate().dateByAddingTimeInterval(10*60*Double(i))
            
            
            // Si i vaut 1, c'est la 1ere photo, on initialise
            if i ==  1 {
                mySection = 1
            } else if  i == 20 {
                // On est arrive a la fin du tableau, on ajoute donc bien la derniere section
                // MAIS ATTENTION, avant il faut bien ajouter notre derniere image
                mySection = mySection + 1
                photoNumberInSections.append(mySection)
            } else {
                // On veut d'abord avoir l'heure actuelle que l'on recupere en Int
                let hourStart = calendar.component(unit, fromDate: photosArray[i-2].createdAt)
                // Puis on crée une new date grace a ce Int correspondant à l'heure pile actuelle (sans les minutes)
                let hourDate = calendar.dateBySettingHour(hourStart, minute: 0, second: 0, ofDate: NSDate(), options: [])
                // On regarde maintenant la diff entre la date de la photo et la date de la derniere photo du tableau
                // pour savoir si l'on commence une nouvelle section ou pas
                let diff = calendar.components(unit, fromDate: hourDate!, toDate: myDate, options: [])
                
                // Si la diff est supérieure a 0, on veut donc changer de section, on ajoute l'ancienne
                // section dans notre tableau et on remet le nombre de photo a 1
                if diff.hour > 0 {
                    photoNumberInSections.append(mySection)
                    mySection = 1
                } else {
                    mySection = mySection + 1
                }
            }
            
            let newPost = Post(fromUser: "Valentin", createdAt: myDate, image: UIImage(named: "selfie\(i)"))
            photosArray.append(newPost)
        }
        
        // =======================================
        // ======================================
    }
    
    override func viewWillAppear(animated: Bool) {
        // Do any additional setup after loading the view.
        navigationController?.navigationBarHidden = false
        //collectionView.reloadData()
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
        
//        if segue.identifier == "ShowDetails" {
//            let slideDetailVC = segue.destinationViewController as! PagedScrollViewController
//            
//            // Get the cell that generated this segue
//            if let selectedPicture = sender as? PhotoCollectionViewCell {
//                let indexPath = collectionView.indexPathForCell(selectedPicture)
//                
//                var indexCell = 0
//                for i in 0 ..< (indexPath!.section-1){
//                    indexCell = indexCell + numberSectionsPhoto[i]
//                }
//                
//                // On va donc chercher la photo qui est a l'index suivant
//                // indexCell : nombre de photos avant dans les autre sections
//                // indexPath.row : nombre de photos avant dans la section
//                // -1 : correspond a la bonne image car on a toujours une cell en plus pour l'affichage de l'heure donc on doit l'enlever pour retrouver la bonne image de notre tableau
//                slideDetailVC.currentPage = indexCell + (indexPath?.row)! - 1
//                slideDetailVC.pageImages = self.photosArray
//            }
//        } else if segue.identifier == "ShowStory" {
//            let slideDetailVC = segue.destinationViewController as! StoryViewController
//            slideDetailVC.pageImages = self.photosArray
//            slideDetailVC.currentPage = storyIndex
//        }
    }
    
//    @IBAction func unwindToStoryView(sender: UIStoryboardSegue) {
//        if let sourceViewController = sender.sourceViewController as? StoryViewController {
//            if sourceViewController.currentPage > 0 {
//                storyIndex = sourceViewController.currentPage - 1
//            } else {
//                storyIndex = sourceViewController.currentPage
//            }
//            
//        }
//    }
}

// MARK: - UICollectionView DataSource,Delegate,DelegateFlowLayout
extension PhotosCollectionViewController : UICollectionViewDataSource , UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        // Returning the number of pictures inside each section
        // photoNumberInSections[section - 1] -> section 1 in our collectionView is section 0 in our Array because we have a story section in the collectionView
        //  + 1 -> the cell for the hour
        return photoNumberInSections[section - 1] + 1
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // Story section
        if indexPath.section == 0 {
    
            let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("storyCell", forIndexPath: indexPath) as! StoryCollectionViewCell
            
            cell.layer.cornerRadius = 15
            cell.imageView.image = photosArray[storyIndex].image
            
            return cell
        } else {
        // Photos sections
            // Row O = Hour Cell
            if indexPath.row == 0 {
                let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("hourCell", forIndexPath: indexPath) as! HourCollectionViewCell
                
                cell.layer.cornerRadius = 5
                
                // Find the position of the photo in our Array
                let indexCell = getPhotoIndex(indexPath)
                
                let date = photosArray[indexCell].createdAt
                cell.initHourLabel(date)
                
                return cell
                
            } else {
            // Else = PhotoCell
                let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
                
                cell.layer.cornerRadius = 5
                
                let indexCell = getPhotoIndex(indexPath)
                // -1 -> because we don't have the hourImage in our Array of picture but it's present in the collectionView
                cell.imageView.image = photosArray[indexCell - 1].image
                
                return cell
            }
            
        }
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // Return the size of our array + the story section
        return photoNumberInSections.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "headerCollection", forIndexPath: indexPath) as! HeaderCollectionReusableView
        
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


