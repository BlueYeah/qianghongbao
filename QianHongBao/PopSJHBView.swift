//
//  PopSJHBView.swift
//  QianHongBao
//
//  Created by arkic on 16/1/16.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit

class PopSJHBView{

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var strongSelf:PopSJHBView!
    var view:UIView?
    init(){
        self.strongSelf = self
    }
    func show(vc:UIViewController){
        view = initLayer(vc.view.frame.width, height: vc.view.frame.height)
        
        vc.view.addSubview(view!)
        vc.view.bringSubviewToFront(view!)
    }
    func hide(){
        print("hiden", terminator: "")
        view?.removeFromSuperview()

    }
    func hideAction(sender:AnyObject){
        print("hideaction")
//        hide()
    }
    private func initLayer(width:CGFloat,height:CGFloat)->UIView{
        let bgView = UIView(frame: CGRectMake(0, 0, width, height))
        bgView.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.5)
        return bgView
    }

}
