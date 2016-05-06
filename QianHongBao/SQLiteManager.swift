//
//  SQLiteManager.swift
//  07-FMDB基本使用
//
//  Created by 李南江 on 15/9/20.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

import Foundation
import FMDB

class SQLiteManager {
    
    private static let instance = SQLiteManager()
    class var sharedSQLiteManager: SQLiteManager { return instance }
    
    // 数据库对象
    var queue: FMDatabaseQueue?
    
    func openDB(dbName: String) {
        
        let path = dbName.documentDir()
        
        print(path)

        // 实例化数据库对象
        queue = FMDatabaseQueue(path: path)
        
        createTable()
    }
    
    ///  创建数据表
    private func createTable() {
        let path = NSBundle.mainBundle().pathForResource("tables.sql", ofType: nil)!
        let sql = try! String(contentsOfFile: path)
        
        // 提示：在 FMDB 中，除了查询，其他一律使用 executeUpdate
        queue?.inDatabase({ (db) -> Void in
            if db!.executeUpdate(sql) {
                print("建表成功")
            } else {
                print("建表失败")
            }
        })
    }
}