//
//  SJHBViewController.swift
//  QianHongBao
//
//  Created by arkic on 16/2/26.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit
import AFNetworking

class SJHBViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    let TAG_IMG = 1
    let TAG_NAME = 2
    let TAG_TIME = 3
    let TAG_MONEY = 4

    var data:[Dictionary<String,String>] = []
    
    @IBOutlet weak var mUITableView: UITableView!
    @IBAction func btnBack(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        var tdata = NSMutableDictionary()
        var tdata:Dictionary<String,String> = ["":""]
        
        
//        for _ in 0...10{
//            tdata["image"] = "qrcode"
//            tdata["name"] = "哈哈哈，猜猜我是谁"
//            tdata["time"] = "12:21"
//            tdata["money"] = "10.04元"
//            data.append(tdata)
//        }
        
        let mgr = AFHTTPSessionManager()
        let token = Common.getToken()
        let uid = Common.getUid()
        let bonus_id = Common.getBonusId()
        
        let param:NSDictionary = ["uid":uid, "token":token,"id":bonus_id ]
        
        print("===========id\(bonus_id) uid\(uid) toke\(token)")
        
        
        
        mgr.POST(URL_getRandomBonus, parameters: param, progress: nil, success: { (task, responseObj) in
            print("服务端API接入成功")
            print("=============data\(responseObj!["data"])")
            //let data = Common.json2obj(responseObj["data"])
            
            let randombonus = responseObj!["data"]!!["randombonus"]as! NSArray
            let randombonu = randombonus[0] as! NSDictionary
            let money = String(randombonu["bonus"] as! NSNumber)
            print("=============USER=\(randombonu["user"])")
            let user = randombonu["user"]as! NSDictionary
            let time = randombonu["time"]as! String
            let image = user["photo"]as! String
            let name = user["nackname"]as! String
            
            tdata["image"] = image
            tdata["name"] = name
            tdata["time"] = time
            tdata["money"] = money
            self.data.append(tdata)
            print("=====\(tdata)")
        
            self.mUITableView.reloadData()
            
            
            
            
            print("-----------------response的message\(responseObj!["err_msg"]) 和ALL\(responseObj) ")
            }) { (task, error) in
                print(error)
                
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
        
        // 设置抢红包用户头像
        img.sd_setImageWithURL(NSURL(string: tdata["image"]!), placeholderImage: UIImage(named: IMG_LOADING))
        
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
