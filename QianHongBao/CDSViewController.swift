//
//  CDSViewController.swift
//  QianHongBao
//
//  Created by arkic on 16/3/4.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit
enum CDS_CHOICE{
    case Choose
    case Chose
    case Result
}
class CDSViewController: UIViewController {
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
    var restSeconds = 100
    
    @IBAction func btnDan(sender: AnyObject) {
        let vc = storyboard!.instantiateViewControllerWithIdentifier("CDSVC") as UIViewController
        presentViewController(vc, animated: true, completion: nil)
        dismissViewControllerAnimated(false, completion: nil)
       
    }
    @IBAction func btnShuang(sender: AnyObject) {
        print("s clilck")
    }
    @IBAction func btnBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(RESULT_TYPE==CDS_CHOICE.Choose){
            lMyChoice.removeFromSuperview()
            lResult.removeFromSuperview()
            lResult2.removeFromSuperview()
            
            
        }else if(RESULT_TYPE==CDS_CHOICE.Chose){
            lResult.removeFromSuperview()
            lResult2.removeFromSuperview()
            btnD.removeFromSuperview()
            btnS.removeFromSuperview()
            
        }else if(RESULT_TYPE==CDS_CHOICE.Result){
            btnD.removeFromSuperview()
            btnS.removeFromSuperview()
            
        }
        lTime.text = getTimeStr(self.restSeconds)
        if(self.restSeconds>0){
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(CDSViewController.countTime(_:)), userInfo: nil, repeats: true)
        
            NSRunLoop.currentRunLoop().addTimer(self.timer, forMode: NSRunLoopCommonModes)
        }
    }

    func countTime(sender:AnyObject){
        if(self.restSeconds<0){
            self.timer.invalidate()
            return
        }
        lTime.text = getTimeStr(self.restSeconds)
        self.restSeconds -= 1
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
