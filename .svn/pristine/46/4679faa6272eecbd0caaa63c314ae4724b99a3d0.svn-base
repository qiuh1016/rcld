//
//  showStaffViewController.swift
//  huilvchaxun
//
//  Created by qiuhong on 11/27/15.
//  Copyright © 2015 qiuhhong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AudioToolbox
import MJRefresh

class iofViewController: UITableViewController {

 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadData()
        
//        //MJ refresh
//        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
//            self.refreshData()
//        })
//        tableView.mj_header.beginRefreshing()
//        
//        //tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: "refreshData")
//        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(iofViewController.refreshData))
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(iofViewController.refreshData))
        tableView.mj_header.beginRefreshing()

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        
    }
    

    func refreshData(){

        let userName = NSUserDefaults.standardUserDefaults().valueForKey("userName")
        let password = NSUserDefaults.standardUserDefaults().valueForKey("password")
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
        let endTime = timeFormatter.stringFromDate(NSDate())
        //TODO: 正式版改回来
        //let startTime = timeFormatter.stringFromDate(NSDate().dateByAddingTimeInterval(-5 * 60 * 60))
        let startTime = "2016/01/01 00:00:00"
        
        Alamofire.request(.GET, httpBodyURL + httpGetiofURL, parameters: ["userName": userName!, "password": password!, "startTime": startTime, "endTime": endTime], encoding: .URLEncodedInURL).responseJSON{
            response in
            
            switch response.result{
            case .Success:
                if let value = response.result.value{
                    let json = JSON(value)
                    print(json)
                    //重载tableView
                    self.tableView.reloadData()
                    
                    //保存数据
                    //self.saveData()
                    
                    //下拉刷新
                    self.tableView.mj_header.endRefreshing()
                    
                }
                
            case .Failure:
                self.tableView.mj_header.endRefreshing()
                alertView("提示", message: "通信故障，无法获取数据!", okActionTitle: "好的", okHandler: nil, viewController: self)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return staffNames.count
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell")
        let fenceNameLabel = cell?.viewWithTag(1000) as! UILabel
        let outTimeLabel = cell?.viewWithTag(1001) as! UILabel
        let backTimeLabel = cell?.viewWithTag(1002) as! UILabel
        switch indexPath.row{
        case 0:
            fenceNameLabel.text = "象山石浦停泊港 - "
            outTimeLabel.text = "2015.12.19 06:28"
            backTimeLabel.text = "-"
        case 1:
            fenceNameLabel.text = "舟山临城停泊港 - 象山石浦停泊港"
            outTimeLabel.text = "2015.12.14 07:51"
            backTimeLabel.text = "2015.12.14 18:17"
        case 2:
            fenceNameLabel.text = "宁波停泊港 - 舟山临城停泊港"
            outTimeLabel.text = "2015.12.11 09:13"
            backTimeLabel.text = "2015.12.11 15:30"
        default:
            break
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        performSegueWithIdentifier("ShowDetail", sender: indexPath)
        performSegueWithIdentifier("outDetailSegue", sender: indexPath) 
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    }
    
}
