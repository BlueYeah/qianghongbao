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

    @IBOutlet weak var myWebView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 获取用户uid 和token
        let uid = Common.getUid()
        let token = Common.getToken()
        
//        let url = "http://192.168.111.106/QHB/User/notice/uid/\(uid)/token/\(token)"
//        print("weburl=====\(url)")
//        let request:NSURLRequest = NSURLRequest(URL: NSURL(fileURLWithPath:url))
//        webview.loadRequest(request)
        let webView = UIWebView(frame:self.view.bounds)
        let dataurl = SERVER_HTTP + "User/notice/uid/\(uid)/token/\(token)"
        
        let url = NSURL(string: dataurl)
        let request = NSURLRequest(URL: url!)


        let data = NSData(contentsOfURL: url!)
        
        
        
        webView.loadData(data!, MIMEType: "text/html", textEncodingName: "UTF-8", baseURL: url!)

        self.myWebView.addSubview(webView)
        

        
        
        
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
