//
//  CDSViewController.swift
//  QianHongBao
//
//  Created by arkic on 16/3/4.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit
import AFNetworking

enum CDS_CHOICE{
    case Choose
    case Chose
    case Result
}
class CDSViewController: UIViewController {
    @IBOutlet weak var guessMember: UILabel!
    @IBOutlet weak var lTime: UILabel!
    @IBOutlet weak var lMoney: UILabel!
    @IBOutlet weak var lMkTime: UILabel!
    @IBOutlet weak var lMyChoice: UILabel!
    @IBOutlet weak var lResult: UILabel!
    @IBOutlet weak var lResult2: UILabel!
    @IBOutlet weak var btnD: UIButton!
    @IBOutlet weak var btnS: UIButton!
    
    
    var RESULT_TYPE = CDS_CHOICE.Choose
    var timer:NSTimer!
    var restSeconds:Int?
    var result:Int?
    
    let uid = Common.getUid()
    let rid = Common.getNowRid()
    //        let bonusId = Common.getBonusId()
    let token = Common.getToken()
    let dsId = Common.getDSBonusId()
    let mgr = AFHTTPSessionManager()
    
    @IBAction func btnDan(sender: AnyObject) {
//        let vc = storyboard!.instantiateViewControllerWithIdentifier("CDSVC") as UIViewController
//        presentViewController(vc, animated: true, completion: nil)
//        dismissViewControllerAnimated(false, completion: nil)
        
        print("d clilck")

        // 改变模式
        self.RESULT_TYPE = CDS_CHOICE.Chose
        changeResultType()
       // 提交单双结果
        guessDS(1)
        // 获取我的竞猜
        getMyGuess()
        
    }
    @IBAction func btnShuang(sender: AnyObject) {
        print("s clilck")
        // 改变模式
        self.RESULT_TYPE = CDS_CHOICE.Chose
        changeResultType()
        // 提交单双结果
        guessDS(2)
        // 获取我的竞猜
        getMyGuess()
    }
    @IBAction func btnBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()


        
        
        // 设置页面状态
        changeResultType()
        
        guessResult()
        // Do any additional setup after loading the view.
        // 设置倒数时间
        setTime()
        // 设置页面内容
        setContent()
        

        

        
        
    }
    
    func setTime() {
        // 默认的时间
        let dsTime = Int(Common.getDSBonusTime()*60)
        // 红包对应date字符串
        let dsDateString = Common.getDSBonusDate()
        //获取当前时间字符串
        let date:NSDate = NSDate()
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.stringFromDate(date)
        let dsDate = formatter.dateFromString(dsDateString)
        let nowDate = formatter.dateFromString(dateString)
        
        let seconds = Int( (nowDate?.timeIntervalSinceDate(dsDate!))!)
        
        print("dsDate===\(dsDate)=======nowDate\(nowDate)===============时间秒差\(seconds)")
        
        
        let resSeconds:Int?
        if seconds < dsTime{
             resSeconds = dsTime - seconds
            
        }else { resSeconds = 0}
        
        
        restSeconds = resSeconds
        lTime.text = getTimeStr(self.restSeconds!)
        
        if(self.restSeconds>0){
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(CDSViewController.countTime(_:)), userInfo: nil, repeats: true)
            
            NSRunLoop.currentRunLoop().addTimer(self.timer, forMode: NSRunLoopCommonModes)
        }
    }
    

    func countTime(sender:AnyObject){
        if(self.restSeconds<0){
            print("restsecond\(restSeconds)")
            self.timer.invalidate()
            guessResult()
            return
            
        }
        lTime.text = getTimeStr(self.restSeconds!)
        self.restSeconds = self.restSeconds! - 1
        
    }
    func getTimeStr(time:Int)->String{
        let m = time/60
        let s = time%60
        return String(m) + ":" + String(s)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeResultType() {
        if(RESULT_TYPE==CDS_CHOICE.Choose){
            lMyChoice.hidden = true
            lResult.hidden = true
            lResult2.hidden = true
            
            
        }else if(RESULT_TYPE==CDS_CHOICE.Chose){
            lMyChoice.hidden = false
            btnD.hidden = true
            btnS.hidden = true
            
        }else if(RESULT_TYPE==CDS_CHOICE.Result){
            btnD.hidden = true
            btnS.hidden = true
            
        }
    }
    
    func guessDS(result:Int) {

        let param:NSDictionary = ["uid":uid,"token":token,"dsId":dsId,"rid":rid,"result":result]
        
        mgr.POST(URL_guessDS, parameters: param, progress: nil, success: { (task, responObj) in
//            print("=======服务端API接入成功")
//            
            print("==========发送我的guess的respon=\(responObj)=========data\(responObj!["info"])")
            }) { (task, error) in
                 print("========服务端API接入失败")
        }
        
        
    }
    
    func guessResult() {
        let param:NSDictionary = ["uid":uid,"token":token,"dsId":dsId,"rid":rid]
        
        mgr.POST(URL_getDSResult, parameters: param, progress: nil, success: { (task, responObj) in
//            print("=======服务端API接入成功，倒数完毕=====")
//            
            print("==========respon=\(responObj)=========data\(responObj!["data"])")
            
            let data = responObj!["data"] as? NSDictionary
            if (data == 0)
            {
                return
            }

            
            let result = data!["result"] as? String

            if (result == "1")
            {
                self.RESULT_TYPE = CDS_CHOICE.Result
                self.lResult2.text = "单"
                self.changeResultType()
                
            }else if (result == "2")
            {
                self.RESULT_TYPE = CDS_CHOICE.Result
                self.lResult2.text = "双"
                self.changeResultType()
            }else { self.lResult2.hidden = true}
            
            // 当前竞猜人数
            let personNum = data!["personNum"] as! Int
            self.guessMember.text = "当前竞猜人数为：\(personNum)"
            
            // 我的竞猜
            let myGuess = data!["guess"] as? String
            self.lMyChoice.hidden = false
            if myGuess == "1"
            {
                self.RESULT_TYPE = CDS_CHOICE.Chose
                self.lMyChoice.text = "我的竞猜：单"
            } else if myGuess == "2"
            {
                self.RESULT_TYPE = CDS_CHOICE.Chose
                self.lMyChoice.text = "我的竞猜：双"
            } else {
                
                self.lMyChoice.text = "我的竞猜： "}
            
            self.lResult2.hidden = false

            
            self.changeResultType()
            
            }, failure: { (task, error) in
                print("========服务端API接入失败")
        })

    }

    func setContent() {
        let bonusTotal = Common.getDSBonusTotal()
        let bonusdate = Common.getDSBonusDate()
        
        lMoney.text = "竞猜金额：￥\(bonusTotal)"
        lMkTime.text = "时间：\(bonusdate)"
        //let uid = Common.getUid()
        
        
        let param:NSDictionary = ["uid":uid ,"rid":rid ,"dsId":dsId ,"token":token ]
        print("=====DS\(param)")
        
        mgr.POST(URL_getpersonNum, parameters: param, progress: nil, success: { (task, responObj) in
//            print("=======服务端API接入成功")
//            
            print("==========respon=\(responObj)=========data\(responObj!["data"])=========info\(responObj!["info"])")
            
            let data = responObj!["data"] as! NSDictionary
            let member = data["personNum"] as! Int
            self.guessMember.text = "当前竞猜人数为：\(member)"
            
            
        }) { (task, error) in
//            print("========服务端API接入失败")
        }
    }
    
    func getMyGuess() {
    
        let param:NSDictionary = ["uid":uid,"token":token,"dsId":dsId,"rid":rid]
        
        mgr.POST(URL_getMyGuess, parameters: param, progress: nil, success: { (task, responObj) in
            //            print("=======服务端API接入成功")
            //
                        print("==========respon=\(responObj)=========data\(responObj!["data"])==========info\(responObj!["info"])")
            let data = responObj!["data"] as! NSDictionary
            // 当前竞猜人数
            let personNum = data["personNum"] as! Int
            self.guessMember.text = "当前竞猜人数为：\(personNum)"
            // 我的竞猜
            let myGuess = data["guess"] as? String
            
            if myGuess == "1"
            {
                self.lMyChoice.text = "我的竞猜：单"
            } else if myGuess == "2"
            {
                self.lMyChoice.text = "我的竞猜：双"
            }else { self.lMyChoice.text = "我的竞猜： "}
            
            
            }) { (task, error) in
                //            print("========服务端API接入失败")
        }
        
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
