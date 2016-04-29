//
//  MessageItem.swift
//  QianHongBao
//
//  Created by arkic on 16/1/10.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit

enum ChatType{
    case Text
    case Image
    case Voice
    case Video
    case CDS//猜单双红包
    case SJHB//随机红包
}
enum  ChatCellName:String{
    case TextCell = "textcell"
    case ImageCell = "imagecell"
    case VoiceCell = "voicecell"
    case AudioCell = "audiocell"
    case CDSCell = "cdscell"
    case SJHBCell = "sjhbcell"
}
class MessageItem{
    var time:NSDate
    var uid:Int
    var headImg:String
    var type:ChatType
    var content:String
    var name:String
    var bonusId: Int?
    var dsBonus: DSBonus?
    
    
    init(uid:Int,type:ChatType,name:String,headImg:String,content:String,bonusId:Int?,dsBonus:DSBonus?){
        self.uid = uid
        self.type = type
        self.headImg = headImg
        self.name = name
        self.content = content
        self.time = NSDate()
        self.bonusId = bonusId
        self.dsBonus = dsBonus
    }
}

