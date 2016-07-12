//
//  ViewController.swift
//  huilvchaxun
//
//  Created by qiuh1016 on 11/16/15.
//  Copyright © 2015 qiuhhong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController{
    

    @IBOutlet weak var shipNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var accountMenuButton: UIButton!
    
    @IBOutlet weak var headingLabelToTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewToYConstraint: NSLayoutConstraint!
    
    //保存3个登录过的帐户
    var accounts = ["", "", ""]
    var contentViewWillCoverHeading = false

    var keyboardHeight: CGFloat!
    var headingLabelToTopConstraintConstant: CGFloat!
    
    var hudView: HudView!
    
    var myShipInfo: JSON!

    @IBAction func closeWindow(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func accountMenuButtonTapped() {
        
        //如果没有历史，则返回
        if accounts[0].isEmpty && accounts[1].isEmpty && accounts[2].isEmpty{
            return
        }
        
        let accountMenu = UIAlertController(title: "请选择账户", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        //将最新的帐户显示在最上面
        let account0Action = UIAlertAction(title: accounts[0], style: .Default, handler: {(action:UIAlertAction!) -> Void in
            self.shipNumberTextField.text = "\(self.accounts[0])"
        })
        let account1Action = UIAlertAction(title: accounts[1], style: .Default, handler: {(action:UIAlertAction!) -> Void in
            self.shipNumberTextField.text = "\(self.accounts[1])"
        })
        let account2Action = UIAlertAction(title: accounts[2], style: .Default, handler: {(action:UIAlertAction!) -> Void in
            self.shipNumberTextField.text = "\(self.accounts[2])"
        })
        
        if accounts[2] != ""{
            accountMenu.addAction(account2Action)
        }
        if accounts[1] != ""{
            accountMenu.addAction(account1Action)
        }
        if accounts[0] != ""{
            accountMenu.addAction(account0Action)
        }
        
        //清空按钮
        let clearAction = UIAlertAction(title: "清空历史", style: UIAlertActionStyle.Destructive, handler: {(action:UIAlertAction!) -> Void in
            let defaults = NSUserDefaults.standardUserDefaults()
            self.accounts = ["", "", ""]
            self.shipNumberTextField.text = ""
            self.passwordTextField.text = ""
            defaults.setObject(self.accounts, forKey: "accounts")
            self.accountMenuButton.hidden = true
            
        })
        accountMenu.addAction(clearAction)
        
        //取消按钮
        let cancleAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        accountMenu.addAction(cancleAction)
        
        self.presentViewController(accountMenu, animated: true, completion: nil)
        
    }
    
    @IBAction func editingDidBegin(sender: AnyObject) {
        accountMenuButton.hidden = true
    }
    
    @IBAction func editingDisEnd(sender: AnyObject) {
        if !accounts[0].isEmpty || !accounts[1].isEmpty || !accounts[2].isEmpty{
            accountMenuButton.hidden = false
        }
    }
    
    @IBAction func loginTapped() {
        closeKeyboard()
        
        if shipNumberTextField.text == "" || passwordTextField.text == "" {
            //SweetAlert().showAlert("船号或密码不能为空!", subTitle: "", style: AlertStyle.Error, buttonTitle: "    OK    ")
            alertView("提示", message: "船号或密码不能为空!", okActionTitle: "好的", okHandler: nil, viewController: self)
            
        }else{
            login(shipNumberTextField.text!, password: passwordTextField.text!)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let defaults = NSUserDefaults.standardUserDefaults()
        if let defaultsAccounts = defaults.objectForKey("accounts"){
            accounts = defaultsAccounts as! [String]
        }
        
        let screenHeight = self.view.bounds.size.height
        let contentViewHeight = self.contentView.bounds.size.height
        
        headingLabelToTopConstraintConstant = ((screenHeight / 2 - contentViewHeight / 2) / 2 - headingLabel.frame.height / 2) * 1.2
        headingLabelToTopConstraint.constant = headingLabelToTopConstraintConstant
        self.view.layoutIfNeeded()
        
        shipNumberTextField.delegate = self
        passwordTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.closeKeyboard))
        self.view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.headingLabel.alpha = 1
        
        shipNumberTextField.text = accounts.last
        
        //清空密码textfield
        //passwordTextField.text = ""
        
        if accounts[0].isEmpty && accounts[1].isEmpty && accounts[2].isEmpty{
            accountMenuButton.hidden = true
        }else{
            accountMenuButton.hidden = false
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func login(shipNumber: String , password: String){
        
        let PSW = b64_md5(password)
        
        hudView = HudView.hudInView(self.view, animated: false)
        hudView.text = "登录中"
        
        var serverIP = NSUserDefaults.standardUserDefaults().stringForKey("serverIP")
        if serverIP == nil {
            serverIP = defaultServerIP_1
        }
        let url = "http://" + serverIP! + loginUrl
    
        Alamofire.request(.POST, url, parameters: ["userName": shipNumber, "password": PSW, "userType": 2]).responseJSON{
            response in
            
            switch response.result{
            case .Success:
                
                if let value = response.result.value{
                    
                    //登录
                    
                    let result = JSON(value)
                    print(result)
                    if result["code"] == 0 {
                        
                        UserDefaults.setObject(result["deviceNo"].stringValue, forKey: "deviceNo")
                        UserDefaults.setObject(result["shipNo"].stringValue, forKey: "shipNo")
                        
                        
                        self.getShipInfo(shipNumber, PSW: "\(PSW)", shipNo: result["shipNo"].stringValue)
                        
                        
                    } else {
                        self.hudView.hideAnimated(self.view, animated: false)
                        alertView(result["msg"].stringValue, message: "", okActionTitle: "OK", okHandler: nil, viewController: self)
                    }
                    
                    
                }
            case .Failure:
                self.hudView.hideAnimated(self.view, animated: false)
                alertView("提示", message: "通信故障，无法获取数据!", okActionTitle: "好的", okHandler: nil, viewController: self)
            }
        }
    }
    
    func getShipInfo(shipNumber: String, PSW: String, shipNo: String) {
        
        var serverIP = NSUserDefaults.standardUserDefaults().stringForKey("serverIP")
        if serverIP == nil {
            serverIP = defaultServerIP_1
        }
        let url = "http://" + serverIP! + shipGetUrl
        
        //get ship info
        Alamofire.request(.GET, url, parameters: ["userName": shipNumber, "password": PSW, "shipNo": shipNo]).responseJSON { response in
            
            switch response.result{
            case .Success:
                let result = JSON(response.result.value!)
                
                if result["code"] == 0 {
                    
                    self.myShipInfo = result
                    
//                    let data = result["data"][0]
                    
                    
                    //以下为登陆成功的操作
                    
                    //保存本船信息
                    
//                    
//                    let shipNumber = data["shipNo"].stringValue
//                    
//                    UserDefaults.setObject(data["shipName"]    .stringValue, forKey: "shipName")     //船名
//                    UserDefaults.setObject(data["shipNo"]      .stringValue, forKey: "shipNo")       //船号
//                    UserDefaults.setObject(data["ownerName"]   .stringValue, forKey: "ownerName")    //船东
//                    UserDefaults.setObject(data["ownerTelNo"]  .stringValue, forKey: "ownerTelNo")   //船东电话
//                    UserDefaults.setObject(data["deviceNo"]    .stringValue, forKey: "deviceNo")     //终端序号
//                    UserDefaults.setDouble(data["latitude"]    .doubleValue, forKey: "latitude")     //位置
//                    UserDefaults.setDouble(data["longitude"]   .doubleValue, forKey: "longitude")    //位置
//                    UserDefaults.setBool  (data["offlineFlag"] .boolValue  , forKey: "offlineFlag")  //是否在线
//                    UserDefaults.setObject(data["cfsStartDate"].stringValue, forKey: "cfsStartDate") //伏休期起始
//                    UserDefaults.setObject(data["cfsEndDate"]  .stringValue, forKey: "cfsEndDate")   //伏休期结束
//                    UserDefaults.setObject(data["fenceNo"]     .stringValue, forKey: "fenceNo")      //港口编号
                    
                    //保存至历史帐户
                    if shipNumber != self.accounts[0] && shipNumber != self.accounts[1] && shipNumber != self.accounts[2]{
                        self.accounts.removeFirst()
                        self.accounts.append(shipNumber)
                    }else if shipNumber == self.accounts[1]{
                        self.accounts[1] = self.accounts[2]
                        self.accounts[2] = shipNumber
                        print("account 2 and 1 changed position")
                    }else if shipNumber == self.accounts[0]{
                        self.accounts[0] = self.accounts[1]
                        self.accounts[1] = self.accounts[2]
                        self.accounts[2] = shipNumber
                        print("account 2/1/0 changed position")
                    }
                    UserDefaults.setObject(self.accounts, forKey: "accounts")
                    
                    //保存登录状态
                    UserDefaults.setBool(true, forKey: "hasLogin")
                    UserDefaults.setBool(true, forKey: "gestureHasLogin")
                    
                    UserDefaults.setObject(shipNumber, forKey: "userName")
                    UserDefaults.setObject("\(PSW)", forKey: "password")
                    
                    
                    //hudView
                    self.hudView.hideAnimated(self.view, animated: false)
                    let okView = OKView.hudInView(self.view, animated: false)
                    okView.text = "登录成功"
                    afterDelay(1.0){
                        okView.hideAnimated(self.view, animated: false)
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            case .Failure:
                print("failure")
            }
            
        }

    }
    
    func closeKeyboard(){
        shipNumberTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    func keyboardWillAppear(notification: NSNotification){
        
        //TODO: 动画优化
        let keyboardInfo = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]
        keyboardHeight = keyboardInfo?.CGRectValue.size.height
        let screenHeight = self.view.bounds.size.height
        let contentViewHeight = self.contentView.frame.height
        
        if keyboardHeight + contentViewHeight >= screenHeight / 2{
            let remainPoint = screenHeight / 2 - keyboardHeight
            var movePonit = contentViewHeight / 2 - remainPoint + 20
            
            if contentViewHeight / 2 + movePonit + 20 > screenHeight / 2{
                movePonit = screenHeight / 2 - contentViewHeight / 2 - 20
            }
            
            contentViewToYConstraint.constant = -movePonit
            headingLabelToTopConstraint.constant = headingLabelToTopConstraintConstant - 30
            
            if screenHeight / 2 - movePonit - contentViewHeight / 2 < headingLabelToTopConstraintConstant + headingLabel.frame.height{
                contentViewWillCoverHeading = true
            }
            
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
                self.view.layoutIfNeeded()
                if self.contentViewWillCoverHeading{
                    self.headingLabel.alpha = 0
                }
            }, completion: nil)
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification){
        
        contentViewToYConstraint.constant = 0
        headingLabelToTopConstraint.constant = headingLabelToTopConstraintConstant
    
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
            self.view.layoutIfNeeded()
            if self.contentViewWillCoverHeading{
                self.headingLabel.alpha = 1
                self.contentViewWillCoverHeading = false
            }
        }, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loginToUnlockSegue"{
            let viewController = segue.destinationViewController as! unlockViewController
            viewController.newPSWMode = false
        }
    }
    
}

extension LoginViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        if textField == shipNumberTextField{
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField{
            if shipNumberTextField.text != "" && passwordTextField.text != ""{
                passwordTextField.resignFirstResponder()
                loginTapped()
            }
        }
        return true
    }
    
}
