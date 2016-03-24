//
//  ThreeViewController.swift
//  QianHongBao
//
//  Created by arkic on 16/1/10.
//  Copyright (c) 2016年 arkic. All rights reserved.
//

import UIKit

class ThreeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let FriendsListCell="friendslistcell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(FriendsListCell, forIndexPath: indexPath) as UITableViewCell
        
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            let controller = storyboard!.instantiateViewControllerWithIdentifier("chatViewController") as UIViewController
            presentViewController(controller, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
