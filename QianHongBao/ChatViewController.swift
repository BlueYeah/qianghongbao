//
//  ChatViewController.swift
//  QianHongBao
//
//  Created by arkic on 16/1/10.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit
import CryptoSwift
import AFNetworking
class ChatViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var textFieldSend: UITextField!
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var Vcname: UILabel!
    //chat data
    var chatData:Array<MessageItem>!
    
    var mMJRefreshHeader:MJRefreshNormalHeader!
    let mgr = AFHTTPSessionManager()
    let nowRid = Common.getNowRid()
    
    @IBOutlet weak var mTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()


        
        //init data
        self.chatData = [


            
        ]

        
        changeVcName(nowRid)


        MySQL.loadMessage(0, max_id: 0, rid: nowRid) { (array) in
            self.chatData = array
        }
        
    
//        self.mMJRefreshHeader = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "pullRefresh")
        
        self.chatTableView.registerClass(ChatTableViewCell.self, forCellReuseIdentifier: "textcell")
        
        self.chatTableView.registerClass(ChatTableViewCell.self, forCellReuseIdentifier: "hbcell")
        
//        mTableView.addSubview(mMJRefreshHeader)
        // Do any additional setup after loading the view.
        
        //scroll to bottom
        if chatData.count > 5 {
            
            let indexPath = NSIndexPath(forRow: chatData.count-1, inSection: 0)
            mTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
       
        
        
        // 接收聊天消息通知
        // 监听通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.ReceiveMessage(_:)), name: "NewMessage", object: nil)
        
        
    }
    
    func changeVcName(rid:Int) {
        if rid == 1 {
            Vcname.text = "100元红包群"
        } else if rid == 2
        {
            Vcname.text = "100单双"
        }else if rid == 3
        {
            Vcname.text = "80红包群"
        }else if rid == 4
        {
            Vcname.text = "200红包群"
        }else if rid == 5
        {
            Vcname.text = "50单双"
        }
    }
    
    func ReceiveMessage(notification: NSNotification) {

        let apsDictionary = notification.userInfo!["aps"] as? NSDictionary
        
        if let apsDict = apsDictionary!["alert"]
        {
            

            let alert:NSDictionary
            
            
            
            let json = apsDict as? String
            
            if  json != nil {
                alert = Common.json2obj(apsDict as! String) as! NSDictionary
            }
            else {
            
            
              alert = apsDict as! NSDictionary
            }
            
            print("==========接受到消息啊！！！\(alert)")
   
            
            //apsDict["alert"]
            let msg = alert["content"]
            

            let nickName = alert["nackname"] as! String
            
            let type =   alert["type"] as! Int
            
            let photo = alert["photo"] as! String
            
            let uid = alert["uid"] as! Int
            
            let rid = alert["rid"] as! Int
            let date = alert["date"] as! String
            
            
            let myuid = Common.getUid()
            let nowRid = Common.getNowRid()
            
            //判断是否是这房间的消息
            if nowRid != rid {
                return
            }
            
            // 判断是否是我自己的消息
            if uid == myuid && type == 1{
             return
  
            }

            if type == 1 {
                chatData.append(MessageItem(uid:1,type:ChatType.Text,name:nickName as String,headImg:photo ,content:msg! as! String,bonusId:nil,dsBonus: nil ,date: date))
              
            }else if type == 2
            {

                // 判断红包是我发的
                let bonus_id = Int(alert["id"] as! NSNumber)
                
                var Userid:Int = 1
                
                if uid == myuid {
                    Userid = 0
                }
                    chatData.append(MessageItem(uid:Userid,type:ChatType.SJHB,name:nickName as String,headImg:photo ,content:msg! as! String,bonusId:bonus_id,dsBonus: nil,date: date))
   
            }else if type == 3
            
            {
                print("=======猜单双")
                let bonus_id = Int(alert["id"] as! NSNumber)
                print("--------bonus_total\(alert["bonus_total"])")
                
                let bonus_total = Float(alert["bonus_total"] as! NSNumber)
                let date = alert["date"] as! String
                let dsTime =  alert["dsTime"] as! float_t
                
                
                let dsBonus = DSBonus.init(id: bonus_id, bonus_total: bonus_total, date: date,dsTime: dsTime)
                
                var Userid:Int = 1
                
                if uid == myuid {
                    Userid = 0
                }
                
                chatData.append(MessageItem(uid:1,type:ChatType.CDS,name:nickName as String,headImg:photo ,content:msg! as! String,bonusId:bonus_id,dsBonus: dsBonus,date: date))
            }else if type == 4
            {
                chatData.append(MessageItem(uid:1,type:ChatType.Text,name:nickName as String,headImg:photo ,content:msg! as! String,bonusId:nil,dsBonus: nil,date: date))
                
            }
            else if type == 5
            {
                let message:String
                if msg as! String == "1"
                {
                    message = "本期单双开奖结果：单"
                }else {message = "本期单双开奖结果：双"}
                
                chatData.append(MessageItem(uid:1,type:ChatType.Text,name:nickName as String,headImg:photo ,content:message ,bonusId:nil,dsBonus: nil,date: date))
                
            }

            mTableView.reloadData()
        }

    }
    
    func SendMessage(message: NSString ,rid: Int) {

        
        let type = "all_device"
        let uid = Common.getUid()
        let photo = Common.getHeadImg()
        let nickName = Common.getNickName()
        // 2.获取当前时间字符串
        let date:NSDate = NSDate()
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.stringFromDate(date)
        
        
        let appDict:NSDictionary = ["id":0,"uid":uid, "content":message, "rid":rid ,"date":dateString ,"photo":photo ,"nackname":nickName ,"type":1,"status":1,"bonus_total":0,"dsTime":0]
        
        //设置message
        let dict:NSDictionary = ["alert":appDict]
        
        let message = MyXG.message(dict)
        
        
        let param = MyXG.sendMessage(access_id as String, type: type, message: message, enviroment: "1", messageType: "0")
        
        let mgr = AFHTTPSessionManager()
        
        let url = "\(XGurl)\(type)"
        
        mgr.POST(url, parameters: param, progress: nil, success: { (task, responseObj) in
            print("服务端API接入成功")
            
//            print("-----------------response的message\(responseObj!["err_msg"]) 和ALL\(responseObj) ")
            
        }) { (task, error) in
            print(error)
        }
        
        

        

        
    }
    
    func SendAdMessage(message: NSString ,rid: Int) {
        
        
        let type = "all_device"
        let uid = Common.getUid()
        let photo = Common.getHeadImg()
        let nickName = Common.getNickName()
        // 2.获取当前时间字符串
        let date:NSDate = NSDate()
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.stringFromDate(date)
        
        let appDict:NSDictionary = ["id":0,"uid":uid, "content":message, "rid":rid ,"date":dateString ,"photo":photo ,"nackname":nickName ,"type":1,"status":1,"bonus_total":0,"dsTime":0]
        
        //设置message
        
        let message = MyXG.Admessage(appDict)
        
        let param = MyXG.sendMessage(adAccess_id as String, type: type, message: message, enviroment: "0", messageType: "2")
        
        
        
        
        let url = "\(XGurl)\(type)"
        
        print("ad的字典=============\(param)")
        mgr.POST(url, parameters: param, progress: nil, success: { (task, responseObj) in
            print("服务端API接入成功")
            
                    print("-----------------response的message\(responseObj!["err_msg"]) 和ALL\(responseObj) ")
            
        }) { (task, error) in
            print(error)
        }
        
        
    }
    
    func pullRefresh(){
        self.mMJRefreshHeader.endRefreshing()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //go back
    @IBAction func btnBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    //send message
    @IBAction func btnSend(sender: AnyObject) {
        let msg = textFieldSend.text
        if(msg==""){
            
            // 测试随机红包
            let url1 = "http://192.168.111.106/QHB/Room/testsendhb/rid/1/uid/6"
            mgr.POST(url1, parameters: nil, success: { (task, respon) in
                print("红包要发送啦======")
            }) { (task, error) in
                print("红包发送失败")
            }
            return
        }
        
        let photo = Common.getHeadImg()
        let nickName = Common.getNickName()
        
        // 2.获取当前时间字符串
        let date:NSDate = NSDate()
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.stringFromDate(date)
        
        chatData.append(MessageItem(uid:0,type:ChatType.Text,name:nickName,headImg:photo,content:msg!,bonusId: nil,dsBonus: nil,date: dateString))

        textFieldSend.text = ""
        
        mTableView.reloadData()
        
        //scroll to bottom
        let indexPath = NSIndexPath(forRow: chatData.count-1, inSection: 0)
        mTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        
        
        // 信鸽
        let rid = Common.getNowRid()
        
        SendMessage(msg!, rid: rid)
        SendAdMessage(msg!, rid: rid)


        
 

        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatData.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let messageItem = chatData[indexPath.row]
        
        if(messageItem.type == ChatType.Text){
            let font = UIFont.boldSystemFontOfSize(CGFloat(14))
            //measure width and height
            var attr = Dictionary<String,AnyObject>()
            attr[NSFontAttributeName]  = font
            let contentSize = NSString(string: messageItem.content).boundingRectWithSize(CGSize(width: 210,height: 1000), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attr, context: nil)
            if contentSize.height>60{
                return contentSize.height+45
            }
            return 95
        }else if(messageItem.type == ChatType.SJHB || messageItem.type == ChatType.CDS){
            
            return 135
        }
        return 95
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let item = chatData[indexPath.row] as MessageItem
        let lastmsg:String
        let lastitem:MessageItem
        print("chatdata\(chatData.count)")
        if (indexPath.row > 1) {
                 lastitem = chatData[indexPath.row - 1] as MessageItem
                 lastmsg = lastitem.date!


            
        }else{
            lastitem = chatData[indexPath.row] as MessageItem
            lastmsg = lastitem.date!}
        
        
        
        var chatcell = "textcell"
        if(item.type == ChatType.CDS || item.type == ChatType.SJHB){
            chatcell = "hbcell"
        }
        
        var cell = tableView.dequeueReusableCellWithIdentifier(chatcell, forIndexPath: indexPath) as? ChatTableViewCell
        
        if(cell==nil){
            
            cell = ChatTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: chatcell)

        }
        cell!.adaptData(item,lastmsg: lastmsg)
        cell?.messageItem = item
        return cell!
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.whiteColor()
        
    }
    

    
    @IBAction func tapAction(sender: AnyObject) {
        
        view.endEditing(true)
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
