////////////////////////////////////////////////////////////////////
//                          _ooOoo_                               //
//                         o8888888o                              //
//                         88" . "88                              //
//                         (| ^_^ |)                              //
//                         O\  =  /O                              //
//                      ____/`---'\____                           //
//                    .'  \\|     |//  `.                         //
//                   /  \\|||  :  |||//  \                        //
//                  /  _||||| -:- |||||-  \                       //
//                  |   | \\\  -  /// |   |                       //
//                  | \_|  ''\---/''  |   |                       //
//                  \  .-\__  `-`  ___/-. /                       //
//                ___`. .'  /--.--\  `. . ___                     //
//              ."" '<  `.___\_<|>_/___.'  >'"".                  //
//            | | :  `- \`.;`\ _ /`;.`/ - ` : | |                 //
//            \  \ `-.   \_ __\ /__ _/   .-` /  /                 //
//      ========`-.____`-.___\_____/___.-`____.-'========         //
//                           `=---='                              //
//      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        //
//         佛祖保佑            永无BUG              永不修改         //
////////////////////////////////////////////////////////////////////

import UIKit
import CryptoSwift
let SERVER_HTTP = "http://192.168.111.106/QHB/"

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
let URL_getRandomBonus = SERVER_HTTP + "HB/getRandomBonus"



let IMG_LOADING = "qrcode"

//UserDefault
let UD_ADDRESS = "addr"
let UD_GWCS = "ud_gwcs"
let UD_UID = "ud_uid"
let UD_TOKEN = "ud_token"


// MYXG

let XGurl = "http://openapi.xg.qq.com/v2/push/"

let baseSign = "POSTopenapi.xg.qq.com/v2/push/"

let secretKey = "0e8d5682dc81ab5a2dbd2b211895a389"

let access_id:NSString = "2200195440"
let timeString:NSString = MyXG.setUnix()

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
//    var all:Int
    var cur:Int
//    var each:Int
    var nums:Int
//    var last:String
    var next:String
//    var head:String
//    var foot:String
    var hasNext:Bool
    init(obj:AnyObject){
        let dict = obj as! NSDictionary
        //self.last = dict["last"] as! String
        self.next = dict["next"] as! String
//        self.foot = dict["foot"] as! String
//        self.head = dict["head"] as! String
//        self.all =  dict["all"]!.integerValue
//        self.each =  dict["each"]!.integerValue
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
    
    class func getToken()->String{
        return NSUserDefaults.standardUserDefaults().objectForKey(MyUserDefaultKey.KEY_TOKEN) as! String
    }
    class func getBonusId()->String{
        return NSUserDefaults.standardUserDefaults().objectForKey(MyUserDefaultKey.KEY_BONUS_TOTAL) as! String
    }
    
    class func setBonusId(str:String){
        let mUserDefault =  NSUserDefaults.standardUserDefaults()
        mUserDefault.setObject(str, forKey: MyUserDefaultKey.KEY_BONUS_TOTAL)
        
    }
    
    class func setToken(str:String){
        let mUserDefault =  NSUserDefaults.standardUserDefaults()
        mUserDefault.setObject(str, forKey: MyUserDefaultKey.KEY_TOKEN)
        
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
    
    class func json2obj(json:String)->AnyObject{
        let obj: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(json.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!, options: NSJSONReadingOptions())
        return obj!
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
        req.timeoutInterval = 10
        let task = session.dataTaskWithRequest(req, completionHandler: completionHandler)
        
        task.resume()
    }
    
    class func doUpload(url:String,filename:String,fileData:NSData,completionHandler:(NSData?,NSURLResponse?, NSError?) -> Void){
        
        let request=NSMutableURLRequest(URL:NSURL(string:url)!)
        
        request.HTTPMethod="POST"//设置请求方式
        
        request.timeoutInterval = 5
        
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

class MyXG {
    
    // 发送消息
    class func setUnix () -> NSString {
        let date = NSDate()
        let timeInterval  = date.timeIntervalSince1970
        
        let a = NSInteger (timeInterval)
        
        let timeString:NSString = "\(a)"
        
        return timeString
   
        
    }
    // 发送消息
    class func message (dict:NSDictionary)-> NSString {
        let dict2 = ["aps":dict]

    
        let data = try! NSJSONSerialization.dataWithJSONObject(dict2, options: .PrettyPrinted)

        
        let message:NSString = NSString (data: data ,encoding: NSUTF8StringEncoding)!
        
        return message
 
    }
    // 字典拼接升序
    class func sortDictionary (dict:NSDictionary)-> NSString {
        
        let DictAll = NSMutableDictionary()
        
        let keys = dict.allKeys as NSArray
        
        let sortedArray:NSArray = keys.sortedArrayUsingComparator { (obj1, obj2) -> NSComparisonResult in
            return obj1.compare(obj2 as! String, options: NSStringCompareOptions.NumericSearch)
        }
        
        let appString = NSMutableString()
        
        for categoryId in sortedArray {
            // 表面是字典按升序排，但字典实际上是没顺序
            DictAll.setValue(dict.objectForKey(categoryId), forKey: categoryId as! String)
            
            let value = dict.objectForKey(categoryId) as! String
            
            appString.appendString("\(categoryId)=\(value)")
    
        }
        
        return appString
    }
    
    class func sendMessage (type: NSString ,message:NSString) -> NSDictionary {
    
        let param = NSMutableDictionary()
 
        param.setValue(access_id, forKey: "access_id")
        param.setValue(timeString, forKey: "timestamp")
        param.setValue("0", forKey: "message_type")
        param.setValue("1", forKey: "environment")
        param.setValue(message, forKey: "message")
        
        let appParam = MyXG.sortDictionary(param)
        
        let appString = "\(baseSign)\(type)\(appParam)\(secretKey)"
        
        print("=======\(appString)")
        
        let sign2MD5 = appString.md5()
        
        param.setValue(sign2MD5, forKey: "sign")
        
        return param
        
    }
    
    
}
struct MyUserDefaultKey{
    static let KEY_HEADIMG = "ud_headimg"
    static let KEY_NICKNAME = "ud_nickname"
    static let KEY_MONDY = "ud_money"
    static let KEY_TOKEN = "ud_token"
    static let KEY_BONUS_TOTAL = "ud_bonus_total"
}






