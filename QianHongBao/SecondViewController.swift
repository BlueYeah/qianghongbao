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
    
    
    let FriendsListCell="roomlistcell"
    
    @IBOutlet weak var tvHall: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let mgr = AFHTTPSessionManager()
        let token = Common.getToken()
        let uid = Common.getUid()
        
        let param:NSDictionary = ["uid":uid, "token":token]
        
        mgr.POST(URL_getRoom, parameters: param, progress: nil, success: { (task, responseObj) in
            print("服务端API接入成功")
            
         
             // 实现token过期
            if responseObj!["status"] as! Int == 0
            {
                MyDialog.showErrorAlert(self, msg: responseObj!["info"] as! String)
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("loginVC") as UIViewController
                self.presentViewController(controller, animated: true, completion: nil)
                
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
//        let time = cell.viewWithTag(TAG_TIME) as! UILabel
//
//        let money = cell.viewWithTag(TAG_LABEL) as! UILabel
        
        let Room = room[indexPath.row]
        
        img.sd_setImageWithURL(NSURL(string: Room.image), placeholderImage: UIImage(named: IMG_LOADING))
        
        name.text = Room.name
        
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // 在进去房间的同时即时保存当前房间rid
        let rid = room[indexPath.row].rid
        print("======进入当前房间 rid=\(rid)")
        Common.setNowRid(rid)
        
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
