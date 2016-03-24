//
//  ModPWDViewController.swift
//  QianHongBao
//
//  Created by arkic on 16/3/2.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit

class ModPWDViewController: UIViewController {
    
    @IBOutlet weak var tOldPwd: UITextField!
    @IBOutlet weak var tPwd: UITextField!
    
    @IBOutlet weak var tPwd2: UITextField!
    
    @IBAction func btnConfirm(sender: AnyObject) {
        let old = tOldPwd.text!
        let pwd = tPwd.text!
        let pwd2 = tPwd2.text!
        if(old=="" || pwd=="" || pwd2==""){
            
            MyDialog.showErrorAlert(self, msg: "不能为空")
            return
        }
        if(pwd != pwd2){
            MyDialog.showErrorAlert(self, msg: "两次输入密码不一致")
            return
        }

        let data:Dictionary<String,AnyObject> = ["uid":Common.getUid(),"oldPassword":old,"password":pwd]
        MyHttp.doPost(URL_UserModPwd, data: data) { (data, rep, error) in
            dispatch_sync(dispatch_get_main_queue(), {
                do{
                    var jobj = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! Dictionary<String,AnyObject>
                    let status = (jobj["status"] as! NSNumber).integerValue
                    if(status==0){
                        MyDialog.showErrorAlert(self, msg: jobj["info"] as! String)
                        return
                    }
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                }catch{
                    MyDialog.showErrorAlert(self, msg: "JOSN解释出错")
                    return
                }
            })
        }
    }
    
    @IBAction func btnBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func btnBack2(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}
