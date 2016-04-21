//
//  LoginViewController.swift
//  QianHongBao
//
//  Created by arkic on 16/3/2.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var tPhone: UITextField!
    @IBOutlet weak var tPassword: UITextField!
    
    var canLogin = true
    
    @IBAction func btnRegister(sender: AnyObject) {
        let vc = storyboard!.instantiateViewControllerWithIdentifier("regVC") as UIViewController
        presentViewController(vc, animated: true, completion: nil)
    }
    @IBAction func btnLogin(sender: AnyObject) {
        if(!canLogin){
            return
        }
        if(tPassword.text=="" || tPhone.text==""){
            MyDialog.showErrorAlert(self, msg: "输入不能为空")
            return
        }
//--------添加HUD

        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.label.text = "正在登陆...."
        
        
        
        
//--------

        
        let data:Dictionary<String,AnyObject> = ["username":tPhone.text!,"password":tPassword.text!]
        MyHttp.doPost(URL_UserLogin, data: data) { (data, rep, error)  in
            
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
            dispatch_async(dispatch_get_main_queue(),{
                // 隐藏HUD
                hud.hideAnimated(true)
                    let tmp = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                
                    print("====\(tmp)")
                    var jobj = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? Dictionary<String,AnyObject>
                    let status = (jobj!["status"] as! NSNumber).integerValue
                    if(status==0){
                        MyDialog.showErrorAlert(self, msg: jobj!["info"] as! String)
                        return
                    }
                    //success
                
                    print("-------\(jobj)")
                

                    
                
                    print("======\(jobj!["data"])")
                
                    var data = jobj!["data"] as? Dictionary<String,AnyObject>
                
                if data == nil
                {
                // 假如data是string 再一次json解析成字典
               
                    let tmp_str = jobj!["data"] as! String

                    let data1 = try! NSJSONSerialization.JSONObjectWithData(tmp_str.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.AllowFragments) as? Dictionary<String,AnyObject>

                    print("+++++\(data1)")
                    
                    
                    //print("---------------------token\(data!["token"])")
                    
                    let uid = Int(data1!["uid"]! as! String)!
                    let token = Int(data1!["token"]! as! String)
                    
                    Common.setHeadImg(data1!["photo"]! as! String)
                    
                    Common.setNickName(data1!["nackname"]! as! String)
                    
                    Common.setMoney(Double(data1!["integral"]! as! String)!)
                    
                    NSUserDefaults.standardUserDefaults().setInteger(uid,forKey: UD_UID)
                    
                    Common.setToken(data1!["token"] as! String)
                }
                   // var user = data!["user"] as? Dictionary<String,String>
                
                
//                    print("---------------------token\(data!["token"])")
//                
//                    let uid = Int(data!["uid"]! as! String)!
//                    
//                    
//                    Common.setHeadImg(data!["photo"]! as! String)
//                    
//                    Common.setNickName(data!["nackname"]! as! String)
//                    
//                    Common.setMoney(Double(data!["integral"]! as! String)!)
//                
//                
//                    
//                    NSUserDefaults.standardUserDefaults().setInteger(uid,forKey: UD_UID)
              
                
                
                
                
                
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("mTabBarVC") as! UITabBarController
                self.presentViewController(vc, animated: true, completion: nil)
            })
            
        }
        
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

    @IBAction func tapAction(sender: AnyObject) {
        
        view.endEditing(true)
    }
}
