//
//  DataViewController.swift
//  QianHongBao
//
//  Created by arkic on 16/3/2.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit
import AFNetworking

class DataViewController: UIViewController {

    @IBOutlet weak var lTitle: UILabel!
    @IBOutlet weak var tvData: UITextView!
    @IBAction func btnBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 获取用户uid 和token
        let uid = Common.getUid()
        let token = Common.getToken()
        
        let mgr = AFHTTPSessionManager()
        
        let param:NSDictionary = ["uid":uid ,"token":token]
        
        
       mgr.POST(URL_getUserNotice, parameters: param, progress: nil, success: { (task, responseObj) in
        print("=====服务端API接入成功")
        print("===========response\(responseObj)=====info\(responseObj!["info"])")
        
        let str = responseObj!["data"] as! String
        
        let index = str.startIndex.advancedBy(3)
        let index2 = str.endIndex.advancedBy(-4)
        let range = Range<String.Index>(start: index, end: index2)
        let notice = str.substringWithRange(range)
        
        //print("========notice\(notice)")
        self.tvData.text = notice
        
        
        
        }) { (task, error) in
            print("===========服务端API接入失败")
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
