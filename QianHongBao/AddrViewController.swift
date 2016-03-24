//
//  AddrViewController.swift
//  QianHongBao
//
//  Created by arkic on 16/3/1.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit

class AddrViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tbAddrs: UITableView!
    let TAG_NAME = 1
    let TAG_PHONE = 2
    let TAG_ADDR = 3
    
    var addrs:NSArray!
    var action = "manage"
    
    @IBAction func btnAdd(sender: AnyObject) {
        let vc = storyboard!.instantiateViewControllerWithIdentifier("addrDetailVC") as UIViewController
        presentViewController(vc, animated: true, completion: nil)
    }
    @IBAction func btnBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addrs=[]
    }
    override func viewWillAppear(animated: Bool) {
        let userDefault = NSUserDefaults.standardUserDefaults()
        let tAddrs = userDefault.arrayForKey(UD_ADDRESS)
        if let _ = tAddrs{
            addrs = tAddrs
        }

        self.tbAddrs.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return addrs.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let chatcell = "addrcell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(chatcell, forIndexPath: indexPath) as UITableViewCell
        
        let lName = cell.viewWithTag(TAG_NAME) as! UILabel
        let lPhone = cell.viewWithTag(TAG_PHONE) as! UILabel
        let lAddr = cell.viewWithTag(TAG_ADDR) as! UILabel
        
        var data = addrs[indexPath.row] as! Dictionary<String,String>
        lName.text = data["name"]
        lPhone.text = data["phone"]
        lAddr.text = data["addr"]
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var data = addrs[indexPath.row] as! Dictionary<String,String>
        if(action == "choose"){
            let vc = presentingViewController as! JieSuanViewController
            vc.sName = data["name"]!
            vc.sPhone = data["phone"]!
            vc.sAddr = data["addr"]!
            dismissViewControllerAnimated(true, completion: nil)
            return
        }
        let controller = storyboard!.instantiateViewControllerWithIdentifier("addrDetailVC") as! AddrMGViewController
        
        controller.index = indexPath.row
        controller.MData = data

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
