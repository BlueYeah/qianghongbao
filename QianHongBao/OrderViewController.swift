//
//  OrderViewController.swift
//  QianHongBao
//
//  Created by arkic on 16/2/29.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let TAG_IMG = 1
    let TAG_MONEY = 2
    let TAG_TIME = 6
    let TAG_STATUS = 5
    
    var getCurPageOrderUrl:String = URL_Order
    @IBOutlet weak var tvOrders: UITableView!
    var mMJRefreshFooter:MJRefreshAutoNormalFooter!
    var Orders:[Order] = []
    @IBAction func btnBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        mMJRefreshFooter = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(OrderViewController.endLoad))
//        mMJRefreshFooter.setTitle("no more", forState: MJRefreshState.NoMoreData)
//        mMJRefreshFooter.setTitle("refreshing", forState: MJRefreshState.Refreshing)
//        mMJRefreshFooter.setTitle("pulling", forState: MJRefreshState.Pulling)
//        mMJRefreshFooter.setTitle("willRefresh", forState: MJRefreshState.WillRefresh)
//        mMJRefreshFooter.setTitle("Idle", forState: MJRefreshState.Idle)
        tvOrders.addSubview(mMJRefreshFooter)
        
        // Do any additional setup after loading the view.
        mMJRefreshFooter.beginRefreshing()
    }
    func addOrders(){
        let sUrl = getCurPageOrderUrl

        let data:Dictionary<String,AnyObject> = ["uid":Common.getUid()]
        MyHttp.doPost(sUrl, data: data) { (data, rep, error) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                let res = NSString(data: data!, encoding: NSUTF8StringEncoding)
                
                
                let res_jsonobj: AnyObject = self.json2obj(res as! String)
                
                let page_jsonobj: AnyObject = res_jsonobj.objectForKey("page")!
                
                
                let jOrders = res_jsonobj.objectForKey("orders") as! NSArray
                
                
                let page = Page(obj: page_jsonobj)
                
                
                
                for jOrder in jOrders{
                    let order = Order(obj: jOrder)
                    self.Orders.append(order)
                }
                
                self.tvOrders.reloadData()
                
                if(page.hasNext){
                    self.getCurPageOrderUrl = URL_Order + "/page/\(page.cur+1)"
                    self.mMJRefreshFooter.endRefreshing()
                }else{
                    self.mMJRefreshFooter.endRefreshingWithNoMoreData()
                }
            })
            
        }
    }
    func json2obj(json:String)->AnyObject{
        let obj: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(json.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!, options: NSJSONReadingOptions())
        return obj!
    }
    func endLoad(){
        addOrders()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Orders.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let order = Orders[indexPath.row]

        
        let chatcell = "ordercell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(chatcell, forIndexPath: indexPath) as UITableViewCell
        
        _ = cell.viewWithTag(TAG_IMG) as! UIImageView
        
        let lStatus = cell.viewWithTag(TAG_STATUS) as! UILabel
        
        lStatus.text = order.state
        
        let lTime = cell.viewWithTag(TAG_TIME) as! UILabel
        
        lTime.text = order.time
        
        let money = cell.viewWithTag(TAG_MONEY) as! UILabel
        
        money.text = "￥\(order.sum)"
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("orderDetailVC") as! OrderDetailViewController
        controller.order = self.Orders[indexPath.row]
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
