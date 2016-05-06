//
//  AppDelegate.swift
//  QianHongBao
//
//  Created by arkic on 16/1/10.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: XinGeAppDelegate {

    var window: UIWindow?


    override func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let uid = Common.getUid()
        
        if(uid == 0){
            
            let st = self.window?.rootViewController?.storyboard
            let vc = st!.instantiateViewControllerWithIdentifier("loginVC") as UIViewController
            self.window?.rootViewController = vc
            //var vc = self.storyboard?.instantiateViewControllerWithIdentifier("mTabBarVC") as UITabBarController
            //self.presentViewController(vc, animated: true, completion: nil)
        }
        
        // 打开数据库
        SQLiteManager.sharedSQLiteManager.openDB("status.db")
        
        // return true
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

