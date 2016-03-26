//
//  OrderDetailViewController.swift
//  QianHongBao
//
//  Created by arkic on 16/2/29.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var mTableView: UITableView!
    
    let TAG_NAME = 1
    let TAG_NUM = 2
    let TAG_PRICE = 3
    
    var order:Order!
    
    @IBAction func btnBack(sender: AnyObject) {

        // 直接设置rootview 因为不是navigation。
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("First") as! FirstViewController

        UIApplication.sharedApplication().keyWindow?.rootViewController = vc
        
       // 发送通知提醒B界面销毁
        dismissViewControllerAnimated(true) {

            NSNotificationCenter.defaultCenter().postNotificationName("CLOSE_B", object: nil, userInfo: nil)
            
            

            
        }


    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.label.text = "正在获取订单..."
        hud.hideAnimated(true, afterDelay: 1)
        
        // Do any additional setup after loading the view.
        
        let fv = UIView()
        
        fv.frame.size.width = mTableView.frame.width
        
        fv.frame.size.height = 230
        
        addFooterViewLabel(fv)
        
        mTableView.tableFooterView = fv
        
        
        
    }
    
    
    func addFooterViewLabel(fv:UIView){
        var y:CGFloat = 10
        let labelHeight:CGFloat = 20.0
        let labelMGLeft:CGFloat = 20
        let labelLeftWidth:CGFloat = 100
        let dataLeft = ["总数合计","订单状态","订单号码","下单时间","收货姓名","手机号码","收货地址"]
        let dataRight = ["￥\(order.sum)",order.state,order.orderid,order.time,order.name,order.tel,order.addr]
        for i in 0...6{
            
            let labelLeft = UILabel(frame: CGRectMake(labelMGLeft, y, labelLeftWidth,labelHeight))
            labelLeft.font = UIFont.systemFontOfSize(12)
            labelLeft.text = dataLeft[i]
            labelLeft.sizeToFit()
            fv.addSubview(labelLeft)
        
            let labelRight = UILabel(frame: CGRectMake(labelLeftWidth + 20, y, 200,labelHeight))
            labelRight.font = UIFont.systemFontOfSize(12)
            labelRight.text = dataRight[i]
            if(i==5){
                labelRight.lineBreakMode = NSLineBreakMode.ByWordWrapping
                labelRight.numberOfLines = 0
                //font
                let font = UIFont.boldSystemFontOfSize(CGFloat(14))
                //measure width and height
                var attr = Dictionary<String,AnyObject>()
                attr[NSFontAttributeName] = font
                let contentSize = NSString(string: labelRight.text!).boundingRectWithSize(CGSize(width: 200,height: 1000), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attr, context: nil)
                
                labelRight.frame.size = contentSize.size
            }else{
                labelRight.sizeToFit()
            }
            fv.addSubview(labelRight)
            
            y += labelHeight + 10
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
        return order.pros.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let chatcell = "goodscell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(chatcell, forIndexPath: indexPath) as UITableViewCell

        
        let lName = cell.viewWithTag(TAG_NAME) as! UILabel
        let lNum = cell.viewWithTag(TAG_NUM) as! UILabel
        let lPrice = cell.viewWithTag(TAG_PRICE) as! UILabel
        
        let pro = order.pros[indexPath.row]
        
        lName.text = pro.title
        
        lNum.text = "x\(order.nums[indexPath.row])"
        
        lPrice.text = "￥\(pro.price)"
        
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
