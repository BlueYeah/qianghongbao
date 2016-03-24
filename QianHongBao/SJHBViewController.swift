//
//  SJHBViewController.swift
//  QianHongBao
//
//  Created by arkic on 16/2/26.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit

class SJHBViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    let TAG_IMG = 1
    let TAG_NAME = 2
    let TAG_TIME = 3
    let TAG_MONEY = 4

    var data:[Dictionary<String,String>] = []
    
    @IBAction func btnBack(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        var tdata = NSMutableDictionary()
        var tdata:Dictionary<String,String> = ["":""]
        
        
        for _ in 0...10{
            tdata["image"] = "qrcode"
            tdata["name"] = "哈哈哈，猜猜我是谁"
            tdata["time"] = "12:21"
            tdata["money"] = "10.04元"
            data.append(tdata)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let chatcell = "sjhblistcell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(chatcell, forIndexPath: indexPath) as UITableViewCell
        
        let img = cell.viewWithTag(TAG_IMG) as! UIImageView
        
        let name = cell.viewWithTag(TAG_NAME) as! UILabel
        
        let time = cell.viewWithTag(TAG_TIME) as! UILabel

        let money = cell.viewWithTag(TAG_MONEY) as! UILabel
        
        var tdata:Dictionary<String,String> = data[indexPath.row]
        
        img.image = UIImage(named: tdata["image"]!)
        
        name.text = tdata["name"]
        
        time.text = tdata["time"]
        
        money.text = tdata["money"]
        
        return cell
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
