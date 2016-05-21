//
//  ThreeViewController.swift
//  QianHongBao
//
//  Created by arkic on 16/1/10.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit
import AFNetworking
class SecondViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let TAG_IMG = 1
    let TAG_NAME = 2
    let TAG_TIME = 3
    let TAG_LABEL = 4
    
    var room:[Room] = []
    var roomData:Array<MessageItem>!
    
    let FriendsListCell="roomlistcell"
    
    @IBOutlet weak var tvHall: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }
    
    override func viewWillAppear(animated: Bool) {
        print("---------------------------")
        
        let mgr = AFHTTPSessionManager()
        let token = Common.getToken()
        let uid = Common.getUid()
        
        let param:NSDictionary = ["uid":uid, "token":token]
        print("========second token\(token)")
        mgr.POST(URL_getRoom, parameters: param, progress: nil, success: { (task, responseObj) in
            print("服务端API接入成功")
            
            
            //print("second===========\(responseObj)========info\(responseObj!["info"])=========status\(responseObj!["status"])")
            
            // 实现token过期
            if responseObj!["status"] as! Int != 1
            {
                
                
                MyDialog.showErrorAlert(self, msg: responseObj!["info"] as! String, completion: {
                    var vc = UIApplication.sharedApplication().keyWindow?.rootViewController
                    while(vc?.presentedViewController != nil){
                        vc = vc?.presentedViewController
                    }
                    
                    
                    let controller = vc!.storyboard!.instantiateViewControllerWithIdentifier("loginVC") as UIViewController
                    vc?.presentViewController(controller, animated: true, completion: nil)
                })
                return
                
            }
            
            
            
            
            
            let temp = responseObj!["data"] as? String
            
            
            if let sss = temp
            {
                let datastring = responseObj!["data"] as!String
                let data = Common.json2obj(datastring) as! NSArray
                
                self.room = Room.initWithRoom(data)
                
                self.tvHall.reloadData()
                
            }else {
                
                
                return
            }
            
            
            
            
            
            
        }) { (task, error) in
            let hud1 = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud1.label.text = "网络异常"
            hud1.hideAnimated(true, afterDelay: 1)
            print(error)
        }
        
        // Do any additional setup after loading the view.
        let view = UIView()
        //        view.frame.size = CGSizeMake(tvHall.frame.width, 10)
        tvHall.tableFooterView = view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return room.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(FriendsListCell, forIndexPath: indexPath) as UITableViewCell
        
        let img = cell.viewWithTag(TAG_IMG) as! UIImageView
        
        let name = cell.viewWithTag(TAG_NAME) as! UILabel
//        
        let time = cell.viewWithTag(TAG_TIME) as! UILabel
//
        let text = cell.viewWithTag(TAG_LABEL) as! UILabel
        
        let Room = room[indexPath.row]
        
        img.sd_setImageWithURL(NSURL(string: Room.image), placeholderImage: UIImage(named: IMG_LOADING))
        

 
        name.text = Room.name
        
        MySQL.loadMessage(0, max_id: 0, rid: Room.rid) { (array) in
            self.roomData = array
        }
      
        if (self.roomData.count > 0) {
            
            let date:String = roomData[roomData.count-1].date!
        
            //time.text = Common.getSeconds(date)
            
            time.text = Common.friendlyTime(date)
            text.text = roomData[roomData.count-1].content
        }else {
            time.text = ""
            
            text.text = ""
        }

        

        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // 在进去房间的同时即时保存当前房间rid
        let rid = room[indexPath.row].rid
        print("======进入当前房间 rid=\(rid)")
        Common.setNowRid(rid)
        
        XGPush.setTag(String (rid))
        let controller = storyboard!.instantiateViewControllerWithIdentifier("chatViewController") as UIViewController
        presentViewController(controller, animated: true, completion: nil)
        


        
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
