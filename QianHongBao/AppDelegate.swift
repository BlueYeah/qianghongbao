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
        Common.setNowRid(0)
        
        
        let st = self.window?.rootViewController?.storyboard
        if isNewupdate() {
            //返回真，有新版本，进入新特性界面  NewFeatureVCID
            
            let newFeatueCollectionVC = st!.instantiateViewControllerWithIdentifier("NewFeatureVCID")
            window?.rootViewController = newFeatueCollectionVC
            
        }else{
            //没有新版本，进入登录界面
            if(uid == 0){
                
                let st = self.window?.rootViewController?.storyboard
                let vc = st!.instantiateViewControllerWithIdentifier("loginVC") as UIViewController
                self.window?.rootViewController = vc
                
            }
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
    print("app被杀死")
      //  XGPush.unRegisterDevice()
        
    }
    private func isNewupdate() -> Bool{
        // 1.获取当前软件的版本号 --> info.plist
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
        // 2.获取以前的软件版本号 --> 从本地文件中读取(以前自己存储的)
        let sandboxVersion =  NSUserDefaults.standardUserDefaults().objectForKey("CFBundleShortVersionString") as? String ?? ""
        print("current = \(currentVersion) sandbox = \(sandboxVersion)")
        
        // 3.比较当前版本号和以前版本号
        //   2.0                    1.0
        if currentVersion.compare(sandboxVersion) == NSComparisonResult.OrderedDescending
        {
            // 3.1.1存储当前最新的版本号
            NSUserDefaults.standardUserDefaults().setObject(currentVersion, forKey: "CFBundleShortVersionString")
            return true
        }
        
        return false
    }


}

