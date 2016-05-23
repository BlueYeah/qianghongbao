//
//  ModDataViewController.swift
//  QianHongBao
//
//  Created by arkic on 16/3/2.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit

class ModDataViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var btnHeadImg: UIButton!
    
    @IBOutlet weak var tfName: UITextField!
    @IBAction func btnBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnImage(sender: AnyObject) {
        if(!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)){
            MyDialog.showErrorAlert(self, msg: "不能打开相册",completion: nil)
            return
        }
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let gotImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let midImage:UIImage = self.imageWithImageSimple(gotImage, scaledToSize: CGSizeMake(100, 100))

        self.btnHeadImg.setImage(midImage, forState: UIControlState.Normal)
        
        // 本地存储图片
        Common.saveIconImageToSandBox(gotImage, imageImageNmae: "iconImage.png")
        // 上传图片
        uploadImg(midImage)

        
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imageWithImageSimple(image:UIImage,scaledToSize size:CGSize)->UIImage{
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    func uploadImg(img:UIImage){
        let data = UIImagePNGRepresentation(img)
        let url = URL_UserHeadImage + "/uid/\(Common.getUid())"
        // 添加正在上传HUD
        let hud2 = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud2.label.text = "正在上传...."
        MyHttp.doUpload(url, filename: "photo2", fileData: data!){ (data, rep, error) in

            if (error != nil)
            {
            
                dispatch_async(dispatch_get_main_queue(), {
                    hud2.hideAnimated(true)
                    let hud1 = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud1.label.text = "上传失败"
                    hud1.hideAnimated(true, afterDelay: 1)
                    print("cuowu",error)
                    
                    
                })
                
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), { 
                // 隐藏HUD
                hud2.hideAnimated(true)
                
                // 上传成功
                let hud2 = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud2.label.text = "上传成功"
                hud2.hideAnimated(true, afterDelay: 0.5)
            })
            
        }
    
    }
    @IBAction func btnConfirm(sender: AnyObject) {
        let nackname = tfName.text!
        if(nackname == ""){
            MyDialog.showErrorAlert(self, msg: "数据不能为空",completion: nil)
            return
        }

        
        let data:Dictionary<String,AnyObject> = ["uid":Common.getUid(),"nackname":nackname]
        MyHttp.doPost(URL_UserModPwd, data: data) { (data, rep, error) in
            dispatch_sync(dispatch_get_main_queue(), {
                do{
                    var jobj = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! Dictionary<String,AnyObject>
                    let status = (jobj["status"] as! NSNumber).integerValue
                    if(status==0){
                        MyDialog.showErrorAlert(self, msg: jobj["info"] as! String,completion: nil)
                        return
                    }
                    
                    MyDialog.showSuccessAlert(self, msg: jobj["info"] as! String)
                    Common.setNickName(nackname)
                }catch{
                    MyDialog.showErrorAlert(self, msg: "未知错误",completion: nil)
                    return
                }
            })
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        tfName.text = Common.getNickName()

        let iconimage = Common.getImageFromSandBox()
        print("icon\(iconimage)")
        btnHeadImg.setBackgroundImage(iconimage, forState: UIControlState.Normal)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        
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
    
    @IBAction func tapAction(sender: AnyObject) {
        
        view.endEditing(true)
    }
    

}
