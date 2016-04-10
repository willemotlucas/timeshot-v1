//
//  T_HomePageViewController.swift
//  TimeshotApp
//
//  Created by Paul Jeannot on 17/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_HomePageViewController: UIPageViewController {
    
    static var instance:T_HomePageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        T_HomePageViewController.instance = self
        
        // Starting with the CameraViewController
        let cameraViewController = orderedViewControllers[1]
        setViewControllers([cameraViewController], direction: .Forward, animated: true, completion: nil)
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newController("Profile"),
            self.newController("Main"),
            self.newController("Album")]
    }()
    
    private func newController(name: String) -> UIViewController {
        switch (name) {
        case "Main":
            return UIStoryboard(name: name, bundle: nil) .
                instantiateViewControllerWithIdentifier("CameraViewController")
            
        default:
            return UIStoryboard(name: name, bundle: nil) .
                instantiateViewControllerWithIdentifier("\(name)ViewController")
        }
    }
    
    static func showProfileViewController() {
        
        instance.setViewControllers([instance.orderedViewControllers[0]], direction: .Reverse , animated: true, completion: nil)
    }

    static func showCameraViewControllerFromProfile() {
        
        instance.setViewControllers([instance.orderedViewControllers[1]], direction: .Forward , animated: true, completion: nil)
    }

    static func showCameraViewControllerFromAlbum() {
        
        instance.setViewControllers([instance.orderedViewControllers[1]], direction: .Reverse , animated: true, completion: nil)
    }

    static func showAlbumViewController() {
        
        instance.setViewControllers([instance.orderedViewControllers[2]], direction: .Forward , animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Extension DataSource

extension T_HomePageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
                return nil
            }
            
            let previousIndex = viewControllerIndex - 1
            
            guard previousIndex >= 0 else {
                return nil
            }
            
            guard orderedViewControllers.count > previousIndex else {
                return nil
            }
            
            return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
                return nil
            }
            
            let nextIndex = viewControllerIndex + 1
            let orderedViewControllersCount = orderedViewControllers.count
            
            guard orderedViewControllersCount != nextIndex else {
                return nil
            }
            
            guard orderedViewControllersCount > nextIndex else {
                return nil
            }
            
            return orderedViewControllers[nextIndex]
    }
    
}

