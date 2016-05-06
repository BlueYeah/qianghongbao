//
//  ChatTextTableViewCell.swift
//  QianHongBao
//
//  Created by arkic on 16/1/16.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit
import AFNetworking
class ChatTableViewCell: UITableViewCell {
    
    var headImage:UIImageView!
    var bgImage:UIImageView!
    var contentLabel:UILabel!
    var bgImageBtn:UIButton!
    var lName:UILabel!
    var messageItem:MessageItem!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        headImage = UIImageView()
        self.addSubview(headImage)
        
        lName = UILabel()
        self.addSubview(lName)
        
        if(reuseIdentifier == "textcell"){
            
            //bgImageView
            bgImage = UIImageView()
            //bgImage.backgroundColor = UIColor.clearColor()
            self.addSubview(bgImage)
            
            //label
            contentLabel = UILabel()
            self.addSubview(contentLabel)
            
            
            
        }else if(reuseIdentifier == "hbcell"){
            //bgImageView
            bgImageBtn = UIButton()
            
            self.addSubview(bgImageBtn)
        }
        
    }
    
    func adaptData(mi:MessageItem){
        if(mi.type == ChatType.Text){
            adaptDataText(mi)
        }else if(mi.type == ChatType.CDS || mi.type == ChatType.SJHB){
            adaptDataHongBao(mi)
        }
    }
    func adaptDataText(mi:MessageItem){
        var isSelf=false
        if(mi.uid == 0){
            isSelf=true
        }
        //head Image
        headImage.sd_setImageWithURL(NSURL(string: mi.headImg), placeholderImage: UIImage(named: IMG_LOADING))
//        headImage.image = UIImage(named: mi.headImg)
//        headImage.sd_setImageWithURL(NSURL(string: Common.getHeadImg()), placeholderImage: UIImage(named: IMG_LOADING))
        
        headImage.frame.size = CGSize(width: 40 , height: 40)
        var imageOX = CGFloat(10)
        if(isSelf){
            imageOX = self.frame.width-50
        }
        headImage.frame.origin = CGPoint(x: imageOX, y: 10)
        
        //name
        
        lName.text = mi.name
        let nFont = UIFont.systemFontOfSize(10)
        lName.font = nFont
        lName.textColor = UIColor.darkGrayColor()
        lName.sizeToFit()
        
        var lnx = CGFloat(60)
        if(isSelf){
            lnx = self.frame.width-lName.frame.width-60
        }
        lName.frame.origin = CGPointMake(lnx, 10)
        
        //message content
        //font
        let font = UIFont.systemFontOfSize(CGFloat(14))
        //measure width and height
        var attr = Dictionary<String,AnyObject>()
        attr[NSFontAttributeName] = font
        let contentSize = NSString(string: mi.content).boundingRectWithSize(CGSize(width: 210,height: 1000), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes:attr, context: nil)
        //label view options
        var labelx = CGFloat(70)
        if(isSelf){
            labelx = imageOX - 20-contentSize.width
        }
        
        contentLabel.frame = CGRect(x: labelx, y: 35, width: contentSize.width , height: contentSize.height)
        
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        contentLabel.font = font
        contentLabel.text = mi.content
        contentLabel.backgroundColor = UIColor.clearColor()
        
        
        
        
        //label view bgImage
        var balloon = "balloon_l"
        if(isSelf){
            balloon = "balloon_r"
        }
        var bgImagec = UIImage(named: balloon)!
        if(isSelf){
            bgImagec = bgImagec.stretchableImageWithLeftCapWidth(25, topCapHeight: 20)
        }else{
            bgImagec = bgImagec.stretchableImageWithLeftCapWidth(15, topCapHeight: 20)
        }
        
        bgImage.image = bgImagec
        let bgWidth = contentSize.width + 35
        let bgHeigh = contentSize.height + 20
        var bgx = CGFloat(50)
        if(isSelf){
            bgx = imageOX-bgWidth
        }
        bgImage.frame = CGRectMake(bgx, 25, bgWidth, bgHeigh)
        
    }
    func adaptDataHongBao(mi:MessageItem){
        var isSelf=false
        if(mi.uid == 0){
            isSelf=true
        }
        //head Image
        headImage.sd_setImageWithURL(NSURL(string: mi.headImg), placeholderImage: UIImage(named: IMG_LOADING))
        //headImage.image = UIImage(named: mi.headImg)
        
        
        headImage.frame.size = CGSize(width: 40 , height: 40)
        var imageOX = CGFloat(10)
        if(isSelf){
            imageOX = self.frame.width-50
        }
        headImage.frame.origin = CGPoint(x: imageOX, y: 10)
        
        //name
        lName.text = mi.name
        let nFont = UIFont.systemFontOfSize(10)
        lName.font = nFont
        lName.textColor = UIColor.darkGrayColor()
        lName.sizeToFit()
        var lnx = CGFloat(60)
        if(isSelf){
            lnx = self.frame.width-lName.frame.width-60
        }
        lName.frame.origin = CGPointMake(lnx, 10)
        
        //image
        
     
        var btnActionName:Selector = #selector(ChatTableViewCell.btnShowHB(_:))

            
        if(mi.type==ChatType.CDS){
            btnActionName = #selector(ChatTableViewCell.btnShowCDS(_:))
        }
        bgImageBtn.addTarget(self, action: btnActionName, forControlEvents: UIControlEvents.TouchUpInside)
       
        var imageName = "sjhb"
        if(mi.type == ChatType.CDS){
            imageName = "cds"
        }
        bgImageBtn.setImage(UIImage(named:imageName), forState: UIControlState.Normal)
        let bgWidth = CGFloat(200)
        let bgHeigh = CGFloat(91)
        var bgx = CGFloat(60)
        if(isSelf){
            bgx = self.frame.width-bgWidth-bgx
        }
        bgImageBtn.frame = CGRectMake(bgx, 25, bgWidth, bgHeigh)
    }
    
    func btnShowHB(sender:AnyObject){
        
        Common.setBonusId(messageItem.bonusId!)
        Common.setBonusImage(messageItem.headImg)
        Common.setBonusNickName(messageItem.name)
        
        print("==============点击了SJHB 存放红包信息")
        
        let mgr = AFHTTPSessionManager()
        let token = Common.getToken()
        let uid = Common.getUid()
        let bonus_id = Common.getBonusId()
        
        let param:NSDictionary = ["uid":uid, "token":token,"id":bonus_id ]
        
        // 点击后先判断红包是否有效
        mgr.POST(URL_getRandomBonus, parameters: param, progress: nil, success: { (task, responseObj) in
            print("服务端API接入成功")
            print("=============data\(responseObj!["data"])==============SJ红包的response\(responseObj)========SJ红包的info\(responseObj!["info"] as! String)")
            
            if (responseObj!["data"]as? String == "")
            {
                print("=======红包失效============")

                var vc = UIApplication.sharedApplication().keyWindow?.rootViewController
                while(vc?.presentedViewController != nil){
                    vc = vc?.presentedViewController
                }
                
                print("当前的VC=========的view\(vc)")
                let hud1 = MBProgressHUD.showHUDAddedTo(vc!.view, animated: true)
                hud1.label.text = "网络异常"
                hud1.hideAnimated(true, afterDelay: 1)
                return
            }
            
            var vc = UIApplication.sharedApplication().keyWindow?.rootViewController
            while(vc?.presentedViewController != nil){
                vc = vc?.presentedViewController
            }
            
            let controller = vc!.storyboard!.instantiateViewControllerWithIdentifier("SJHBViewController") as UIViewController
            vc?.presentViewController(controller, animated: true, completion: nil)
            
            
        }) { (task, error) in
            print(error)
            print("服务端API接入失败")
            return
            
        }

        
        

        

        
        
    }
    
    func getCurrentVc() -> UIViewController {
        var result = UIViewController()
        
        var window:UIWindow = UIApplication.sharedApplication().keyWindow!
        if window.windowLevel != UIWindowLevelNormal {
            let windows = UIApplication.sharedApplication().windows
            
            for tmpWin:UIWindow in windows {
                if tmpWin.windowLevel == UIWindowLevelNormal {
                    window = tmpWin
                    break
                }
            }
        
            
        }
        
        let frontView = window.subviews[0]
        let  nextResponder:AnyObject = frontView.nextResponder()!
        if nextResponder.isKindOfClass(UIViewController) {
            result = nextResponder as! UIViewController
        }else { result = window.rootViewController!}
        
        
        return result
        
    }
    

    func btnShowCDS(sender:AnyObject){
        
        Common.setDSBonusId((messageItem.dsBonus?.id)!)
        Common.setDSBonusTotal((messageItem.dsBonus?.bonus_total)!)
        Common.setDSBonusDate((messageItem.dsBonus?.date)!)
        Common.setDSBonusTime((messageItem.dsBonus?.dsTime)!)
        var vc = UIApplication.sharedApplication().keyWindow?.rootViewController
        while(vc?.presentedViewController != nil){
            vc = vc?.presentedViewController
        }
        
        let controller = vc!.storyboard!.instantiateViewControllerWithIdentifier("CDSVC") as UIViewController
        vc?.presentViewController(controller, animated: true, completion: nil)

        
    }
    
}
