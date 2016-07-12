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

class punchViewController: UITableViewController, reasonViewControllerDelegate {
    
//    struct Punch {
//        var sailorIdNo: String = ""
//        var punchTime: String = ""
//        var sailorName: String = ""
//        var deviceNo: String = ""
//        var iofFlag: Int = 1
//        var dataType: Int = 0
//        var reason: String?
//    }
    
    var punchs        = [Punch]()
    var punchsAdded   = [Punch]()
    var punchsDeleted = [Punch]()
    
    var detailViewReasonHeadLabelText = ""
    
    var iofFlag = Int()  // 1 出海  2 回港
    
    @IBOutlet weak var viewTitle: UINavigationItem!
    
    @IBAction func okBarButtonTapped(sender: AnyObject) {
        //TODO: 确认功能
        let okHandler = {(action: UIAlertAction!) -> Void in
            alertView("提示", message: "已成功提交出海名单！", okActionTitle: "好的", okHandler: nil, viewController: self)
        }
        
        alertView("确认提交名单？", message: "xxx:330283198812340134\nxxx:330283198812340134\nxxx:330283198812340134\nxxx:330283198812340134\nxxx:330283198812340134\nxxx:330283198812340134\nxxx:330283198812340134\n\n共7人", okActionTitle: "提交", cancleActionTitle: "取消", okHandler: okHandler, viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        if iofFlag == 1 {
            viewTitle.title = "出海确认"
        } else if iofFlag == 2 {
            viewTitle.title = "回港确认"
        }
        
        //MJ refresh
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(punchViewController.confirmToRefresh))
        tableView.mj_header.beginRefreshing()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func confirmToRefresh() {
        if punchsAdded.count == 0 && punchsDeleted.count == 0 {
            refreshData()
        } else {
            let okHandler = { (action: UIAlertAction!) -> Void in
                self.refreshData()
            }
            let cancelHandler = { (action: UIAlertAction!) -> Void in
                self.tableView.mj_header.endRefreshing()
            }
            
            let alert = UIAlertController(title: "是否继续", message: "刷新数据将清除所有已完成的添加和删除操作！", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "否", style: UIAlertActionStyle.Cancel, handler: cancelHandler)
            let okAction = UIAlertAction(title: "是", style: UIAlertActionStyle.Destructive, handler: okHandler)
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
//            alertView("是否继续", message: "刷新数据将清除所有已完成的添加和删除操作！", okActionTitle: "是", cancleActionTitle: "否", okHandler: okHandler, viewController: self)
        }
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

        Alamofire.request(.GET, httpBodyURL + httpGetPunchURL, parameters: ["userName": userName!, "password": password!, "startTime": startTime, "endTime": endTime], encoding: .URLEncodedInURL).responseJSON{
            response in
            
            switch response.result{
            case .Success:
                if let value = response.result.value{
                    
                    let json = JSON(value) as JSON
                    
                    if json["code"] == 0 {
                        let data = json["data"]
                        self.punchs.removeAll()
                        self.punchsAdded.removeAll()
                        self.punchsDeleted.removeAll()
                        for i in 0 ..< data.count {
                            let punch = Punch()
                            punch.sailorIdNo = data[i]["sailorIdNo"].stringValue
                            punch.punchTime  = data[i]["punchTime"] .stringValue
                            punch.sailorName = data[i]["sailorName"].stringValue
                            punch.deviceNo   = data[i]["deviceNo"]  .stringValue
                            punch.dataType   = 0
                            punch.iofFlag    = self.iofFlag
                            
                            self.punchs.append(punch)
                        }
                        
                        //重载tableView
                        self.tableView.reloadData()
                        
                    } else {
                        let msg = json["msg"].stringValue
                        alertView("提示", message: msg, okActionTitle: "好的", okHandler: nil, viewController: self)
                    }
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
    
    
    func strNowTime() -> String{
        let date0 = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let strNowTime = timeFormatter.stringFromDate(date0) as String
        return strNowTime
    }
    
    
    // MARK: - reasonView delegate
    func punchHasConfirmToAdd(punchAdded: Punch, viewController: UIViewController) {
        dismissViewControllerAnimated(true, completion: nil)
        punchAdded.iofFlag = self.iofFlag
        punchsAdded.append(punchAdded)
        tableView.reloadData()
    }
    
    func punchHasConfirmToDelete(deleteReason: String, viewController: UIViewController) {
        dismissViewControllerAnimated(true, completion: nil)
        punchsDeleted.append(punchs[deletePunchIndexPath.row])
        punchs.removeAtIndex(deletePunchIndexPath.row)
        punchsDeleted.last?.reason = deleteReason
        
        tableView.reloadData()
        
    }
    
    // MARK: - TableView DataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        var numberOfSectionsInTableView = 0
//        if punchsAdded.count != 0 {
//            numberOfSectionsInTableView += 1
//        }
//        if punchs.count != 0 {
//            numberOfSectionsInTableView += 1
//        }
//        return numberOfSectionsInTableView
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return punchs.count
        case 1:
            return punchsAdded.count
        case 2:
            return punchsDeleted.count
        default:
            break
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell1", forIndexPath: indexPath)
        let staffNameLabel = cell.viewWithTag(1000) as! UILabel
        let staffIDLabel = cell.viewWithTag(1001) as! UILabel
        let dateTimeLabel = cell.viewWithTag(1002) as! UILabel
        let imageView = cell.viewWithTag(1003) as! UIImageView
        
        switch indexPath.section {
        case 0:
            staffNameLabel.text = punchs[indexPath.row].sailorName
            staffIDLabel.text = punchs[indexPath.row].sailorIdNo
            dateTimeLabel.text = punchs[indexPath.row].punchTime
            if maleOrFemale(punchs[indexPath.row].sailorIdNo) == "男"{
                imageView.image = UIImage(named: "user62")
            }else if maleOrFemale(punchs[indexPath.row].sailorIdNo) == "女"{
                imageView.image = UIImage(named: "user63")
            }else{
                imageView.image = nil
            }
        case 1:
            staffNameLabel.text = punchsAdded[indexPath.row].sailorName
            staffIDLabel.text = punchsAdded[indexPath.row].sailorIdNo
            dateTimeLabel.text = "手动添加"
            if maleOrFemale(punchsAdded[indexPath.row].sailorIdNo) == "男"{
                imageView.image = UIImage(named: "user62")
            }else if maleOrFemale(punchsAdded[indexPath.row].sailorIdNo) == "女"{
                imageView.image = UIImage(named: "user63")
            }else{
                imageView.image = nil
            }
        case 2:
            staffNameLabel.text = punchsDeleted[indexPath.row].sailorName
            staffIDLabel.text = punchsDeleted[indexPath.row].sailorIdNo
            dateTimeLabel.text = punchsDeleted[indexPath.row].punchTime
            if maleOrFemale(punchsDeleted[indexPath.row].sailorIdNo) == "男"{
                imageView.image = UIImage(named: "user62")
            }else if maleOrFemale(punchsDeleted[indexPath.row].sailorIdNo) == "女"{
                imageView.image = UIImage(named: "user63")
            }else{
                imageView.image = nil
            }
        default:
            break
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            if punchs.count != 0 {
                return "自动生成"
            }
        case 1:
            if punchsAdded.count != 0 {
                return "手动添加"
            }
        case 2:
            if punchsDeleted.count != 0 {
                return "已删除"
            }
        default:
            break
        }
        return nil
    }
    
    // MARK: - TableView Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case 0:
            detailViewReasonHeadLabelText = ""
            performSegueWithIdentifier("ShowDetail", sender: punchs[indexPath.row])
        case 1:
            detailViewReasonHeadLabelText = "添加原因："
            performSegueWithIdentifier("ShowDetail", sender: punchsAdded[indexPath.row])
        case 2:
            detailViewReasonHeadLabelText = "删除原因："
            performSegueWithIdentifier("ShowDetail", sender: punchsDeleted[indexPath.row])
        default:
            break
        }
    }
    
    var deletePunchIndexPath: NSIndexPath!
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.section {
        case 0:
            deletePunchIndexPath = indexPath
            performSegueWithIdentifier("deletePunchSegue", sender: punchs[indexPath.row])
        case 1:
            punchsAdded.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            if punchsDeleted.count == 0 {
                tableView.reloadData()
            }
        case 2:
            punchs.append(punchsDeleted[indexPath.row])
            punchs.last?.reason = nil
            punchsDeleted.removeAtIndex(indexPath.row)
            tableView.reloadData()
            break
        default:
            break
        }
        
    }
    

    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail"{
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.punch = sender as! Punch
            detailViewController.detailViewReasonHeadLabelText = self.detailViewReasonHeadLabelText
            
        } else if segue.identifier == "addPunchSegue" {
            let vc = segue.destinationViewController as! reasonViewController
            vc.delegate = self
            vc.punchs = punchs
            vc.punchs.appendContentsOf(punchsAdded)
            vc.punchs.appendContentsOf(punchsDeleted)//验证身份证是否存在
        } else if segue.identifier == "deletePunchSegue" {
            let vc = segue.destinationViewController as! reasonViewController
            let punchToDelete = sender as! Punch
            vc.delegate = self
            vc.punchToDelete = punchToDelete
        }
    }
    
    func maleOrFemale(staffID: String) -> String{
        if staffID.characters.count == 18{
            let genderString = (staffID as NSString).substringWithRange(NSMakeRange(16, 1))
            let genderNumber = Int(genderString)
            if let genderNumber = genderNumber {
                if genderNumber % 2 == 0{
                    return "女"
                }else{
                    return "男"
                }
            }else{
                return "未知"
            }
        }else{
            return "未知"
        }
    }
    
}
