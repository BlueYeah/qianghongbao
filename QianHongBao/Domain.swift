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
let SERVER_HTTP = "http://192.168.0.106/QHB/"

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
let URL_getRoom = SERVER_HTTP + "Room/sendRoomPHP"
let URL_getUserNotice = SERVER_HTTP + "User/notice"
let URL_getpersonNum = SERVER_HTTP + "DS/getpersonNum"
let URL_guessDS = SERVER_HTTP + "DS/cds"
let URL_getDSResult = SERVER_HTTP + "DS/getResult"
let URL_getMyGuess = SERVER_HTTP + "DS/getMyGuess"


let IMG_LOADING = "qrcode"

//UserDefault
let UD_ADDRESS = "addr"
let UD_GWCS = "ud_gwcs"
let UD_UID = "ud_uid"
let UD_TOKEN = "ud_token"

//BonusDetail
let BD_NICKNAME = "bd_nickname"
let BD_IMAGE = "bd_image"

//RoomDetail
let R_ID = "rid"

//DSBonus
let DS_ID = "ds_id"
let DS_TOTAL = "ds_total"
let DS_DATE = "ds_date"
let DS_TIME = "ds_time"



// MYXG

let XGurl = "http://openapi.xg.qq.com/v2/push/"

let baseSign = "POSTopenapi.xg.qq.com/v2/push/"

let secretKey = "0e8d5682dc81ab5a2dbd2b211895a389"
let adSecreKey = "92319602671d73ebab46ff60537e3754"


let access_id:NSString = "2200195440"
let adAccess_id:NSString = "2100189658"



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

class User{
    
    var image:String
    var money:String
    var time:String
    var name:String
    
    
    init(name:String,image:String,money:String,time:String){
        self.name = name
        self.image = image
        self.time = time
        self.money = money
    }
    
    init(obj:AnyObject){
        let dict = obj as! NSDictionary
        
        self.image = dict["user"]!["photo"] as! String
        
        self.time = dict["time"] as! String
        
        self.name = dict["user"]!["nackname"] as! String
        
        self.money = String( dict["bonus"] as! NSNumber)
        
        
    }
    class func initWithUser(obj:AnyObject)->[User]{
        var res:[User] = []
        if let arr = obj as? NSArray{
            for item in arr{
                res.append(User(obj: item))
            }
        }
        return res
    }
    
}

class DSBonus {
    var id:Int
    var bonus_total:Float
    var date:String
    var dsTime:Float

    init(id:Int,bonus_total:Float,date:String,dsTime:Float)
    {
        self.id = id
        self.bonus_total = bonus_total
        self.date = date
        self.dsTime = dsTime
    }
    
}

class Room{
    
    var image:String
    var name:String
//    var time:String
    var label:String?
    var rid:Int
    
    
    
    init(name:String,image:String,rid:Int){
        self.name = name
        self.image = image
        self.rid = rid

    }
    
    init(obj:AnyObject){
        let dict = obj as! NSDictionary
        
        self.image = dict["roomPhoto"] as! String
        
//        self.time = dict["time"] as! String
        
        self.name = dict["roomName"] as! String
        self.rid = Int (dict["rid"] as! String)!
        
        
    }
    class func initWithRoom(obj:AnyObject)->[Room]{
        var res:[Room] = []
        if let arr = obj as? NSArray{
            for item in arr{
                res.append(Room(obj: item))
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
    class func getBonusId()->Int{
        return NSUserDefaults.standardUserDefaults().objectForKey(MyUserDefaultKey.KEY_BONUS_TOTAL) as! Int
    }
    
    class func getBonusImage()->String{
        return NSUserDefaults.standardUserDefaults().objectForKey(BD_IMAGE) as! String
    }
    
    class func getBonusNickName()->String{
        return NSUserDefaults.standardUserDefaults().objectForKey(BD_NICKNAME) as! String
    }
    
    class func getNowRid()->Int{
        return NSUserDefaults.standardUserDefaults().objectForKey(R_ID) as! Int
    }
    
    class func getDSBonusId()->Int{
        return NSUserDefaults.standardUserDefaults().objectForKey(DS_ID) as! Int
    }
    class func getDSBonusTotal()->Float{
        return NSUserDefaults.standardUserDefaults().objectForKey(DS_TOTAL) as! Float
    }
    class func getDSBonusDate()->String{
        return NSUserDefaults.standardUserDefaults().objectForKey(DS_DATE) as! String
    }
    
    class func getDSBonusTime()->Float{
        return NSUserDefaults.standardUserDefaults().objectForKey(DS_TIME) as! Float
    }
    
    
    class func setDSBonusTime(str:Float) {
        let mUserDefault = NSUserDefaults.standardUserDefaults()
        mUserDefault.setObject(str, forKey: DS_TIME)
        
    }
    
    class func setDSBonusId(str:Int) {
        let mUserDefault = NSUserDefaults.standardUserDefaults()
        mUserDefault.setObject(str, forKey: DS_ID)
        
    }
    class func setDSBonusTotal(str:Float) {
        let mUserDefault = NSUserDefaults.standardUserDefaults()
        mUserDefault.setObject(str, forKey: DS_TOTAL)
        
    }
    class func setDSBonusDate(str:String) {
        let mUserDefault = NSUserDefaults.standardUserDefaults()
        mUserDefault.setObject(str, forKey: DS_DATE)
        
    }
    
    class func setNowRid(str:Int) {
        let mUserDefault = NSUserDefaults.standardUserDefaults()
        mUserDefault.setObject(str, forKey: R_ID)
        
    }
    
    
    class func setBonusImage(str:String){
        let mUserDefault =  NSUserDefaults.standardUserDefaults()
        mUserDefault.setObject(str, forKey: BD_IMAGE)
        
    }
    
    
    
    class func setBonusNickName(str:String){
        let mUserDefault =  NSUserDefaults.standardUserDefaults()
        mUserDefault.setObject(str, forKey: BD_NICKNAME)
        
    }

    class func setBonusId(str:Int){
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
    
    class func getSeconds(mi:String ) -> String {
        // 1.获取当前消息对应date字符串
        let msgDateString = mi
        //let lastmsgDateString = lastmsg
        
        // 2.获取当前时间字符串
        let date = NSDate()
        
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        // 2.1 转换成Date类型
        let msgDate = formatter.dateFromString(msgDateString)
        
        let nowdate = formatter.stringFromDate(date)
        let mydate = formatter.dateFromString(nowdate)
        
        let seconds = Int((mydate?.timeIntervalSinceDate(msgDate!))!)
        
        //let seconds = mydate?.timeIntervalSinceDate(msgDate!)
 
        
        var timerStr:String?
        
        if seconds > 60 {
            
            // 少于1天
            if seconds < 60 * 60 * 24 {
                
                formatter.dateFormat = "HH:mm"
                timerStr = formatter.stringFromDate(msgDate!)
                
            }
                // 大于1天直接显示日期
            else {
                timerStr = msgDateString
            }
            
            
            // 5分钟内不显示
        }else { timerStr = ""}
        
        return timerStr!
    }
    
   class func friendlyTime(dateTime: String) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "zh_CN")
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm:ss")
        if let date = dateFormatter.dateFromString(dateTime) {
            let delta = NSDate().timeIntervalSinceDate(date)
            
            if (delta <= 0) {
                return "刚刚"
            }
            else if (delta < 60) {
                return "\(Int(delta))秒前"
            }
            else if (delta < 3600) {
                return "\(Int(delta / 60))分钟前"
            }
            else {
                let calendar = NSCalendar.currentCalendar()
                let unitFlags:NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day,NSCalendarUnit.Hour,NSCalendarUnit.Minute]
                
                let comp = calendar.components(unitFlags, fromDate: NSDate())
                let currentYear = String(comp.year)
                let currentDay = String(comp.day)
                
                let comp2 = calendar.components(unitFlags, fromDate: date)
                let year = String(comp2.year)
                let month = String(comp2.month)
                let day = String(comp2.day)
                var hour = String(comp2.hour)
                var minute = String(comp2.minute)
                
                if comp2.hour < 10 {
                    hour = "0" + hour
                }
                if comp2.minute < 10 {
                    minute = "0" + minute
                }
                
                if currentYear == year {
                    if currentDay == day {
                        return "今天 \(hour):\(minute)"
                    } else {
                        return "\(month)月\(day)日 \(hour):\(minute)"
                    }
                } else {
                    return "\(year)年\(month)月\(day)日 \(hour):\(minute)"
                }
            }
        }
        return ""
    }
    
    class func substring(indexString:String ,content:String) -> String {
        let source = content
        let str = indexString
        let subRange = (source as NSString).rangeOfString(str)   //子范围
        let index = subRange.location
        let result = (source as NSString).substringFromIndex(index + 1)  //子字符串
        return result
    }
    
    //保存头像图片到本地沙盒
    class func saveIconImageToSandBox(iconImage:UIImage,imageImageNmae:String){
        
        //首先拿到沙盒路径
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as NSString
        
        let iconImagePath = path.stringByAppendingPathComponent(imageImageNmae)
        print(iconImagePath)
        let imageData = UIImageJPEGRepresentation(iconImage, 1.0)
        
        imageData?.writeToFile(iconImagePath, atomically: true)
    }
    
    //从沙盒中取出头像
    class func getImageFromSandBox() -> UIImage{
        
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last
        let saveIconImagePath = path! + "/iconImage.png"
        print("imagepath\(saveIconImagePath)")
        let saveIconImage = UIImage.init(contentsOfFile: saveIconImagePath) ?? UIImage(named: "qrcode")
        
        return saveIconImage!
    }
    // 判断是否为手机号
    class func isTelNumber(num:NSString)->Bool
    {
        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
        let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        let  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        let length = num.length
        
        
        if length <= 11 {
            if ((regextestmobile.evaluateWithObject(num) == true)
                || (regextestcm.evaluateWithObject(num)  == true)
                || (regextestct.evaluateWithObject(num) == true)
                || (regextestcu.evaluateWithObject(num) == true))
            {
                return true
            }
            else
            {
                return false
            }
        } else
        {
            return false
        }
        
    }


}

class MyDialog{
    class func showAlert(vc:UIViewController,title:String,msg:String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        vc.presentViewController(alert, animated: true, completion: nil)
    }
    class func showErrorAlert(vc:UIViewController,msg:String,completion: (() -> Void)?){
        let alert = UIAlertController(title: "错误", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (la) in
            print("------------------vc\(vc)")
            //vc.dismissViewControllerAnimated(true, completion: nil)
            if (completion != nil) {
                completion!()
            }


        }))
        vc.presentViewController(alert, animated: true, completion: nil)
//        if (completion != nil) {
//            completion!()
//        }
        // 调用block
 
    }
    class func showmyErrorAlert(vc:UIViewController,msg:String,completion: (() -> Void)?){
        let alert = UIAlertController(title: "错误", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (la) in
            print("------------------vc\(vc)")
            vc.dismissViewControllerAnimated(true, completion: nil)
            
            if (completion != nil) {
                print("======打印了block")
                completion!()
            }
            
        }))
        vc.presentViewController(alert, animated: true, completion: nil)

        // 调用block
        
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
    // 发送ios消息
    class func message (dict:NSDictionary)-> NSString {
        let dict2 = ["aps":dict]

    
        let data = try! NSJSONSerialization.dataWithJSONObject(dict2, options: .PrettyPrinted)

        
        let message:NSString = NSString (data: data ,encoding: NSUTF8StringEncoding)!
        
        return message
 
    }
    // 发送Android消息
    class func Admessage (dict:NSDictionary)-> NSString {
        let dict2 = ["title":"1","content":dict]
        
        // json
        let data = try! NSJSONSerialization.dataWithJSONObject(dict2, options: .PrettyPrinted)
        
        // json字符串
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
    
    class func sendMessage (accessId:String, type: NSString ,message:NSString,enviroment:String,messageType:String) -> NSDictionary {
    
        let param = NSMutableDictionary()
 
        let timeString:NSString = MyXG.setUnix()
        param.setValue(accessId, forKey: "access_id")
        param.setValue(timeString, forKey: "timestamp")
        param.setValue(messageType, forKey: "message_type")
        param.setValue(enviroment, forKey: "environment")
        param.setValue(message, forKey: "message")
        
        let appParam = MyXG.sortDictionary(param)
        
        var appString = "\(baseSign)\(type)\(appParam)\(secretKey)"
        if enviroment == "0" {
            appString = "\(baseSign)\(type)\(appParam)\(adSecreKey)"
        }
        
        //print("=======\(appString)")
        
        let sign2MD5 = appString.md5()
        
        param.setValue(sign2MD5, forKey: "sign")
        
        return param
        
    }
    
    
}

class MySQL {
    /// 将数据保存到数据库
   class func saveMessage(dict:[String: AnyObject]) {
        
        // 1.定义SQL语句
        let sql = "INSERT OR REPLACE INTO message (id, rid,uid,content,nackname,date,status,type,bonus_total,dsTime,photo) VALUES ( ?, ?,?,?,?,?,?,?,?,?,?);"
        

            // 3.1 cid
            let id = dict["id"] as! Int
            let rid = dict["rid"] as! Int
            let uid = dict["uid"] as! Int
            let content = dict["alert"] as! String
            let nackname = dict["nackname"] as! String
    let date:String
    
            if let _ = dict["date"] as? String  {
                date = dict["date"] as! String
            }else {
                date = "0"
                
            }
    let status:Int
    
    if let _ = dict["status"] as? Int  {
        status = dict["status"] as! Int
    }else {
         status = 0
        
    }
    let dsTime:Int
    
    if let _ = dict["dsTime"] as? Int  {
         dsTime = dict["dsTime"] as! Int
    }else {
         dsTime = 0
        
    }
    let bonus_total:Float
    if let _ = dict["bonus_total"] as? Float  {
         bonus_total = dict["bonus_total"] as! Float
    }else {
         bonus_total = 0
        
    }
    

            let type = dict["type"] as! Int
            let photo = dict["photo"] as! String
  
            
            // 4. 执行 sql
            SQLiteManager.sharedSQLiteManager.queue!.inTransaction({ (db, rollback) -> Void in
                if !db.executeUpdate(sql, id, rid, uid, content,nackname,date,status,type,bonus_total,dsTime,photo) {
                    rollback.memory = true
                }
            })
    
    }
    
    /// 加载缓存数据
    class  func loadMessage(since_id: Int, max_id: Int,rid:Int ,finished:(array:Array<MessageItem>)->())
    {
        // 1.定义SQL语句
        var sql = "SELECT mid, id, rid, uid,content,nackname,date,status,type,bonus_total,dsTime,photo FROM message WHERE rid = \(rid)"
        
//        if since_id > 0 {           // 下拉刷新
//            sql += "AND mid > \(since_id) \n"
//        } else if max_id > 0 {      // 上拉刷新
//            sql += "AND mid <= \(max_id) \n"
//        }
//        sql += "ORDER BY mid DESC LIMIT 3;"
        
        // 测试 sql
        print(sql)
        
        // 3. 执行 SQL
        SQLiteManager.sharedSQLiteManager.queue?.inDatabase({ (db) -> Void in
            let rs = db.executeQuery(sql)!


            // 字典是一条完整的微博数据的字典
            var array:Array<MessageItem> = []
            
            while rs.next() {

                
                let uid = Int( rs.intForColumn("uid"))
                let type = rs.intForColumn("type")
                let name = rs.stringForColumn("nackname")
                let headImg = rs.stringForColumn("photo")
                let message = rs.stringForColumn("content")
                
                let content = Common.substring(":", content: message)
                
                
                
                let id = rs.intForColumn("id")
                let bonus_total = Float( rs.intForColumn("bonus_total"))
                let date = rs.stringForColumn("date")
                let dstime = Float( rs.intForColumn("dsTime"))
                
                let myuid = Common.getUid()
                // 判断是否自己的消息
                var Userid:Int = 1
                
                if uid == myuid {
                    Userid = 0
                }
                
                if type == 1 {

                    
                    array.append(MessageItem(uid:Userid ,type:ChatType.Text,name:name,headImg:headImg ,content:content,bonusId:nil,dsBonus: nil ,date: date))
                    
                }else if type == 2
                {
                    

                    array.append(MessageItem(uid:Userid,type:ChatType.SJHB,name:name ,headImg:content ,content:content,bonusId:Int (id),dsBonus: nil,date: date))
                    
                }else if type == 3
                    
                {
                    print("=======猜单双")

                    
                    
                    let dsBonus = DSBonus.init(id:Int(id), bonus_total: bonus_total, date: date, dsTime: dstime)
                    
                    array.append(MessageItem(uid:Userid,type:ChatType.CDS,name:name,headImg:headImg ,content:content,bonusId:nil,dsBonus: dsBonus,date: date))
                }else if type == 4
                    
                {
                    print("=======猜随机")
                    
                    array.append(MessageItem(uid:Userid,type:ChatType.Text,name:name,headImg:headImg ,content:content,bonusId:nil,dsBonus: nil,date: date))
                }else if type == 5
                    
                {
                    print("=======猜单双")
                    let message:String
                    if content == "1"
                    {
                        message = "本期单双开奖结果：单"
                    }else {message = "本期单双开奖结果：双"}
                    array.append(MessageItem(uid:Userid,type:ChatType.Text,name:name,headImg:headImg ,content:message,bonusId:nil,dsBonus: nil,date: date))
                }


                           }
            
            // 完成回调
            finished(array: array)
        })
    }


}


struct MyUserDefaultKey{
    static let KEY_HEADIMG = "ud_headimg"
    static let KEY_NICKNAME = "ud_nickname"
    static let KEY_MONDY = "ud_money"
    static let KEY_TOKEN = "ud_token"
    static let KEY_BONUS_TOTAL = "ud_bonus_total"
}






