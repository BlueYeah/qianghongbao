//
//  JLSliderView.swift
//  QianHongBao
//
//  Created by arkic on 16/1/14.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit

class JLSliderView: UIView,UIScrollViewDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var images:[String]!
    var WIDTH:CGFloat!
    var HEIGHT:CGFloat!
    var sliderScrollView:UIScrollView!
    var sliderPageControl:UIPageControl!
    var timer:NSTimer!
    
    func initSlider(images:[String]){
        self.images = images
        WIDTH = self.frame.width
        HEIGHT = self.frame.height
        initScrollView()
        initPageControl()
        initImages()
        startTimer()
    }
    func nextPage(sender:AnyObject){
        var cur = sliderPageControl.currentPage
        cur += 1
        sliderScrollView.contentOffset = CGPointMake(CGFloat(cur) * WIDTH, 0)
        if cur < images.count-1{
            sliderPageControl.currentPage = cur
        }else{
            sliderPageControl.currentPage = 0
        }
    }
    func startTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(JLSliderView.nextPage(_:)), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    func removeTimer(){
        self.timer.invalidate()
    }
    func initImages(){
        images.append(images[0])
        var x:CGFloat = 0
        let y=CGFloat(0)
        var mImageView:UIImageView!
        let img = UIImage(named: IMG_LOADING)
        for(i,_) in images.enumerate(){
            mImageView = UIImageView(frame: CGRectMake(x, y, WIDTH, HEIGHT))
//            mImageView.image = UIImage(named: images[i])
            mImageView.sd_setImageWithURL(NSURL(string: images[i]), placeholderImage: img)
            sliderScrollView.addSubview(mImageView)
            x += WIDTH
        }
        sliderScrollView.contentSize = CGSizeMake(x, HEIGHT)
    }
    func initScrollView(){
        sliderScrollView = UIScrollView(frame: CGRectMake(0, 0, WIDTH, HEIGHT))
        sliderScrollView.pagingEnabled = true
        sliderScrollView.showsHorizontalScrollIndicator = false
        sliderScrollView.delegate = self
        addSubview(sliderScrollView)
    }
    func initPageControl(){
        sliderPageControl = UIPageControl(frame: CGRectMake(0, HEIGHT-45, WIDTH, 35))
        sliderPageControl.numberOfPages = images.count
        sliderPageControl.currentPage = 0
        addSubview(sliderPageControl)
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        removeTimer()
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }

}
