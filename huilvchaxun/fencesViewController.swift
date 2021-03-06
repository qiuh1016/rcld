//
//  gangkouViewController.swift
//  huilvchaxun
//
//  Created by qiuhong on 11/24/15.
//  Copyright © 2015 qiuhhong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
//import CoreData
import MJRefresh

class fencesViewController: UITableViewController {
    
    struct Fence {
        var fenceName: String = ""
        var fenceType: Int = 0
        var shipAmount: Int = 0
        var fenceNo: String = ""
        var fenceLevel: String = ""
    }
    
    var fenceNames = [""]
    var fenceIDs = [""]
    var fenceTypes = [""]
    var inShipsNums = [0]
    //var refreshTime: String?
    
    var fences = [Fence]()

    
    var isExpand = false
    var selectedIndexPath: NSIndexPath?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        //载入保存的数据（上次刷新的数据）
        loadData()
        
        //MJ refresh
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(fencesViewController.refreshData))
        tableView.mj_header.beginRefreshing()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func saveData(data: NSData){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(data, forKey: "fences")
        
//        defaults.setObject(self.fenceNames, forKey: "fenceNames")
//        defaults.setObject(self.fenceIDs, forKey: "fenceIDs")
//        defaults.setObject(self.fenceTypes, forKey: "fenceTypes")
//        defaults.setObject(self.inShipsNums, forKey: "inShipsNums")
//        defaults.setObject(self.strNowTime(), forKey: "refreshTime")
        
    }
    
    func loadData(){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let value = defaults.objectForKey("fences") {
            
            let data = JSON(data: value as! NSData)["data"]
            
            self.fences.removeAll()
            for i in 0 ..< data.count {
                var fence = Fence()
                fence.fenceName  = data[i]["fenceName"] .stringValue
                fence.fenceType  = data[i]["fenceType"] .intValue
                fence.fenceNo    = data[i]["fenceNo"]   .stringValue
                fence.shipAmount = data[i]["shipAmount"].intValue
                fence.fenceLevel = data[i]["fenceLevel"].stringValue
                self.fences.append(fence)
                
            }
            
        }
        
        
        //print(self.fences)
        
        
//        if let names = defaults.objectForKey("fenceNames"){
//            fenceNames = names as! [String]
//        }
//        if let IDs = defaults.objectForKey("fenceIDs"){
//            fenceIDs = IDs as! [String]
//        }
//        if let types = defaults.objectForKey("fenceTypes"){
//            fenceTypes = types as! [String]
//        }
//        if let nums = defaults.objectForKey("inShipsNums"){
//            inShipsNums = nums as! [Int]
//        }
//        if let time = defaults.objectForKey("refreshTime"){
//            refreshTime = time as? String
//        }
//        
//        //不确定读取的数据是否会出错，做个判断
//        let count = fenceNames.count
//        if fenceIDs.count != count || fenceTypes.count != count || inShipsNums.count != count{
//            fenceNames = [""]
//            fenceIDs = [""]
//            fenceTypes = [""]
//            inShipsNums = [0]
//        }
        
    }
    
    func refreshData(){
        
        let userName = NSUserDefaults.standardUserDefaults().valueForKey("userName")
        let password = NSUserDefaults.standardUserDefaults().valueForKey("password")
        let shipNo   = NSUserDefaults.standardUserDefaults().valueForKey("shipNo")
        
        var serverIP = NSUserDefaults.standardUserDefaults().stringForKey("serverIP")
        if serverIP == nil {
            serverIP = defaultServerIP_1
        }
        let url = "http://" + serverIP! + shipGetUrl
        
        Alamofire.request(.GET, url, parameters: ["userName": userName!, "password": password!, "shipNo": shipNo!]).responseData{
            response in
            
            switch response.result{
            case .Success:
                if let value = response.result.value{
                    
                    let data = JSON(data: value)["data"]
                    
                    print(data)
                    
                    
                    self.fences.removeAll()
                    for i in 0 ..< data.count {
                        var fence = Fence()
                        fence.fenceName  = data[i]["fenceName"] .stringValue
                        fence.fenceType  = data[i]["fenceType"] .intValue
                        fence.fenceNo    = data[i]["fenceNo"]   .stringValue
                        fence.shipAmount = data[i]["shipAmount"].intValue
                        fence.fenceLevel = data[i]["fenceLevel"].stringValue
                        self.fences.append(fence)
                    }
                                        
                    //DetailCell的相关属性设置
                    self.isExpand = false
                    self.selectedIndexPath = nil
                    
                    //重载tableView
                    self.tableView.reloadData()
                    
                    //保存数据
                    self.saveData(response.result.value!)
                    
                    //下拉刷新
                    self.tableView.mj_header.endRefreshing()
                }
            
                
            case .Failure:
                self.tableView.mj_header.endRefreshing()
                alertView("提示", message: "通信故障，无法获取数据!", okActionTitle: "好的", okHandler: nil, viewController: self)
            }
            
        }

    }
    
//    func strNowTime() -> String{
//        let date0 = NSDate()
//        let timeFormatter = NSDateFormatter()
//        timeFormatter.dateFormat = "YYYY-MM-dd HH:mm"
//        let strNowTime = timeFormatter.stringFromDate(date0) as String
//        return strNowTime
//    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isExpand{
            return fences.count + 1
        }
        return fences.count
        
        //        if isExpand{
//            return fenceNames.count + 1
//        }
//        return fenceNames.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if isExpand && selectedIndexPath?.row < indexPath.row && indexPath.row <= (selectedIndexPath?.row)! + 1{
            cell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath)
            let fenceIDLabel = cell.viewWithTag(1000) as! UILabel
            let inShipsLabel = cell.viewWithTag(1001) as! UILabel
            let fenceTypeLabel = cell.viewWithTag(1002) as! UILabel
            
            fenceIDLabel.text = fences[indexPath.row - 1].fenceNo
            inShipsLabel.text = "\(fences[indexPath.row - 1].shipAmount)"
            fenceTypeLabel.text = "\(fences[indexPath.row - 1].fenceLevel)"

            
//            fenceIDLabel.text = fenceIDs[indexPath.row - 1]
//            inShipsLabel.text = "\(inShipsNums[indexPath.row - 1])"
//            let fenceType = fenceTypes[indexPath.row - 1]
//            if fenceType == "1"{
//                fenceTypeLabel.text = "一级渔港"
//            }else if fenceType == "2"{
//                fenceTypeLabel.text = "二级渔港"
//            }else if fenceType == "未知"{
//                fenceTypeLabel.text = "未知"
//            }else{
//                fenceTypeLabel.text = "\(fenceType)级渔港"
//            }
        }else{
            cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            let nameLabel = cell.viewWithTag(1000) as! UILabel
            let boweiLabel = cell.viewWithTag(1001) as! UILabel
            
            let bowei = (fences[indexPath.row].shipAmount * 10)
            if fences[indexPath.row].fenceName != ""{
                nameLabel.text = "港口名：" + fences[indexPath.row].fenceName
                boweiLabel.text = "(泊位：\(bowei)%)"
            }else{
                nameLabel.text = ""
                boweiLabel.text = ""
            }
            
//            let bowei = (inShipsNums[indexPath.row] * 10)
//            if fenceNames[indexPath.row] != ""{
//                nameLabel.text = "港口名：" + fenceNames[indexPath.row]
//                boweiLabel.text = "(泊位：\(bowei)%)"
//            }else{
//                nameLabel.text = ""
//                boweiLabel.text = ""
//            }
        }
        return cell
    }
    
    //插入Detail Cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if selectedIndexPath == nil {
            selectedIndexPath = indexPath
            self.isExpand = true
            tableView.beginUpdates()
            tableView.insertRowsAtIndexPaths([indexPathsForExpandRow(indexPath.row)], withRowAnimation: UITableViewRowAnimation.Bottom)
            tableView.endUpdates()
        }else{
            if isExpand{
                if selectedIndexPath == indexPath{
                    isExpand = false
                    tableView.beginUpdates()
                    tableView.deleteRowsAtIndexPaths([indexPathsForExpandRow(indexPath.row)], withRowAnimation: .Fade)
                    tableView.endUpdates()
                    selectedIndexPath = nil
                }else{
                    isExpand = false
                    tableView.beginUpdates()
                    tableView.deleteRowsAtIndexPaths([indexPathsForExpandRow(selectedIndexPath!.row)], withRowAnimation: .Fade)
                    tableView.endUpdates()
                    selectedIndexPath = nil
                }
            }
        }
    }
    
    //插入Cell的indexPath
    func indexPathsForExpandRow(row: Int) -> NSIndexPath{
        return NSIndexPath(forItem: row + 1, inSection: 0)
    }
    
    //coreData 备用
//    func save(){
//        if let manageObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext{
//            fence = NSEntityDescription.insertNewObjectForEntityForName("Fence", inManagedObjectContext: manageObjectContext) as! Fence
//            fence.fenceName = "\(score)"
//            kaoshichengji.answers = answers
//            let dateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
//            let date = dateFormatter.stringFromDate(NSDate())
//            kaoshichengji.date = date
//            print("****score \(score)")
//            print("****anseers \(answers)")
//            print("****date \(date)")
//            
//            do{
//                try manageObjectContext.save()
//                print("*****save succeed!*******")
//            }catch{
//                print(error)
//            }
//        }
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
