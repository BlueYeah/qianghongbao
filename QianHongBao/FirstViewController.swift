//
//  FirstViewController.swift
//  QianHongBao
//
//  Created by arkic on 16/1/10.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    let TAG_PRO_IMG=1
    let TAG_PRO_TITLE=2
    let TAG_PRO_MONEY=3
    let TAG_PRO_NUM=4
    let TAG_PRO_ADD=5
    let TAG_PRO_DEC=6
    let TAG_PRO_ID = 7
    
    @IBOutlet weak var tvProducts: UITableView!
    var viewAppearCounter = 0
    var sliders:[Slider]!
    var mMJRefresh:MJRefreshAutoNormalFooter!
    var pros:[Product] = []
    var page:Page!
    var getCurPageProductUrl:String!
    
    @IBOutlet weak var slider: JLSliderView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCurPageProductUrl = URL_Product
        // Do any additional setup after loading the view, typically from a nib.
        //init MJRefresh
        mMJRefresh = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(FirstViewController.endRefreshing))
        tvProducts.addSubview(mMJRefresh)
        mMJRefresh.beginRefreshing()
//        endRefreshing()
    }
    func endRefreshing(){
        adaptProduct()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    override func viewWillAppear(animated: Bool) {
        
        if(viewAppearCounter == 0){
            adaptSlider()
        }
        NSUserDefaults.standardUserDefaults().removeObjectForKey(UD_GWCS)
        self.tvProducts.reloadData()
        viewAppearCounter += 1
    }
    func adaptSlider(){
        let sUrl = URL_Slider
        MyHttp.doPost(sUrl, data: nil) { (data, rep, error) in
            dispatch_async(dispatch_get_main_queue(), {
                let res = NSString(data: data!, encoding: NSUTF8StringEncoding)
                let res_jsonobj: AnyObject = self.json2obj(res! as String)
                self.sliders = Slider.initWithJsonObjectArray(res_jsonobj.objectForKey("slider")!)
                
                
                var images:[String] = []
                for slider in self.sliders{
                    images.append(slider.image)
                }
                self.slider.initSlider(images)
            })
        }
    }
    func adaptProduct(){
        let sUrl = getCurPageProductUrl
        MyHttp.doPost(sUrl, data: nil) { (data, req, error) in
            dispatch_async(dispatch_get_main_queue(), {
                let res = NSString(data: data!, encoding: NSUTF8StringEncoding)
                let res_jsonobj: AnyObject = self.json2obj(res! as String)
                let page_jsonobj: AnyObject = res_jsonobj.objectForKey("page")!
                let products: AnyObject = res_jsonobj.objectForKey("products")!
                
                self.pros += Product.initWithJsonObjs(products)
                
                let page = Page(obj: page_jsonobj)
                
                self.tvProducts.reloadData()
                if(page.hasNext){
                    self.getCurPageProductUrl = URL_Product + "/page/\(page.cur+1)"
                    self.mMJRefresh.endRefreshing()
                }else{
                    self.mMJRefresh.endRefreshingWithNoMoreData()
                }
            })
        }

    }

    func json2obj(json:String)->AnyObject{
        let obj: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(json.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!, options: NSJSONReadingOptions())
        return obj!
    }
    func dict2json(dict:Dictionary<String,String>)->String{
        if(!NSJSONSerialization.isValidJSONObject(dict)){
            return ""
        }
        let data = try? NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions())
        let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
        return jsonStr! as String
    }
    @IBAction func btnGwc(sender: AnyObject) {
        let vc = storyboard!.instantiateViewControllerWithIdentifier("JieSuanVC") as UIViewController
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pros.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let pro = pros[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("productCell", forIndexPath: indexPath) as UITableViewCell
        
        let productFaceImageView = cell.viewWithTag(TAG_PRO_IMG) as! UIImageView
        
        productFaceImageView.sd_setImageWithURL(NSURL(string:pro.image), placeholderImage: UIImage(named:IMG_LOADING))
        
        let productTitleLabel = cell.viewWithTag(TAG_PRO_TITLE) as! UILabel
        
        productTitleLabel.text = pro.title
        
        let productMoneyLabel = cell.viewWithTag(TAG_PRO_MONEY) as! UILabel
        
        productMoneyLabel.text = "\(pro.price)"
        
        let productNumLabel = cell.viewWithTag(TAG_PRO_NUM) as! UILabel
        
        let productIDLabel = cell.viewWithTag(TAG_PRO_ID) as! UILabel
        
        productIDLabel.text = String(indexPath.row)
        
        let productAddBtn = cell.viewWithTag(TAG_PRO_ADD) as! UIButton
        
        let productDecBtn = cell.viewWithTag(TAG_PRO_DEC) as! UIButton
        
        productAddBtn.addTarget(self, action: #selector(FirstViewController.addPro(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        productDecBtn.addTarget(self, action: #selector(FirstViewController.decPro(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        productNumLabel.text = "0"
        
        return cell
    }
    func addPro(sender:UIButton){
        let cell = sender.superview!
        let proNumLabel = cell.viewWithTag(TAG_PRO_NUM) as! UILabel
        let num:String! = proNumLabel.text
        let numInt = Int(num)! + 1
        proNumLabel.text = String(numInt)
        
        let proIdLabel = cell.viewWithTag(TAG_PRO_ID) as! UILabel
        let id = proIdLabel.text!
        let pro = pros[Int(id)!]

        let mUserDefault = NSUserDefaults.standardUserDefaults()
        if(numInt==1){
            let gwc = ["id":pro.id,"title":pro.title,"price":pro.price,"num":numInt]
            if var gwcs = mUserDefault.dictionaryForKey(UD_GWCS){
                gwcs[id] = gwc
                mUserDefault.setObject(gwcs, forKey: UD_GWCS)
            }else{
                let dict = [id:gwc]
                mUserDefault.setObject(dict, forKey: UD_GWCS)
            }
        }else{
            var gwcs = mUserDefault.dictionaryForKey(UD_GWCS)!
            var gwc = gwcs[id] as! Dictionary<NSObject,AnyObject>
            gwc.updateValue(numInt, forKey: "num")
            gwcs[id] = gwc
            mUserDefault.setObject(gwcs, forKey: UD_GWCS)
        }
    }
    func decPro(sender:UIButton){
        let cell = sender.superview!
        let proNumLabel = cell.viewWithTag(TAG_PRO_NUM) as! UILabel
        let num:String! = proNumLabel.text
        let numInt = Int(num)! - 1
        if numInt >= 0{
            proNumLabel.text = String(numInt)
            
            let proIdLabel = cell.viewWithTag(TAG_PRO_ID) as! UILabel
            let id = proIdLabel.text!
            _ = pros[Int(id)!]
            
            let mUserDefault = NSUserDefaults.standardUserDefaults()
            if(numInt==0){
                if var gwcs = mUserDefault.dictionaryForKey(UD_GWCS){
                    gwcs.removeValueForKey(id)
                    mUserDefault.setObject(gwcs, forKey: UD_GWCS)
                }
            }else{
                var gwcs = mUserDefault.dictionaryForKey(UD_GWCS)!
                var gwc = gwcs[id] as! Dictionary<NSObject,AnyObject>
                gwc["num"] = numInt
                gwcs[id] = gwc
                mUserDefault.setObject(gwcs, forKey: UD_GWCS)
            }
        }
    }

}

