//
//  JieSuanViewController.swift
//  QianHongBao
//
//  Created by arkic on 16/3/5.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit

class JieSuanViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var lName: UILabel!
    @IBOutlet weak var lPhone: UILabel!
    @IBOutlet weak var lAddr: UILabel!
    @IBOutlet weak var vAddr: UIView!
    @IBOutlet weak var tvPro: UITableView!
    
    let TAG_NAME = 1
    let TAG_NUM = 2
    let TAG_PRICE = 3
    
    var tfMsg:UITextView!
    var sName = ""
    var sPhone = ""
    var sAddr = ""
    var gwcs:[NSDictionary] = []
    

    @IBAction func btnBack2(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func btnJieSuang(sender: AnyObject) {

        if(sPhone==""){
             MyDialog.showErrorAlert(self, msg: "地址不能为空",completion: nil)
            return
  
        }
        let extra = tfMsg.text
        let addr = sName + ";" + sPhone + ";" + sAddr
        let dict:Dictionary<String,NSObject> = ["extra":extra,"addr":addr,"product":gwcs,"uid":Common.getUid()]
        let jsondata = try! NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted)
        
        let order = NSString(data: jsondata, encoding: NSUTF8StringEncoding)!

        let sUrl = URL_AddOrder
        let data:Dictionary<String,AnyObject> = ["order":order]
      //添加HUD
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.label.text = "正在提交订单...."

        
        //MyDialog.showLoadingAlert(self)
        MyHttp.doPost(sUrl, data: data) { (data, rep, error) in
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), {
                    hud.hideAnimated(true)
                    let hud1 = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud1.label.text = "提交失败"
                    hud1.hideAnimated(true, afterDelay: 1)
                    print("cuowu",error)
                    
                    
                })
                
                return
                
            }
            
            dispatch_async(dispatch_get_main_queue(), { 
                // 隐藏HUD
                hud.hideAnimated(true)
                
                var jobj = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! Dictionary<String,AnyObject>
                let status = (jobj["status"] as! NSNumber).integerValue
                if(status==0){
                    
                    MyDialog.showErrorAlert(self, msg: jobj["info"] as! String,completion: nil)
                    return
                }
                //success


                let order = Order(obj: jobj["data"]!)
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("orderDetailVC") as! OrderDetailViewController
                vc.order = order
                self.presentViewController(vc, animated: true, completion: nil)


                
            })
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let mUserDefault = NSUserDefaults.standardUserDefaults()
        
        var gwcs_dict:Dictionary<String,NSDictionary> = Dictionary<String,NSDictionary>()
        if let tmp = mUserDefault.dictionaryForKey(UD_GWCS){
            gwcs_dict = tmp as! Dictionary<String,NSDictionary>
        }
        for (_,v) in gwcs_dict{
            
            gwcs.append(v)
        }
        
        //footer view
        
        let view = UIView()
        view.frame.size.width = tvPro.frame.width
        view.frame.size.height = 200
        
        let font = UIFont.boldSystemFontOfSize(14)
        let lSum1 = UILabel(frame: CGRectMake(20, 20, 100, 20))
        lSum1.font = font
        lSum1.text = "合计"
        view.addSubview(lSum1)
        
        let lSum2 = UILabel(frame: CGRectMake(120, 20, 50, 20))
        lSum2.font = font
        var heji = 0.0
        for item in gwcs{
            var gwc = item as! Dictionary<String,NSObject>
            let price = (gwc["price"] as! NSNumber).doubleValue
            let num = (gwc["num"] as!
                NSNumber).doubleValue
            heji = heji +  num * price
        }
        lSum2.text = "￥\(heji)"
        lSum2.adjustsFontSizeToFitWidth = true
        view.addSubview(lSum2)
        
        let lMsg = UILabel(frame: CGRectMake(20, 50, 50, 20))
        lMsg.font = font
        lMsg.text = "留言"
        view.addSubview(lMsg)
        
        tvPro.layoutIfNeeded()
        
        tfMsg = UITextView(frame: CGRectMake(20, 80, tvPro.frame.width - 40, 110))
        tfMsg.layer.borderWidth = 1
        tfMsg.layer.borderColor = UIColor.blackColor().CGColor
        tfMsg.layer.cornerRadius = 8
        tfMsg.font = font
        view.addSubview(tfMsg)
        
        self.tvPro.tableFooterView = view
        
        vAddr.userInteractionEnabled = true
        vAddr.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(JieSuanViewController.actionChangeAddress(_:))))
        
        let addrs: NSArray? = NSUserDefaults.standardUserDefaults().objectForKey("addr") as? NSArray
        
        print("=============jiesuan数组\(addrs! as NSArray)")
        if let _ = addrs{
            
            //var addr = addrs![0] as! Dictionary<String,String>
            var addr = addrs![0] as! Dictionary<String,String>
            sName = addr["name"]!
            sPhone = addr["phone"]!
            sAddr = addr["addr"]!
        }else{
            sName = "请选择收货地址"
        }
        
        // 监听通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(JieSuanViewController.btnBack2), name: "CLOSE_B", object: nil)
        
    }
    
    func close () {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func actionChangeAddress(sender:AnyObject){
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("addrVC") as! AddrViewController
        vc.action = "choose"
        presentViewController(vc, animated: true, completion: nil)
        
    }
    override func viewWillAppear(animated: Bool) {
        lName.text = sName
        lPhone.text = sPhone
        lAddr.text = sAddr
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gwcs.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let chatcell = "productcell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(chatcell, forIndexPath: indexPath) as UITableViewCell
        
        let lName = cell.viewWithTag(TAG_NAME) as! UILabel
        
        let lNum = cell.viewWithTag(TAG_NUM) as! UILabel
        
        let lPrice = cell.viewWithTag(TAG_PRICE) as! UILabel
        
        var gwc = gwcs[indexPath.row] as! Dictionary<String,AnyObject>

        lName.text = gwc["title"] as? String
        

        lNum.text = "x" + (gwc["num"] as! NSNumber).stringValue

        lPrice.text = "￥" + (gwc["price"] as! NSNumber).stringValue
        
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

    @IBAction func tapAction(sender: AnyObject) {
        view.endEditing(true)
    }
}
