//
//  Domain.swift
//  QianHongBao
//
//  Created by arkic on 16/3/7.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit

let SERVER_HTTP = "http://192.168.100.108:8001/index.php/"

let URL_Product = SERVER_HTTP + "Product/getJson"
let URL_Slider = SERVER_HTTP + "Slider/getJson"
let URL_AddOrder = SERVER_HTTP + "Order/insert"
let URL_UserLogin = SERVER_HTTP + "User/login"
let URL_UserRegister = SERVER_HTTP + "User/register"
let URL_UserLogout = SERVER_HTTP + "User/logout"
let URL_UserModPwd = SERVER_HTTP + "User/update"
let URL_Order = SERVER_HTTP + "Order/getJson"
let URL_UserInfo = SERVER_HTTP + "User/getInfo"
let URL_UserHeadImage = SERVER_HTTP + "User/updatePhoto"

let IMG_LOADING = "qrcode"

//UserDefault
let UD_ADDRESS = "addr"
let UD_GWCS = "ud_gwcs"
let UD_UID = "ud_uid"

class Product{
    var id:Int
    var image:String
    var title:String
    var price:Double
    
    init(id:Int,image:String,title:String,price:Double){
        self.id = id
        self.image = image
        self.title = title
        self.price = price
    }
    
    init(obj:AnyObject){
        let dict = obj as! NSDictionary
        
        self.image = dict["picture"] as! String
        
        self.title = dict["pname"] as! String
        
        self.price = dict["price"]!.doubleValue
        
        self.id = dict["pid"]!.integerValue
        
    }
    class func initWithJsonObjs(obj:AnyObject)->[Product]{
        var res:[Product] = []
        if let arr = obj as? NSArray{
            for item in arr{
                res.append(Product(obj: item))
            }
        }
        return res
    }

}
class Page{
    var all:Int
    var cur:Int
    var each:Int
    var nums:Int
    var last:String
    var next:String
    var head:String
    var foot:String
    var hasNext:Bool
    init(obj:AnyObject){
        let dict = obj as! NSDictionary
        self.last = dict["last"] as! String
        self.next = dict["next"] as! String
        self.foot = dict["foot"] as! String
        self.head = dict["head"] as! String
        self.all =  dict["all"]!.integerValue
        self.each =  dict["each"]!.integerValue
        self.cur =  dict["cur"]!.integerValue
        self.nums =  dict["nums"]!.integerValue
        if(cur == nums){
            self.hasNext = false
        }else{
            self.hasNext = true
        }
    }
}
class Slider{
    var image:String
    init(obj:AnyObject){
        let dict = obj as! NSDictionary
        self.image = dict["image"] as! String
    }
    class func initWithJsonObjectArray(obj:AnyObject)->[Slider]{
        var arr:[Slider] = []
        if let sliders = obj as? NSArray{
            for item in sliders{
                arr.append(Slider(obj: item))
            }
        }
        return arr
    }
}
class Order{
    var name:String
    var tel:String
    var addr:String
    var time:String
    var pros:[Product]
    var nums:[Int]
    var sum:Double
    var orderid:String
    var state:String
    
    init(obj:AnyObject){
        let dict = obj as! Dictionary<String,AnyObject>
        
        self.name = dict["receName"] as! String
        
        self.tel = dict["recePhone"] as! String
        
        self.addr = dict["receAddr"] as! String
        
        self.time = dict["time"] as! String
        
        self.orderid = dict["oid"] as! String
        
        let stateCode = dict["state"]!.integerValue
        if(stateCode==0){
            self.state = "待处理"
        }else{
            self.state = "已完成"
        }
        
        self.pros = []
        self.nums = []
        self.sum = 0
        do{
            
        
        let jpros = try NSJSONSerialization.JSONObjectWithData((dict["products"] as! String).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!, options: NSJSONReadingOptions.AllowFragments) as! [Dictionary<String,AnyObject>]
        
        for jpro in jpros{
            let pro = Product(obj: jpro["product"]!)
            pros.append(pro)
            let num = jpro["num"]!.integerValue
            nums.append(num)
            
            sum = sum + Double(pro.price)*Double(num)
            }
        }catch{
            
        }
    }
    class func initWithJsonObjs(obj:AnyObject)->[Product]{
        var res:[Product] = []
        if let arr = obj as? NSArray{
            for item in arr{
                res.append(Product(obj: item))
            }
        }
        return res
    }
}
class Common{

    class func getUid()->Int{
        return NSUserDefaults.standardUserDefaults().integerForKey(UD_UID)
    }
    class func getHeadImg()->String{
        return NSUserDefaults.standardUserDefaults().objectForKey(MyUserDefaultKey.KEY_HEADIMG) as! String
    }
    class func getNickName()->String{
        return NSUserDefaults.standardUserDefaults().objectForKey(MyUserDefaultKey.KEY_NICKNAME) as! String
    }
    class func getMoney()->Double{
        return NSUserDefaults.standardUserDefaults().doubleForKey(MyUserDefaultKey.KEY_MONDY)
    }
    
    
    class func setHeadImg(str:String){
        let mUserDefault =  NSUserDefaults.standardUserDefaults()
        mUserDefault.setObject(str, forKey: MyUserDefaultKey.KEY_HEADIMG)
        
    }
    class func setNickName(str:String){
        let mUserDefault =  NSUserDefaults.standardUserDefaults()
        mUserDefault.setObject(str, forKey: MyUserDefaultKey.KEY_NICKNAME)
    }
    class func setMoney(str:Double){
        let mUserDefault =  NSUserDefaults.standardUserDefaults()
        mUserDefault.setDouble(str, forKey: MyUserDefaultKey.KEY_MONDY)
    }
    
    class func showAlert(vc:UIViewController,title:String,msg:String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        vc.presentViewController(alert, animated: true, completion: nil)
    }
}
class MyDialog{
    class func showAlert(vc:UIViewController,title:String,msg:String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        vc.presentViewController(alert, animated: true, completion: nil)
    }
    class func showErrorAlert(vc:UIViewController,msg:String){
        let alert = UIAlertController(title: "错误", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        vc.presentViewController(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (la) in
            vc.dismissViewControllerAnimated(true, completion: nil)
        }))
    }
    class func showSuccessAlert(vc:UIViewController,msg:String){
        let alert = UIAlertController(title: "成功", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (la) in
            vc.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        vc.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func showLoadingAlert(vc:UIViewController){
        let alert = UIAlertController(title: "", message: "正在加载...", preferredStyle: UIAlertControllerStyle.Alert)
        vc.presentViewController(alert, animated: true, completion: nil)
    }
}
class MyHttp{
    class func doPost(url:String,data:Dictionary<String,AnyObject>?,completionHandler:(NSData?,NSURLResponse?, NSError?) -> Void){
        let req = NSMutableURLRequest(URL: NSURL(string: url)!)
        req.HTTPMethod = "POST"
        if let notNilData = data{
            var param = ""
            for (key,value) in notNilData{
                if(param != ""){
                    param = "\(param)&"
                }
                param = "\(param)\(key)=\(value)"
            }
            
            req.HTTPBody = param.dataUsingEncoding(NSUTF8StringEncoding)
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(req, completionHandler: completionHandler)
        task.resume()
    }
    
    class func doUpload(url:String,filename:String,fileData:NSData,completionHandler:(NSData?,NSURLResponse?, NSError?) -> Void){
        
        let request=NSMutableURLRequest(URL:NSURL(string:url)!)
        
        request.HTTPMethod="POST"//设置请求方式
        
        let boundary:String="-------------------21212222222222222222222"
        
        let contentType:String="multipart/form-data;boundary="+boundary
        
        request.addValue(contentType, forHTTPHeaderField:"Content-Type")
        
        let body=NSMutableData()
        
        body.appendData(NSString(format:"\r\n--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        
        body.appendData(NSString(format:"Content-Disposition:form-data;name=\"\(filename)\";filename=\"dd.jpg\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        
        body.appendData(NSString(format:"Content-Type:application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        
        body.appendData(fileData)
        
        body.appendData(NSString(format:"\r\n--\(boundary)").dataUsingEncoding(NSUTF8StringEncoding)!)
        
        request.HTTPBody=body
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: completionHandler)
        task.resume()
    }
}
struct MyUserDefaultKey{
    static let KEY_HEADIMG = "ud_headimg"
    static let KEY_NICKNAME = "ud_nickname"
    static let KEY_MONDY = "ud_money"
}






