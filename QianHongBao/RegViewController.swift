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
    @IBOutlet weak var showView: UIView!
    @IBOutlet var bgView: UIView!
    
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
        
        let isTel = Common.isTelNumber(tel)

        if  !isTel {
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
        
        // 键盘通知
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegViewController.willShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegViewController.willHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        addFielldToArr()
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
    
    //MARK: 键盘处理
    var fieldArr: [UITextField] = []
    
    
    
    //把VC上的textField加到一个数组里面
    func addFielldToArr(){
        
        etName.tag = 0
        fieldArr.append(etName)
        tPhone.tag  = 1
        fieldArr.append(tPhone)
        tPwd.tag = 2
        fieldArr.append(tPwd)
        tPwd2.tag = 3
        fieldArr.append(tPwd2)
        
        
    }
    
    //获取当前键盘响应者的索引
    private func indexOfFirstResponse() ->(Int){
        
        for tf in fieldArr {
            if tf.isFirstResponder() {
               // print("tag======\(tf.tag)")
                return tf.tag
            }
        }
        //返回-1，没有当前响应者
        return -1
    }
    
    
    
    //键盘将要显示的通知处理
    func willShow(notify: NSNotification) ->(){
        
        
        //1.获取当前选中的UITextField在控制器View中的最大值
        //获取当前焦点的field
        let currentTF = self.fieldArr[self.indexOfFirstResponse()]
        
        //当前textField的最大Y值等于本身的最大Y值加上父控件view的y值
        let maxY = CGRectGetMaxY(currentTF.frame) + (currentTF.superview?.frame.origin.y)!
        
        print("+++++++++\(currentTF.superview)")
        //2.获取键盘的y值（弹出来后的y值)
        let kbEndFrm = notify.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
        let kbY = kbEndFrm?.origin.y
        
        //3.进行比较
        let delta = kbY! - maxY 
        if (delta < 0) {//需要往上移
            //添加动画
            UIView.animateWithDuration(0.25, animations: {
                self.showView.transform = CGAffineTransformMakeTranslation(0, delta)
            })
        }
        

    }
    //键盘将要消失的通知处理
    func willHide(notify: NSNotification) ->(){
        
        //恢复原状
        UIView.animateWithDuration(0) {
            self.showView.transform = CGAffineTransformIdentity
        }
    }
}
