//
//  NewFeatueCell.swift
//  NewFeatuesDemo
//
//  Created by 梁渭 on 16/3/31.
//  Copyright © 2016年 mofa. All rights reserved.
//

import UIKit
import SnapKit


class NewFeatueCell: UICollectionViewCell {
    
   //MARK: - 懒加载
   lazy var imageView = UIImageView()
    lazy var button: UIButton = {
        
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "new_feature_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "new_feature_button_highlighted"), forState: UIControlState.Highlighted)
        
        btn.hidden = true
        //注意，这里按钮添加action，self是cell，cell并没有处理能力，要控制器才有
        btn.addTarget(self, action: #selector(NewFeatueCell.customBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    
    }()
    
    func customBtnClick(){
        print("新特性按钮点击，进入登录页面")
//        //进入登录页面 修改window的根控制器一般在appdelegate里，所以这里post个通知
//        NSNotificationCenter.defaultCenter().postNotificationName("switchToLoginVC", object: nil)
        let st = self.window?.rootViewController?.storyboard
        let vc = st!.instantiateViewControllerWithIdentifier("loginVC") as UIViewController
        self.window?.rootViewController = vc
    }
    
    
    //设置cell的页面UI
    private func setupUI(){
    
        //1.在cell里面添加子控件，注意要添加到contentView里面
        contentView.addSubview(imageView)
        contentView.addSubview(button)
        
        //2.布局子控件
        let padding = UIEdgeInsetsMake(0, 0, 0, 0)
        
        imageView.snp_makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(padding)
        }
        
       // let width =
        
        button.snp_makeConstraints { (make) in
            make.bottom.equalTo(-130)
            //一个坑，设置中心点x跟父控件一样时，不用说super.center.x，直接equalTo(super)
            make.centerX.equalTo(contentView)
            print(contentView.center
                .x)
           // make.size.equalTo(CGSizeMake(width, 50))
            
        }
        print(button.center.x)
        
        
      
    }
    
    //初始化的时候设置UI
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //1.初始化UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    //保存图片的索引
     var imageInndex: Int?{
        
        didSet{
            imageView.image = UIImage(named: "new_feature_\(imageInndex! + 1)")        }
    }
    
    //按钮做动画
    func startAnimation(){
        
        button.hidden = false
        
        button.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        button.userInteractionEnabled = false
        
        UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { 
             self.button.transform = CGAffineTransformIdentity
            }) { (_) in
                self.button.userInteractionEnabled = true
        }
    }
    
    
    
}
