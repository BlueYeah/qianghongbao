//
//  String+Category.swift
//  XMGWB
//
//  Created by 李南江 on 15/9/9.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

import UIKit
/*
- Documents
- 需要保存由"应用程序本身"产生的文件或者数据，例如：游戏进度、涂鸦软件的绘图
- 目录中的文件会被自动保存在 iCloud
- 注意：不要保存从网络上下载的文件，否则会无法上架！

- Caches
- 保存临时文件，"后续需要使用"，例如：缓存图片，离线数据(地图数据)
- 系统不会清理 cache 目录中的文件
- 就要求程序开发时，"必须提供 cache 目录的清理解决方案"
- Preferences
- 用户偏好，使用 NSUserDefault 直接读写！
- 如果要想数据及时写入磁盘，还需要调用一个同步方法

- tmp
- 保存临时文件，"后续不需要使用"
- tmp 目录中的文件，系统会自动清理
- 重新启动手机，tmp 目录会被清空
- 系统磁盘空间不足时，系统也会自动清理
*/
extension String
{
    /**
    *  返回缓存路径的完整路径名
    */
    func cacheDir() ->String
    {
        let path = NSSearchPathForDirectoriesInDomains( NSSearchPathDirectory.CachesDirectory,  NSSearchPathDomainMask.UserDomainMask,  true).last! as NSString
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    }
    /**
    *  返回文档路径的完整路径名
    */
    func documentDir() -> String
    {
        let dir = NSSearchPathForDirectoriesInDomains( NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as NSString
        return dir.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    }
    /**
    *  返回临时路径的完整路径名
    */
    func tmpDir() -> String
    {
        let dir = NSTemporaryDirectory() as NSString
        return dir.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    }
}