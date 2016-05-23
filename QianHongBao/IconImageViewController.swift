//
//  IconImageViewController.swift
//  DDExpress
//
//  Created by 梁渭 on 16/4/24.
//  Copyright © 2016年 mofa. All rights reserved.
//

import UIKit


class IconImageViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var iconImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //   加载图片
        
        iconImage.image = Common.getImageFromSandBox()

    }


    
    
    //从沙盒中取出头像
    func getImageFromSandBox() -> UIImage{
        
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last
        let saveIconImagePath = path! + "/iconImage.png"
        let saveIconImage = UIImage.init(contentsOfFile: saveIconImagePath) ?? UIImage(named: "200872493550274_2")
        
        return saveIconImage!
    }
    
    @IBAction func changeIcon(sender: AnyObject) {
        print("更换头像")
        chnageIconAlertSheetShow()
        
    }

    //更换头像的alert
    func chnageIconAlertSheetShow(){
        
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let changeImageAction = UIAlertAction(title: "从手机相册选择", style: .Default) { (action) in
            print("从手机相册选择")
            
            if(!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)){
                MyDialog.showErrorAlert(self, msg: "不能打开相册",completion: nil)
                return
            }

            let imagePicker = UIImagePickerController()
            
            imagePicker.sourceType = .PhotoLibrary
            
            imagePicker.allowsEditing = true
            
            imagePicker.delegate = self
            
           self.presentViewController(imagePicker, animated: true, completion: nil)
            


        }

        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        
        alertVC.addAction(changeImageAction)

        alertVC.addAction(cancelAction)
        
        presentViewController(alertVC, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let gotImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let midImage:UIImage = self.imageWithImageSimple(gotImage, scaledToSize: CGSizeMake(100, 100))

        uploadImg(midImage)
        
        self.iconImage.image = gotImage
        
        
        
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
                
                Common.saveIconImageToSandBox(self.iconImage.image!, imageImageNmae: "iconImage.png")
            })
            
        }
        
    }
    
    @IBAction func backBtn(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}



