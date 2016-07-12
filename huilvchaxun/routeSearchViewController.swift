//
//  guijijiluViewController.swift
//  huilvchaxun
//
//  Created by qiuhong on 11/24/15.
//  Copyright © 2015 qiuhhong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class routeSearchViewController: UIViewController, DatePickViewControllerDelegate {
    
    @IBOutlet weak var datePicker1: UIDatePicker!
    @IBOutlet weak var datePicker2: UIDatePicker!

    @IBOutlet weak var datePickButton1: UIButton!
    @IBOutlet weak var datePickButton2: UIButton!
    
    var datePickButtonNum = 0
    
    var startTime = ""
    var endTime = ""

    var cllocation = [CLLocationCoordinate2D]()
    
    @IBOutlet weak var showMiddlePointSwitch: UISwitch!
    
    @IBAction func showDatePicker(sender: AnyObject) {
        if sender as! UIButton == datePickButton1{
            datePickButtonNum = 1
        }else if sender as! UIButton == datePickButton2{
            datePickButtonNum = 2
        }
        performSegueWithIdentifier("showDatePickerSegue", sender: nil)
    }
    
    @IBAction func buttonTapped() {
        if startTime == "" || endTime == ""{
            alertView("提示", message: "请选择正确的时间!", okActionTitle: "好的", okHandler: nil, viewController: self)
            return
        }
        if startTime == endTime{
            alertView("提示", message: "起始时间请勿等于结束时间!", okActionTitle: "好的", okHandler: nil, viewController: self)
            return
        }
        
        getRoute()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showGuijiSegue"{
            let viewController = segue.destinationViewController as! routeDisplayViewController
            viewController.timeText1 = startTime
            viewController.timeText2 = endTime
            //纠偏
            viewController.cllocation = realLocation(cllocation)
            viewController.showMiddleAnnotation = showMiddlePointSwitch.on
        }else if segue.identifier == "showDatePickerSegue"{
            let viewController = segue.destinationViewController as! DatePickViewController
            viewController.delegate = self
        }
    }
    
    func datePickDidFinished(controller: DatePickViewController, didFinishedPickDate date: String) {
        if datePickButtonNum == 1{
            startTime = date
            datePickButton1.setTitle(startTime, forState: .Normal)
            dismissViewControllerAnimated(true, completion: nil)
        }else if datePickButtonNum == 2 {
            endTime = date
            datePickButton2.setTitle(endTime, forState: .Normal)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //获取轨迹点
    func getRoute(){
        
        let hudView = HudView.hudInView(self.view, animated: false)
        hudView.text = "获取中"
        
        let userName = NSUserDefaults.standardUserDefaults().valueForKey("userName")
        let password = NSUserDefaults.standardUserDefaults().valueForKey("password")
        
        Alamofire.request(.GET, httpBodyURL + httpGetTrailURL, parameters: ["userName": userName!, "password": password!, "startTime": startTime.URLString, "endTime": endTime.URLString]).responseJSON { response in
            switch response.result {
            case .Success:
                
                let json = JSON(response.result.value!)
                
                if json["msg"] == "没有符合条件的数据" {
                    hudView.hideAnimated(self.view, animated: false)
                    alertView("提示", message: "此时间段内无轨迹!", okActionTitle: "好的", okHandler: nil, viewController: self)
                } else if json["msg"] == "成功"{
                    let data = json["data"]
                    
                    for i in 0 ..< data.count {
                        let locationCoordinate2D = CLLocationCoordinate2DMake(Double(data[i]["latitude"].stringValue)!, Double(data[i]["longitude"].stringValue)!)
                        self.cllocation.append(locationCoordinate2D)
                    }
                    
                    //switch operation
                    if data.count > 1000 && self.showMiddlePointSwitch.on{
                        self.showMiddlePointSwitch.setOn(false, animated: true)
                    }
                    
                    //hudview operation
                    hudView.hideAnimated(self.view, animated: false)
                    let okView = OKView.hudInView(self.view, animated: false)
                    okView.text = "获取成功"
                    afterDelay(0.5){
                        okView.hideAnimated(self.view, animated: false)
                        self.performSegueWithIdentifier("showGuijiSegue", sender: nil)
                    }
                }
                
            case .Failure(let error):
                print(error)
                hudView.hideAnimated(self.view, animated: false)
                alertView("提示", message: "通信故障，无法获取数据!", okActionTitle: "好的", okHandler: nil, viewController: self)
                
            }
        }
        
//        Alamofire.request(.GET, "").validate().responseData{
//            response in
//            
//            switch response.result{
//            case .Success:
//                if let value = response.result.value{
//                    //先把获取到的Data用UTF8解码为string，然后把单引号换成双引号，在用UTF8编码
//                    let str = NSString(data: value, encoding: NSUTF8StringEncoding)
//                    let valueShuangyinhao = str!.stringByReplacingOccurrencesOfString("'", withString: "\"") as NSString
//                    let nsDatajson = valueShuangyinhao.dataUsingEncoding(NSUTF8StringEncoding)
//                    
//                    //将Data转换为JSON 用SwiftyJSON库
//                    let json = JSON(data: nsDatajson!)
//                    let count = json.count
//                    if count == 0{
//                        hudView.hideAnimated(self.view, animated: false)
//                        alertView("提示", message: "此时间段内无轨迹!", okActionTitle: "好的", okHandler: nil, viewController: self)
//                    }else{
//                        var i = 0
//                        self.cllocation.removeAll()
//                        while i < count{
//                            self.weizhi.longitude = (json[i]["longitude"].stringValue as NSString).doubleValue
//                            self.weizhi.latitude = (json[i]["latitude"].stringValue as NSString).doubleValue
//                            self.cllocation.append(self.weizhi)
//                            i += 1
//                        }
//                        
//                        if count > 1000 && self.showMiddlePointSwitch.on{
//                            self.showMiddlePointSwitch.setOn(false, animated: true)
//                        }
//                        
//                        hudView.hideAnimated(self.view, animated: false)
//                        
//                        let okView = OKView.hudInView(self.view, animated: false)
//                        okView.text = "获取成功"
//                        afterDelay(0.5){
//                            okView.hideAnimated(self.view, animated: false)
//                            self.performSegueWithIdentifier("showGuijiSegue", sender: nil)
//                        }
//                    }
//                    
//                }
//            case .Failure:
//                hudView.hideAnimated(self.view, animated: false)
//                alertView("提示", message: "通信故障，无法获取数据!", okActionTitle: "好的", okHandler: nil, viewController: self)
//            }
//        }
        
    }

    
}
