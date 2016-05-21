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
            MyDialog.showErrorAlert(self, msg: "不能为空",completion: nil)
        }
        
        if(pwd != pwd2){
            
            MyDialog.showErrorAlert(self, msg: "两次输入密码不一致",completion: nil)
            
        }
        
        let isTel = isTelNumber(tel)

        if  isTel {
            MyDialog.showErrorAlert(self, msg: "手机号格式错误",completion: nil)
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
                    MyDialog.showErrorAlert(self, msg: jobj["info"] as! String,completion:nil)
                    return
                }
                //success
                var user = jobj["data"] as! Dictionary<String,AnyObject>
                
                NSUserDefaults.standardUserDefaults().setInteger((user["uid"] as! NSNumber).integerValue, forKey: UD_UID)
                
                
                
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("loginVC") as! UITabBarController
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
    func isTelNumber(num:NSString)->Bool
    {
        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
        let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        let  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        let length = num.length
        
        
        if length <= 11 {
            if ((regextestmobile.evaluateWithObject(num) == true)
                || (regextestcm.evaluateWithObject(num)  == true)
                || (regextestct.evaluateWithObject(num) == true)
                || (regextestcu.evaluateWithObject(num) == true))
            {
                return true
            }
            else
            {
                return false
            }
        } else
        {
            return false
        }
   
    }
    

    


    @IBAction func tapAction(sender: AnyObject) {
        view.endEditing(true)
    }
    
}
