//
//  AddrDetailViewController.swift
//  QianHongBao
//
//  Created by arkic on 16/3/1.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit

class AddrMGViewController: UIViewController {

    @IBOutlet weak var etName: UITextField!
    @IBOutlet weak var etPhone: UITextField!
    @IBOutlet weak var etAddr: UITextField!
    @IBOutlet weak var lTitle: UILabel!
    
    let ADDR_KEY = UD_ADDRESS
    var mUserDefault:NSUserDefaults!
    var index = -1
    var MData = ["":""]
    @IBAction func btnConfirm(sender: AnyObject) {
        var name = etName.text
        var phone = etPhone.text
        var addr = etAddr.text
        
        let whiteSpace = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        name = name!.stringByTrimmingCharactersInSet(whiteSpace)
        phone = phone!.stringByTrimmingCharactersInSet(whiteSpace)
        addr = addr!.stringByTrimmingCharactersInSet(whiteSpace)
        
        
        
        
        if(name=="" || phone=="" || addr==""){
            MyDialog.showErrorAlert(self, msg: "数据不能为空")
            return
        }
        let data:Dictionary<String,AnyObject> = ["name":name!,"phone":phone!,"addr":addr!]
        
        let tmp = mUserDefault.arrayForKey(ADDR_KEY)
        var addrs:[Dictionary<String,AnyObject>] = []
        if let tmpFlag=tmp{
            addrs = tmpFlag as! [Dictionary<String,AnyObject>]
        }
        if(index == -1){
            addrs.append(data)
        }else{
            addrs[index] = data
        }
        mUserDefault.setObject(addrs, forKey: ADDR_KEY)
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBAction func btnBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func btnBack2(sender: AnyObject) {
//        self.presentingViewController = self.presentingViewController!.presentingViewController!
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func btnDelete(sender: AnyObject) {
        if(index != -1){
            var addrs = mUserDefault.arrayForKey(ADDR_KEY)!
            addrs.removeAtIndex(index)
            mUserDefault.setObject(addrs, forKey: ADDR_KEY)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mUserDefault = NSUserDefaults.standardUserDefaults()
        if(index != -1){
            etName.text = MData["name"]
            etPhone.text = MData["phone"]
            etAddr.text = MData["addr"]
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
