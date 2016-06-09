//
//  AppDelegate.swift
//  TimeshotApp
//
//  Created by Valentin PAUL on 08/03/16.
//  Copyright © 2016 Timeshot. All rights reserved.
//
//  test de conflit

import UIKit
import Parse
import ParseFacebookUtilsV4

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    //var parseLogin : ParseLoginHelper?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        T_User.registerSubclass()
        T_Album.registerSubclass()
        T_Post.registerSubclass()
        T_Vote.registerSubclass()
        Parse.enableLocalDatastore()
        
        // Set up the Parse SDK
        Parse.setApplicationId("uAhZdofpZFzSCMa83PbQwFx2ls3qmWbvr0BADedv", clientKey: "1PPkLR8lj8bqH9ppX6Y1dMXWKewFhiaxs6oEjrr3")
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        PFUser.enableRevocableSessionInBackground()
        
        T_ParseUserHelper.login("Karim", password: "karim")
        
        let startViewController: UIViewController;
        
        if let user = PFUser.currentUser() {
            if false {
                let storyboard = UIStoryboard(name: "Koloda", bundle: nil)
                startViewController = storyboard.instantiateViewControllerWithIdentifier("Start")
            }
            else {
                if user.username == nil {
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    startViewController = storyboard.instantiateViewControllerWithIdentifier("T_SignUpUsernameViaFacebookNavigationController")
                }
                else {
                    //TODO Traiter le cas ou l'utilisateur s'est fait kick de la DB : TimeshotApp[5519:438979] [Error]: invalid session token (Code: 209, Version: 1.13.0)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    startViewController = storyboard.instantiateViewControllerWithIdentifier("HomePageViewController")
                }
            }
            
        } else {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            startViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as! UINavigationController
        }
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = startViewController;
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(application: UIApplication,
                     openURL url: NSURL,
                             sourceApplication: String?,
                             annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                     openURL: url,
                                                                     sourceApplication: sourceApplication,
                                                                     annotation: annotation)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

