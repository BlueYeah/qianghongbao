//
//  FourViewController.swift
//  QianHongBao
//
//  Created by arkic on 16/1/10.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit

class FourViewController: UIViewController {

    @IBOutlet weak var vModifyData: UIView!
    @IBOutlet weak var vModifyPSW: UIView!
    @IBOutlet weak var vCharge: UIView!
    @IBOutlet weak var vOrder: UIView!
    @IBOutlet weak var vAddr: UIView!
    @IBOutlet weak var vLogout: UIView!
    
    
    @IBOutlet weak var lName: UILabel!    
    @IBOutlet weak var iHeadImg: UIImageView!
    @IBOutlet weak var lMoney: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        vOrder.userInteractionEnabled = true
        let mGes = UITapGestureRecognizer(target: self, action: #selector(FourViewController.actionOrder))
        vOrder.addGestureRecognizer(mGes)
        
        vAddr.userInteractionEnabled = true
        vAddr.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FourViewController.actionAddr)))
        
        vModifyPSW.userInteractionEnabled = true
        vModifyPSW.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FourViewController.actionModPwd)))
        
        vModifyData.userInteractionEnabled = true
        vModifyData.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FourViewController.actionModData)))
        
        vLogout.userInteractionEnabled = true
        vLogout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FourViewController.actionLogOut)))
        
        vCharge.userInteractionEnabled = true
        vCharge.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FourViewController.actionCharge)))
        
        lName.text = Common.getNickName()
        lMoney.text = "\(Common.getMoney())"
        iHeadImg.sd_setImageWithURL(NSURL(string: Common.getHeadImg()), placeholderImage: UIImage(named: IMG_LOADING))
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let uid = Common.getUid()
        let token = Common.getToken()
        
        
        let data:Dictionary<String,AnyObject> = ["uid":uid,"token":token]
        print("========uid\(uid)  token\(token)")
        MyHttp.doPost(URL_UserInfo, data: data) { (data, rep, error) in
            dispatch_sync(dispatch_get_main_queue(), {
                
                var jobj = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! Dictionary<String,AnyObject>
                
                //print("----------------\(jobj)")
                
                let status = (jobj["status"] as! NSNumber).integerValue
//                if(status==0){
//                    MyDialog.showErrorAlert(self, msg: jobj["info"] as! String)
//                    return
//                }
                // 实现token过期
                if (status==0)
                {
                    MyDialog.showErrorAlert(self, msg: jobj["info"] as! String)
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("loginVC") as UIViewController
                    self.presentViewController(controller, animated: true, completion: nil)
                    
                }
                
                //success
                
                
                let data:AnyObject = jobj["data"] as! NSDictionary
                
                print("====data\(data)")
                
                var user = data as! Dictionary<String,AnyObject>
                
                
                
                let uid = Int(user["uid"]! as! String)!
                
                
                Common.setHeadImg(user["photo"]! as! String)
                
                Common.setNickName(user["nackname"]! as! String)
                
                Common.setMoney(Double(user["integral"]! as! String)!)
                
                Common.setToken(user["token"] as! String)
                
                self.lName.text = Common.getNickName()
                self.lMoney.text = "\(Common.getMoney())"
                self.iHeadImg.sd_setImageWithURL(NSURL(string: Common.getHeadImg()), placeholderImage: UIImage(named: IMG_LOADING))
                NSUserDefaults.standardUserDefaults().setInteger(uid,forKey: UD_UID)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func actionOrder(){
        let vc = storyboard!.instantiateViewControllerWithIdentifier("orderVC") as UIViewController
        presentViewController(vc, animated: true, completion: nil)
    }
    func actionAddr(){
        let vc = storyboard!.instantiateViewControllerWithIdentifier("addrVC") as UIViewController
        presentViewController(vc, animated: true, completion: nil)
    }
    func actionModPwd(){
        let vc = storyboard!.instantiateViewControllerWithIdentifier("modPWDVC") as UIViewController
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func actionModData(){
        let vc = storyboard!.instantiateViewControllerWithIdentifier("modDataVC") as UIViewController
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func actionLogOut(){
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey(UD_UID)
        
        let vc = storyboard!.instantiateViewControllerWithIdentifier("loginVC") as UIViewController
        presentViewController(vc, animated: true, completion: nil)
    }
    func actionCharge(){
        let vc = storyboard!.instantiateViewControllerWithIdentifier("dataVC") as UIViewController
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func json2obj(json:String)->AnyObject{
        let obj: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(json.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!, options: NSJSONReadingOptions())
        return obj!
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
