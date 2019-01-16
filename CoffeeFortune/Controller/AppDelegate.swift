//
//  AppDelegate.swift
//  CoffeeFortune
//
//  Created by Flyco Developer on 9.01.2019.
//  Copyright © 2019 Flyco Global. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Parse.enableLocalDatastore()
        let parseConfig = ParseClientConfiguration {
            $0.applicationId = "eaca8c55dd3056686c1b8c4d814083b91cf221ff"
            $0.clientKey = "3e84ea3d60e218654dda066a129e52ed248517b9"
            $0.server = "http://18.220.244.186:80/parse"
        }
        Parse.initialize(with: parseConfig)
        
        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    @nonobjc func application(_ app: UIApplication, open url: URL, options: [ UIApplication.OpenURLOptionsKey: Any ]) -> Bool? {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
        let annotation = options[UIApplication.OpenURLOptionsKey.annotation] as? String
        let facebookHandler = FBSDKApplicationDelegate.sharedInstance()?.application(app, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        return facebookHandler
    }

}

