//
//  NewFeatueCollectionVC.swift
//  NewFeatuesDemo
//
//  Created by 梁渭 on 16/3/31.
//  Copyright © 2016年 mofa. All rights reserved.
//

import UIKit
import SnapKit

private let reuseIdentifier = "Cell"

class NewFeatueCollectionVC: UICollectionViewController {
    
    
    //界面的页数
    private let  pageCount = 3
    private var layout: UICollectionViewLayout = MFCollectionViewFlowLayout()
    var pageControl = UIPageControl.init(frame: CGRectMake(0, 0, 100, 30))
    
    
    /*
     ****************纯代码创建，设置layout****************
     
     // 因为系统指定的初始化构造方法是带参数的(collectionViewLayout), 而不是不带参数的, 所以不用写override
     init(){
     super.init(collectionViewLayout: layout)
     }
     
     required init?(coder aDecoder: NSCoder) {
     fatalError("init(coder:) has not been implemented")
     }
     
     */
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //设置VIewLayout，有storyboard的就是这样设置，没有，就是初始化collcetionView的时候设置
        collectionView?.collectionViewLayout = layout
        self.collectionView!.registerClass(NewFeatueCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.view.addSubview(pageControl)
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor.redColor()
        pageControl.pageIndicatorTintColor = UIColor.blueColor()
        pageControl.snp_makeConstraints { [weak self](make) in
            make.centerX.equalTo(self!.view)
            make.bottom.equalTo(-60)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: UICollectionViewDataSource
    
    
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return pageCount
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewFeatueCell
        
        //在CollectionView里面不是row,是item
        cell.imageInndex = indexPath.item
        if indexPath.item != (pageCount - 1){
            cell.button.hidden = true
        }
        // pageIndex = indexPath.item
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        //传递给我们的是上一页的索引
        print(indexPath)
        
        //1.拿到当前显示的cell对应的索引
        let  path = collectionView.indexPathsForVisibleItems().last!
        print(path)
        // pageIndex = path.item
        if path.item == (pageCount - 1){
            //2.拿到当前索引对应的cell
            let cell = collectionView.cellForItemAtIndexPath(path) as! NewFeatueCell
            
            //3.让cell执行动画
            cell.startAnimation()
        }
        
        
    }
    
    
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        //print("kkkkkkkkk")
        let page = (Int) (scrollView.contentOffset.x/scrollView.frame.size.width+0.5) % 4
        pageControl.currentPage = page
    }
    
    
    
    
    
}
