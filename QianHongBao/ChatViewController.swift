//
//  ChatViewController.swift
//  QianHongBao
//
//  Created by arkic on 16/1/10.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit

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
            MessageItem(uid: 1,type: ChatType.Text,name:"System",headImg: "qrcode",content: "Fuck your!"),
            MessageItem(uid: 0,type: ChatType.Text,name:"System",headImg: "qrcode",content: "F"),
            MessageItem(uid: 1,type: ChatType.Text,name:"System",headImg: "qrcode",content: "说中文？"),
            MessageItem(uid: 0,type: ChatType.Text,name:"System",headImg: "qrcode",content: "Hello I'm your father!jdkjdslfkfsdfsdfsdfsdfsdfsdfdsdfsdfsjdkjdslfkfsdfsdfsdfsdfsdfsdfdsdfsdfsjdkjdslfkfsdfsdfsdfsdfsdfsdfdsdfsdfsjdkjdslfkfsdfsdfsdfsdfsdfsdfdsdfsdfs"),
            MessageItem(uid: 1,type: ChatType.Text,name:"System",headImg: "qrcode",content: "说中文？"),
            MessageItem(uid: 1,type: ChatType.Text,name:"System",headImg: "qrcode",content: "heheheheheheeh"),
            MessageItem(uid: 1,type: ChatType.Text,name:"System",headImg: "qrcode",content: "fuck fuck fuck fuck fuck"),
            MessageItem(uid: 1,type: ChatType.SJHB,name:"System",headImg: "qrcode",content: "1000"),
            MessageItem(uid: 1,type: ChatType.CDS,name:"System",headImg: "qrcode",content: "300")
        ]
    
//        self.mMJRefreshHeader = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "pullRefresh")
        
        self.chatTableView.registerClass(ChatTableViewCell.self, forCellReuseIdentifier: "textcell")
        
        self.chatTableView.registerClass(ChatTableViewCell.self, forCellReuseIdentifier: "hbcell")
        
//        mTableView.addSubview(mMJRefreshHeader)
        // Do any additional setup after loading the view.
    }
    
    func pullRefresh(){
        self.mMJRefreshHeader.endRefreshing()
        print("refresh...")
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
        chatData.append(MessageItem(uid:0,type:ChatType.Text,name:"System",headImg:"qrcode",content:msg!))
        textFieldSend.text = ""
        
        mTableView.reloadData()
        
        //scroll to bottom
        let indexPath = NSIndexPath(forRow: chatData.count-1, inSection: 0)
        mTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
