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
    //chat data
    var chatData:Array<MessageItem>!
    
    var mMJRefreshHeader:MJRefreshNormalHeader!
    

    @IBOutlet weak var mTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //init data
        self.chatData = [

            MessageItem(uid: 1,type: ChatType.Text,name:"System",headImg: "qrcode",content: "fuck fuck fuck fuck fuck"),
            MessageItem(uid: 1,type: ChatType.SJHB,name:"System",headImg: "qrcode",content: "1000"),
            MessageItem(uid: 1,type: ChatType.CDS,name:"System",headImg: "qrcode",content: "300")
        ]
    
//        self.mMJRefreshHeader = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "pullRefresh")
        
        self.chatTableView.registerClass(ChatTableViewCell.self, forCellReuseIdentifier: "textcell")
        
        self.chatTableView.registerClass(ChatTableViewCell.self, forCellReuseIdentifier: "hbcell")
        
//        mTableView.addSubview(mMJRefreshHeader)
        // Do any additional setup after loading the view.
        
        
        // 接收聊天消息通知
        // 监听通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.ReceiveMessage(_:)), name: "NewMessage", object: nil)
        
        
    }
    
    func ReceiveMessage(notification: NSNotification) {

        let apsDictionary = notification.userInfo!["aps"] as? NSDictionary
        
        if let apsDict = apsDictionary!["alert"]
        {
            
            print("=========aps=\(apsDictionary)")
             print("===========chat_alert\(apsDict)")
            //var alert = apsDict
            // alert若是json字符串 再解析一遍
 
            //let alert = Common.json2obj(apsDict as! String) as! NSDictionary
            
//            let json = apsDict as? String
            let alert:NSDictionary
            
            
            
            let json = apsDict as? String
            
            if  json != nil {
                alert = Common.json2obj(apsDict as! String) as! NSDictionary
            }
            else {
            
            
              alert = apsDict as! NSDictionary
            }
            let uid = alert["uid"] as! Int
            let myuid = Common.getUid()
            
            
            if uid == myuid {
                return
            }
            
            //apsDict["alert"]
            let msg = alert["content"]
            

            let nickName = alert["nackname"] as! String
            
            let type = alert["type"] as! Int
            
            let photo = alert["photo"] as! String
            
            
               // 如果有红包
            let id = alert["id"] as? Int
           if (id != nil)
            
            {
                 let bonus_id = String(alert["id"] as! NSNumber)
                // 存放红包id
                Common.setBonusId(bonus_id as String )
            }
           
            
            if type == 1 {
                chatData.append(MessageItem(uid:1,type:ChatType.Text,name:nickName as String,headImg:photo as String,content:msg! as! String))
            }else if type == 2
            {
                chatData.append(MessageItem(uid:1,type:ChatType.SJHB,name:nickName as String,headImg:photo as String,content:msg! as! String))
            }
            
            
            
            mTableView.reloadData()
        }

    }
    
    func SendMessage(message: NSString ,rid: NSString) {

        
        let type = "all_device"
        let uid = Common.getUid()
        let photo = Common.getHeadImg()
        let nickName = Common.getNickName()
        
        let appDict:NSDictionary = ["uid":uid, "content":message, "rid":rid ,"date":"123" ,"photo":photo ,"nackname":nickName ,"type":1]
        
        //设置message
        let dict:NSDictionary = ["alert":appDict]
        
        let message = MyXG.message(dict)
        
        
        let param = MyXG.sendMessage(type, message:message)
        
        let mgr = AFHTTPSessionManager()
        
        let url = "\(XGurl)\(type)"
        
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
            return
        }
        
        let photo = Common.getHeadImg()
        let nickName = Common.getNickName()
        
        chatData.append(MessageItem(uid:0,type:ChatType.Text,name:nickName,headImg:photo,content:msg!))

        textFieldSend.text = ""
        
        mTableView.reloadData()
        
        //scroll to bottom
        let indexPath = NSIndexPath(forRow: chatData.count-1, inSection: 0)
        mTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        
        
        // 信鸽
        SendMessage(msg!, rid: "1")
        


        
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
            return 75
        }else if(messageItem.type == ChatType.SJHB || messageItem.type == ChatType.CDS){
            
            return 115
        }
        return 75
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let item = chatData[indexPath.row] as MessageItem
        
        var chatcell = "textcell"
        if(item.type == ChatType.CDS || item.type == ChatType.SJHB){
            chatcell = "hbcell"
        }
        
        var cell = tableView.dequeueReusableCellWithIdentifier(chatcell, forIndexPath: indexPath) as? ChatTableViewCell
        
        if(cell==nil){
            
            cell = ChatTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: chatcell)

        }
        cell!.adaptData(item)
        return cell!
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
