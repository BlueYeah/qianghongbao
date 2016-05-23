//
//  MFCollectionViewFlowLayout.swift
//  NewFeatuesDemo
//
//  Created by 梁渭 on 16/3/31.
//  Copyright © 2016年 mofa. All rights reserved.
//

//在这个类里面对CollectionView 的item进行布局

import UIKit

class MFCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    //准备布局
    override func prepareLayout() {
        
        //1.设置layout布局
        itemSize = UIScreen.mainScreen().bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .Horizontal
        
        //2.设置collectionView的属性
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.pagingEnabled = true
    }

}
