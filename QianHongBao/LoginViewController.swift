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
        let body = "username=\(tPhone.text!)&password=\(tPassword.text!)"
        let req = NSMutableURLRequest(URL: NSURL(string: URL_UserLogin)!)
        req.HTTPMethod = "POST"
        req.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        canLogin = false
        

        NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue()) { (rep, data, error) -> Void in
            self.canLogin = true
            
           
            
            do{
                
                var jobj = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! Dictionary<String,AnyObject>
                
                let status = (jobj["status"] as! NSNumber).integerValue
                if(status==0){
                    MyDialog.showErrorAlert(self, msg: jobj["info"] as! String)
                    return
                }
                //success
                
                var data = jobj["data"] as! Dictionary<String,AnyObject>
                
                var user = data["user"] as! Dictionary<String,String>
                
                
                let uid = Int(user["uid"]!)!
                
               
                Common.setHeadImg(user["photo"]! as String)
                
                Common.setNickName(user["nackname"]! as String)
                
                Common.setMoney(Double(user["integral"]!)!)
                
                NSUserDefaults.standardUserDefaults().setInteger(uid,forKey: UD_UID)
                
            }catch{
                
            }
           
            
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("mTabBarVC") as! UITabBarController
            self.presentViewController(vc, animated: true, completion: nil)
            
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

}
