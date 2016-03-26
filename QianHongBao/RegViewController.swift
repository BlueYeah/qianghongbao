//
//  RegViewController.swift
//  QianHongBao
//
//  Created by arkic on 16/3/2.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit

class RegViewController: UIViewController {
    @IBOutlet weak var etName: UITextField!
    
    @IBOutlet weak var tPhone: UITextField!
    
    @IBOutlet weak var tPwd: UITextField!
    
    @IBOutlet weak var tPwd2: UITextField!
    
    @IBAction func btnConfirm(sender: AnyObject) {
        let pwd = tPwd.text!
        let pwd2 = tPwd2.text!
        let name = etName.text!
        let tel = tPhone.text!
        
        
        
        if(pwd=="" || pwd2=="" || name=="" || tel==""){
            MyDialog.showErrorAlert(self, msg: "不能为空")
        }
        
        if(pwd != pwd2){
            
            MyDialog.showErrorAlert(self, msg: "两次输入密码不一致")
            
        }
        
// 添加正在申请注册HUD
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.label.text = "正在申请注册...."
        
        let data:Dictionary<String,AnyObject> = ["nackname":name,"username":tel,"password":pwd]
        MyHttp.doPost(URL_UserRegister, data: data) { (data, rep, error) in
            if (error != nil)
            {
                dispatch_async(dispatch_get_main_queue(), {
                    hud.hideAnimated(true)
                    let hud1 = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud1.label.text = "网络异常"
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
                    MyDialog.showErrorAlert(self, msg: jobj["info"] as! String)
                    return
                }
                //success
                var user = jobj["data"] as! Dictionary<String,AnyObject>
                
                NSUserDefaults.standardUserDefaults().setInteger((user["uid"] as! NSNumber).integerValue, forKey: UD_UID)
                
                
                
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("mTabBarVC") as! UITabBarController
                self.presentViewController(vc, animated: true, completion: nil)
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
