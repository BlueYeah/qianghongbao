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
    @IBOutlet weak var bgView: UIView!
    
    //chat data
    var chatData:Array<MessageItem>!
    
    var mMJRefreshHeader:MJRefreshNormalHeader!
    let mgr = AFHTTPSessionManager()
    let nowRid = Common.getNowRid()
    
    @IBOutlet weak var mTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

       
        //init data
        self.chatData = []

        changeVcName(nowRid)

        MySQL.loadMessage(0, max_id: 0, rid: nowRid,uid: nil) { (array) in
            self.chatData = array
        }

        
        self.chatTableView.registerClass(ChatTableViewCell.self, forCellReuseIdentifier: "textcell")
        
        self.chatTableView.registerClass(ChatTableViewCell.self, forCellReuseIdentifier: "hbcell")
        
        //scroll to bottom
        if chatData.count > 5 {
            
            let indexPath = NSIndexPath(forRow: chatData.count-1, inSection: 0)
            mTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
       
        
        
        // 接收聊天消息通知
        // 监听通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.ReceiveMessage(_:)), name: "NewMessage", object: nil)
        // 接收更改用户info通知
        // 监听通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.reloadInfo), name: "newUserInfo", object: nil)
        
        // 键盘通知

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.willShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.willHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        addFielldToArr()
        
         MySQL.updateMsgStatus(nowRid)
    }
    func reloadInfo() {
        MySQL.loadMessage(0, max_id: 0, rid: nowRid,uid: nil) { (array) in
            self.chatData = array
        }
        self.mTableView.reloadData()
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

        // 获取推送消息
        let apsDictionary = notification.userInfo!["aps"] as? NSDictionary
        
        let apsDict = apsDictionary

            let alert:NSDictionary
        
            let json = apsDict
            
            if  json == nil {
                
                alert = Common.json2obj( String (apsDict)) as! NSDictionary
            }
            else {
            
            
              alert = apsDict!
            }
            
            print("==========接受到消息啊！！！\(alert)")
   
            
            //apsDict["alert"]
            let content = Common.substring(":", content: apsDict!["alert"] as! String)
        
            let msg = content
        

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
                chatData.append(MessageItem(uid:1,type:ChatType.Text,name:nickName as String,headImg:photo ,content:msg ,bonusId:nil,dsBonus: nil ,date: date))
              
            }else if type == 2
            {

                // 判断红包是我发的
                let bonus_id = Int(alert["id"] as! NSNumber)
                
                var Userid:Int = 1
                
                if uid == myuid {
                    Userid = 0
                }
                    chatData.append(MessageItem(uid:Userid,type:ChatType.SJHB,name:nickName as String,headImg:photo ,content:msg ,bonusId:bonus_id,dsBonus: nil,date: date))
   
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
                
                chatData.append(MessageItem(uid:1,type:ChatType.CDS,name:nickName as String,headImg:photo ,content:msg ,bonusId:bonus_id,dsBonus: dsBonus,date: date))
            }else if type == 4
            {
                chatData.append(MessageItem(uid:1,type:ChatType.Text,name:nickName as String,headImg:photo ,content:msg ,bonusId:nil,dsBonus: nil,date: date))
                
            }
            else if type == 5
            {
                let message:String
                if msg == "1"
                {
                    message = "本期单双开奖结果：单"
                }else {message = "本期单双开奖结果：双"}
                
                chatData.append(MessageItem(uid:1,type:ChatType.Text,name:nickName as String,headImg:photo ,content:message ,bonusId:nil,dsBonus: nil,date: date))
                
            }

            mTableView.reloadData()
        

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
        
        
        let appDict:NSDictionary = ["id":0,"uid":uid, "alert":message, "rid":rid ,"date":dateString ,"photo":photo ,"nackname":nickName ,"type":1,"status":1,"bonus_total":0,"dsTime":0]
        
        //设置message
        
        let message = MyXG.message(appDict)
        
        
        let param = MyXG.sendMessage(access_id as String, type: type, message: message, enviroment: "1", messageType: "0")
        
        let mgr = AFHTTPSessionManager()
        
        let url = "\(XGurl)\(type)"
        
        print("ios信息字典\(param)")
        
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
        // 删除当前房间号
        Common.setNowRid(0)
        // 删除标签
        let tag = String( nowRid)
        
        XGPush.delTag(tag)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    //send message
    @IBAction func btnSend(sender: AnyObject) {
        
        
        var msg = textFieldSend.text
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
        SendAdMessage(msg!, rid: rid)
        // 发送ios 信息前要加名字
        msg = "\(nickName):" + msg!
        SendMessage(msg!, rid: rid)
        


        
 

        
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
        
        print("===================>",chatData[indexPath.row].name)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        let item = chatData[indexPath.row] as MessageItem
        let lastmsg:String
        let lastitem:MessageItem
        // 存储上条信息时间
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
    
    
    
    //MARK: 键盘处理
    var fieldArr: [UITextField] = []
    
    
    
    //把VC上的textField加到一个数组里面
    func addFielldToArr(){
        
        textFieldSend.tag  = 0
        fieldArr.append(textFieldSend)

    }
    
    //获取当前键盘响应者的索引
    private func indexOfFirstResponse() ->(Int){
        
        for tf in fieldArr {
            if tf.isFirstResponder() {
                return tf.tag
            }
        }
        //返回-1，没有当前响应者
        return -1
    }
    
    
    
    //键盘将要显示的通知处理
    func willShow(notify: NSNotification) ->(){
        
        
        //1.获取当前选中的UITextField在控制器View中的最大值
        //获取当前焦点的field
        let currentTF = self.fieldArr[self.indexOfFirstResponse()]
        
        //当前textField的最大Y值等于本身的最大Y值加上父控件view的y值
        let maxY = CGRectGetMaxY(currentTF.frame) + (currentTF.superview?.frame.origin.y)!
        
        //2.获取键盘的y值（弹出来后的y值)
        let kbEndFrm = notify.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
        let kbY = kbEndFrm?.origin.y
        
        //3.进行比较
        let delta = kbY! - maxY - 65
        if (delta < 0) {//需要往上移
            //添加动画
            UIView.animateWithDuration(0.25, animations: {
                self.bgView.transform = CGAffineTransformMakeTranslation(0, delta)
            })
        }
        
        //scroll to bottom
        if chatData.count > 5 {
            
            let indexPath = NSIndexPath(forRow: chatData.count-1, inSection: 0)
            mTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        
        }
        
        
        
    }
    
    
    //键盘将要消失的通知处理
    func willHide(notify: NSNotification) ->(){
        
        //恢复原状
        UIView.animateWithDuration(0) {
            self.bgView.transform = CGAffineTransformIdentity
        }
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
