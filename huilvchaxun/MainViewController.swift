//
//  MainViewController.swift
//  huilvchaxun
//
//  Created by qiuhong on 11/24/15.
//  Copyright © 2015 qiuhhong. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON
import Alamofire
import Just

class MainViewController: UIViewController{

    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBAction func myShipButtonTapped() {
        if NSUserDefaults.standardUserDefaults().boolForKey("hasLogin"){
            performSegueWithIdentifier("myShipSegue", sender: nil)
        }else{
            showLoginView()
        }
    }
    
    @IBAction func routeSearchButtonTapped() {
        if NSUserDefaults.standardUserDefaults().boolForKey("hasLogin"){
            performSegueWithIdentifier("routeSearchSegue", sender: nil)
        }else{
            showLoginView()
        }
    }
    @IBAction func fenceButtonTapped(sender: AnyObject) {
        
        if NSUserDefaults.standardUserDefaults().boolForKey("hasLogin"){
            performSegueWithIdentifier("showFenceInfoSegue", sender: nil)
        }else{
            showLoginView()
        }
    }
    
    func showLoginView(){
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func logout(barButtonItem: UIBarButtonItem) {
        let okHandler = {(action:UIAlertAction!) -> Void in
            let hudView = HudView.hudInView(self.view, animated: false)
            hudView.text = "退出中"
            afterDelay(1.0){
                hudView.hideAnimated(self.view, animated: false)

                let okView = OKView.hudInView(self.view, animated: false)
                okView.text = "已退出"
                afterDelay(0.5){
                    okView.hideAnimated(self.view, animated: false)
//                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.showLoginView()
                }
            }
        }
        alertView("提示", message: "即将退出系统，是否继续?", okActionTitle: "退出", cancleActionTitle: "取消", okHandler: okHandler, viewController: self)
    }
    
    struct Sailor {
        var sailorIdNo: String = ""
        var sailorName: String = ""
        var dataType = 1
        var reason = ""
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        //设置导航按钮
        self.navigationController?.navigationBar.translucent = false
        
//        let leftItemButton = UIBarButtonItem.init(image: UIImage(named: "qrcode1"), style: .Plain, target: self, action: #selector(MainViewController.QRCode(_:)))
//        self.navigationItem.leftBarButtonItem = leftItemButton
        
//        let rightItemButton = UIBarButtonItem.init(image: UIImage(named: "setting"), style: .Plain, target: self, action: #selector(MainViewController.userMenu(_:)))
        let rightItemButton = UIBarButtonItem.init(title: "退出", style: .Plain, target: self, action: #selector(MainViewController.logout(_:)))
        self.navigationItem.rightBarButtonItem = rightItemButton
        
        
        
        
        
        //
//        let md5_str = md5("123")
//        let bs = base64Encode("123".md5())
//        if B64_md5("123")=="MjAyY2I5NjJhYzU5MDc1Yjk2NGIwNzE1MmQyMzRiNzA=" {
//            print("e")
//        } else {
//            print(" n  e")
//        }
//        print(B64_md5("123"))
        
        
        //test
        
        //ioConfirm test
//        var sailor1: Sailor = Sailor.init(sailorIdNo: "330283198811240134", sailorName: "测试ios", dataType: 1, reason: "test")
//        var sailor2: Sailor = Sailor.init(sailorIdNo: "330283198811240131", sailorName: "测试ios", dataType: 1, reason: "test")
//        var sailors = [Sailor]()
//        sailors.append(sailor1)
//        sailors.append(sailor2)
//        
//        var str = ""
//        
//        for sailor in sailors {
//            let sailorString = "{\"sailorIdNo\":\"\(sailor.sailorIdNo)\",\"sailorName\":\"\(sailor.sailorName)\",\"dataType\":\(sailor.dataType),\"reason\":\"\(sailor.reason)\"}"
//            if str == "" {
//                str += "[" + sailorString
//            } else {
//                str += "," + sailorString
//            }
//        }
//        
//        str += "]"
//        
//        print(str)
//        
//        let sailors11 = "[{\"sailorIdNo\":\"330283198811240134\",\"sailorName\":\"测试人员\",\"dataType\":1,\"reason\":\"添加原因\"}]"
////
//        Alamofire.request(.POST, "http://114.55.101.20/api/app/iof/sailor/new.json", parameters: ["userName": "3302261997120005", "password": "ICy5YqxZB1uWSwcVLSNLcA==", "iofFlag": 1, "sailors": sailors11]).responseJSON{
//            response in
//
//            switch response.result{
//            case .Success:
//
//                let data = JSON(response.result.value!)
//                print(data)
//
//            case .Failure:
//                alertView("提示", message: "通信故障，无法获取数据!", okActionTitle: "好的", okHandler: nil, viewController: self)
//            }
//            
//        }
        
//        let userName = NSUserDefaults.standardUserDefaults().valueForKey("userName")
//        let password = NSUserDefaults.standardUserDefaults().valueForKey("password")
    
        //uploadImageAndData()
        
        //lock 
        
//        let antiTheftisOn = false
//        
//        Alamofire.request(.POST, httpBodyURL + httpAntiTheftURL, parameters: ["userName": userName!, "password": password!, "isOn": antiTheftisOn]).responseJSON{
//            response in
//            
//            switch response.result{
//            case .Success:
//                
//                let data = JSON(response.result.value!)
//                print(data)
//                
//            case .Failure:
//                alertView("提示", message: "通信故障，无法获取数据!", okActionTitle: "好的", okHandler: nil, viewController: self)
//            }
//            
//        }
        
    

    
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if NSUserDefaults.standardUserDefaults().boolForKey("hasLogin"){
            if let owenerName = NSUserDefaults.standardUserDefaults().valueForKey("ownerName"){
                self.welcomeLabel.text = "您好，\(owenerName)，欢迎使用本软件！"
            }else{
                self.welcomeLabel.text = "您好，您尚未登录！"
            }
        }else{
            self.welcomeLabel.text = ""
        }
        
//        welcomeLabel.bounds.size.height += 5
//        welcomeLabel.bounds.size.width += 5
//        welcomeLabel.layer.borderWidth = 1
//        welcomeLabel.layer.borderColor = UIColor.blueColor().CGColor
//        welcomeLabel.layer.cornerRadius = 5
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().boolForKey("hasLogin"){
            //如果已经登陆
            if let shipNum = NSUserDefaults.standardUserDefaults().valueForKey("shipNumber"){
                if let _ = NSUserDefaults.standardUserDefaults().valueForKey("gesturePasswordFor\(shipNum as! String)"){
                    //如果对应船号有手势密码
                    if !NSUserDefaults.standardUserDefaults().boolForKey("gestureHasLogin"){
                        performSegueWithIdentifier("mainToUnlockSegue", sender: nil)
                    }
                }
            }
        }else{
            //如果没有登陆,引导界面
            if !NSUserDefaults.standardUserDefaults().boolForKey("hasViewedWalkThrough"){
                self.performSegueWithIdentifier("walkthroughSegue", sender: nil)
                return
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mainToUnlockSegue"{
            let vc = segue.destinationViewController as! unlockViewController
            vc.newPSWMode = false
        }
    }
    
    func QRCode(barButtonItem: UIBarButtonItem){
        if let _ = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo){
            performSegueWithIdentifier("QRCodeSegue", sender: nil)
        }else{
            alertView("未找到拍摄设备", message: "请在设置－隐私－相机中打开软件的许可!", okActionTitle: "好的", okHandler: nil, viewController: self)
        }
    }
 
    func userMenu(barButtonItem: UIBarButtonItem){
        if NSUserDefaults.standardUserDefaults().boolForKey("hasLogin"){
            performSegueWithIdentifier("userSegue", sender: nil)
        }else{
            showLoginView()
        }
    }
    
}
