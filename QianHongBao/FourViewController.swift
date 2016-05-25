//
//  FourViewController.swift
//  QianHongBao
//
//  Created by arkic on 16/1/10.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit
import AFNetworking
class FourViewController: UIViewController {

    @IBOutlet weak var vModifyData: UIView!
    @IBOutlet weak var vModifyPSW: UIView!
    @IBOutlet weak var vCharge: UIView!
    @IBOutlet weak var vOrder: UIView!
    @IBOutlet weak var vAddr: UIView!
    @IBOutlet weak var vLogout: UIView!
    
    
    @IBOutlet weak var lName: UILabel!    
    @IBOutlet weak var iHeadImg: UIButton!
    @IBOutlet weak var lMoney: UILabel!
    
    var canlogin:Bool = true
    
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
        
        //iHeadImg.imageView?.image = Common.getImageFromSandBox("/iconImage.png")
        //iHeadImg.imageView!.sd_setImageWithURL(NSURL(string: Common.getHeadImg()), placeholderImage: UIImage(named: IMG_LOADING))


    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        let iconimage = Common.getImageFromSandBox()
        print("icon\(iconimage)")
        iHeadImg.setBackgroundImage(iconimage, forState: UIControlState.Normal)
        
        let uid = Common.getUid()
        let token = Common.getToken()

        //let data:Dictionary<String,AnyObject> = ["uid":uid,"token":token]
        let data:Dictionary<String,AnyObject> = ["uid":uid,"token":token]
        
        let mgr = AFHTTPSessionManager()

        mgr.POST(URL_UserInfo, parameters: data, progress: nil, success: { (task, resp) in
            print("reps============\(resp)=======resp\(resp!["status"])=====info\(resp!["info"])")
            
            var status = (resp!["status"] as! NSNumber).integerValue
            
            // 实现token过期
            
            if(status != 1 ){
                
                MyDialog.showmyErrorAlert(self, msg: resp!["info"] as! String, completion: {
                    
                    var vc = UIApplication.sharedApplication().keyWindow?.rootViewController
                    
                    while(vc?.presentedViewController != nil){
                        
                        vc = vc?.presentedViewController
                        
                    }

                    let controller = vc!.storyboard!.instantiateViewControllerWithIdentifier("loginVC") as UIViewController
                    
                    vc!.presentViewController(controller, animated: true, completion: nil)
                    
                })
                
                return
            }
            
            let data:AnyObject = resp!["data"] as! NSDictionary

            var user = data as! Dictionary<String,AnyObject>

            let uid = Int(user["uid"]! as! String)!

            Common.setHeadImg(user["photo"]! as! String)

            Common.setNickName(user["nackname"]! as! String)

            Common.setMoney(Double(user["integral"]! as! String)!)

            self.lName.text = Common.getNickName()
            
            self.lMoney.text = "\(Common.getMoney())"
            
            self.iHeadImg.imageView!.sd_setImageWithURL(NSURL(string: Common.getHeadImg()), placeholderImage: UIImage(named: IMG_LOADING))
            
            NSUserDefaults.standardUserDefaults().setInteger(uid,forKey: UD_UID)
            
            let dict = ["nackname":user["nackname"]! as! String,"photo":user["photo"]! as! String,"uid":uid]
            
            MySQL.updateMessage(dict as! [String : AnyObject])
            
            }) { (task, error) in
                let hud1 = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                
                hud1.label.text = "网络异常"
                
                hud1.hideAnimated(true, afterDelay: 1)
                
                return
        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toIconVC(sender: AnyObject) {
        let vc = storyboard!.instantiateViewControllerWithIdentifier("IconVC") as UIViewController
        presentViewController(vc, animated: true, completion: nil)
        
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
