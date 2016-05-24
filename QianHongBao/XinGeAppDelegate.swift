//
//  XinGeAppDelegate.swift
//  XinGeSwiftDemo12
//
//  Created by 张青明 on 15/8/27.
//  Copyright (c) 2015年 极客栈. All rights reserved.
//

import UIKit


let IPHONE_8:Int32 = 80000

//ACCESS ID 2200195440  ACCESS KEY I8X681TTZ4IA SECRET KEY c73c564d2d50be511d0ca3f7985beec9

/// ACCESS ID
let kXinGeAppId: UInt32 = 2200195440

/// ACCESS KEY
let kXinGeAppKey:String! = "I8X681TTZ4IA"

class XinGeAppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func registerPushForIOS8()
    {
       // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
        // 会自动识别为 ios8
        //print("-----------aaa")
        //#if __IPHONE_OS_VERSION_MAX_ALLOWED8
        //#if __IPHONE_OS_VERSION_MAX_ALLOWED >= IPHONE_8
            
        if #available(iOS 8.0, *) {
            if NSProcessInfo().isOperatingSystemAtLeastVersion(NSOperatingSystemVersion(majorVersion:
                8, minorVersion: 0, patchVersion: 0)) {
                
                
                //Types
                //var types1 = UIUserNotificationType.Alert ||UIUserNotificationType.Badge||
                
                let types: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
              //  var types = UIUserNotificationType(forTypes: [.Badge, .Sound, .Alert], categories: nil)
                
                //var types = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
                print("-----------")
                
                //Actions
                let acceptAction = UIMutableUserNotificationAction()
                
                acceptAction.identifier = "ACCEPT_IDENTIFIER"
                acceptAction.title      = "Accept"
                
                acceptAction.activationMode = UIUserNotificationActivationMode.Foreground
                
                acceptAction.destructive = false
                acceptAction.authenticationRequired = false
                
                
                //Categories
                let inviteCategory = UIMutableUserNotificationCategory()
                inviteCategory.identifier = "INVITE_CATEGORY";
                
                inviteCategory.setActions([acceptAction], forContext: UIUserNotificationActionContext.Default)
                inviteCategory.setActions([acceptAction], forContext: UIUserNotificationActionContext.Minimal)
                
                var categories = NSSet(objects: inviteCategory)
                
                //        var mySettings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: categories as Set<NSObject>)
                let mySettings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
                
                UIApplication.sharedApplication().registerUserNotificationSettings(mySettings)
            }
        } else {
            // Fallback on earlier versions
        }
        //#endif
    }
    
    func registerPush()
    {
//        UIApplication.sharedApplication().registerForRemoteNotificationTypes(UIRemoteNotificationType.Alert|UIRemoteNotificationType.Badge|UIRemoteNotificationType.Sound)
        
        // swift 2.0语法  ||与&&
        UIApplication.sharedApplication().registerForRemoteNotificationTypes([.Alert,.Badge,.Sound])
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // 注册
        XGPush.startApp(kXinGeAppId, appKey: kXinGeAppKey)
        
        XGPush.initForReregister { () -> Void in
            //如果变成需要注册状态
            if !XGPush.isUnRegisterStatus()
            {
                
                if __IPHONE_OS_VERSION_MAX_ALLOWED >= IPHONE_8
                {
                    
                    
                    if (UIDevice.currentDevice().systemVersion.compare("8", options:.NumericSearch) != NSComparisonResult.OrderedAscending)
                    {
                        print("我的registerPush")
                        self.registerPushForIOS8()
                    }
                    else
                    {
                        self.registerPush()
                        
                        
                    }
                    
                }
                else
                {
                    //iOS8之前注册push方法
                    //注册Push服务，注册后才能收到推送
                    self.registerPush()
                }
                
                
            }
        }
        
//        XGPush.clearLocalNotifications()
        
        
        XGPush.handleLaunching(launchOptions, successCallback: { () -> Void in
            print("[XGPush]handleLaunching's successBlock\n\n")
            }) { () -> Void in
                print("[XGPush]handleLaunching's errorBlock\n\n")
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        return true
    }
    
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        XGPush.localNotificationAtFrontEnd(notification, userInfoKey: "clockID", userInfoValue: "myid")
        
        XGPush.delLocalNotification(notification)
    }
    
    
    @available(iOS, introduced=8.0)
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    @available(iOS, introduced=8.0)
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        
        if let ident = identifier
        {
            if ident == "ACCEPT_IDENTIFIER"
            {
                print("ACCEPT_IDENTIFIER is clicked\n\n")
            }
        }
        
        completionHandler()
    }
    
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        //注册设备
        XGPush.setAccount("dong1")
               // XGSetting.getInstance().Channel = "appstore"//= "appstore"
        //        XGSetting.getInstance().GameServer = "家万户"
        
        
        
        let deviceTokenStr = XGPush.registerDevice(deviceToken, successCallback: { () -> Void in
            print("[XGPush]register successBlock\n\n")
            }) { () -> Void in
                print("[XGPush]register errorBlock\n\n")
        }
        
        print("deviceTokenStr:\(deviceTokenStr)\n\n")
        
        print("666666666")
        
    }
    
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("didFailToRegisterForRemoteNotifications error:\(error.localizedDescription)\n\n")
    }
    
    // iOS 3 以上
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
//        UIAlertView(title: "3-", message: "didReceive", delegate: self, cancelButtonTitle: "OK").show()
        let apsDictionary = userInfo["aps"] as? NSDictionary
        let nowrid = Common.getNowRid()
        //print("收到的消息==========aps===\(userInfo)")
        if let apsDict = apsDictionary
        {
//            let alertView = UIAlertView(title: "您有新的消息", message: apsDict["alert"]!["content"] as? String, delegate: self, cancelButtonTitle: "确定")
//            alertView.show()
            
            // 发送消息通知
            NSNotificationCenter.defaultCenter().postNotificationName("NewMessage", object: nil, userInfo: userInfo )
     
            let temp = apsDict as? NSDictionary
            if let ss = temp {
                print("-------------\(apsDict)")
                let nackname = apsDict["nackname"] as! String
                let uid = apsDict["uid"] as! Int
                let photo = apsDict["photo"] as! String
                var result = false
                
                // 加载上一条信息
                var lastmsg:MessageItem?
                MySQL.loadMessage(0, max_id: 0, rid: nil,uid: uid, finished: { (array) in
                    let maxNum = array.count
                    if maxNum > 1
                    {
                        lastmsg = array[maxNum - 2]
                        let lastname = lastmsg?.name
                        let lastphoto = lastmsg?.headImg
                        result = lastname! as String != nackname || lastphoto! as String != photo

                    }else
                    {
                        return
                    }
                    })
                
                // 根据房间号设置信息状态
                if nowrid != 0 {
                    // 已查看消息 msgStatus = 1
                    MySQL.saveMessage(apsDict as! [String : AnyObject],msgStatus: 1)
                }else{
                    MySQL.saveMessage(apsDict as! [String : AnyObject],msgStatus: 0)
                }

                if result {
                    MySQL.updateMessage(apsDict as! [String : AnyObject])
                }
  
            }else {
                let data = apsDict["alert"] as! String
                let dict = Common.json2obj(data) as! NSDictionary
                // 根据房间号设置信息状态
                if nowrid != 0 {
                    MySQL.saveMessage(dict as! [String : AnyObject],msgStatus: 1)
                }else{
                    MySQL.saveMessage(dict as! [String : AnyObject],msgStatus: 0)
                }
            }

        }
        
        // 清空通知栏通知
        XGPush.clearLocalNotifications()
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        XGPush.handleReceiveNotification(userInfo)
        

    }
    
//    // iOS 7 以上
//    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void)
//    {
////        UIAlertView(title: "7-", message: "didReceive", delegate: self, cancelButtonTitle: "OK").show()
//        let apsDictionary = userInfo["aps"] as? NSDictionary
//        if let apsDict = apsDictionary
//        {
//            let alertView = UIAlertView(title: "您有新的消息", message: apsDict["alert"] as? String, delegate: self, cancelButtonTitle: "确定")
//            
//            alertView.show()
//        }
//        // 清空通知栏通知
//        XGPush.clearLocalNotifications()
//        UIApplication.sharedApplication().cancelAllLocalNotifications()
//        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
//        
//        XGPush.handleReceiveNotification(userInfo)
//    }
    
    
    
}