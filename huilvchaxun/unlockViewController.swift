//
//  ViewController.swift
//  shoushiDemo
//
//  Created by 裘鸿 on 1/4/16.
//  Copyright © 2016 裘鸿. All rights reserved.
//

import UIKit

protocol unlockViewDelegate: NSObjectProtocol{
    func gesturePasswordCorrect(controller: unlockViewController)
    func dismissView(controller: unlockViewController)
}

class unlockViewController: UIViewController , QHunlockViewDelegate{
    
    @IBOutlet weak var labelToTopConstaint: NSLayoutConstraint!
    @IBOutlet weak var labelToCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var forgetGesturePasswordButton: UIButton!
    @IBOutlet weak var removeGesturePasswordButton: UIButton!
    @IBOutlet weak var leftBarButtomItem: UIBarButtonItem!
    
    var newPSWMode: Bool?
    var pswEnterTime = 0
    var pswErrorTime = 0
    var newPSWSetted = false
    var dontShowCancleButton = true
    
    var forgetGesturePasswordButtonHidden = false
    var removeGesturePasswordButtonHidden = true
    var psw1 = ""
    var psw2 = ""
    var psw :String?
    
    var shipNum: String = {
        if let shipNum = NSUserDefaults.standardUserDefaults().valueForKey("shipNumber"){
            return shipNum as! String
        }
        return ""
    }()
    
    var hasPSW = false
    var lockView: QHunlockView!
    let unlockImage = unlockImageView(frame: CGRectMake(screenW / 2 - 25, (screenH - screenW) * 12 / 25 , 50, 50))
    var delegate: unlockViewDelegate?
    
    @IBAction func close() {
        self.delegate?.dismissView(self)
    }
    
    @IBAction func forgetGesturePassword() {
        let alert = UIAlertController(title: "密码", message: "请输入您的登录密码", preferredStyle: UIAlertControllerStyle.Alert)
        let okHandler = {(action:UIAlertAction!) -> Void in
            let textField = alert.textFields?.first
            if textField?.text == "admin"{
                NSUserDefaults.standardUserDefaults().removeObjectForKey("gesturePasswordFor\(self.shipNum)")
                let okHandler = {(action:UIAlertAction!) -> Void in
                    if let delegate = self.delegate{
                        delegate.dismissView(self)
                    }
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                alertView("提示", message: "已删除手势密码!", okActionTitle: "好的", okHandler: okHandler, viewController: self)
            }else{
                alertView("提示", message: "密码错误!", okActionTitle: "好的", okHandler: nil, viewController: self)
            }
        }
        let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: okHandler)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addTextFieldWithConfigurationHandler{ (textField) in
            textField.placeholder = "登录密码"
            textField.secureTextEntry = true
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func removeGesturePassword() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("gesturePasswordFor\(shipNum)")
        let okHandler = {(action: UIAlertAction!) -> Void in
            self.delegate?.dismissView(self)
        }
        alertView("提示", message: "手势密码已删除!", okActionTitle: "好的", okHandler: okHandler, viewController: self)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if dontShowCancleButton{
            leftBarButtomItem.title = ""
        }
        
        if let password = NSUserDefaults.standardUserDefaults().valueForKey("gesturePasswordFor\(shipNum)"){
            psw = password as? String
        }
        
        navigationBar.delegate = self
        navigationTitle.title = NSUserDefaults.standardUserDefaults().valueForKey("shipName") as? String
        
        removeGesturePasswordButton.hidden = removeGesturePasswordButtonHidden
        forgetGesturePasswordButton.hidden = forgetGesturePasswordButtonHidden
        
        if screenH != 480{
            self.view.addSubview(unlockImage) //4s 不加这个 屏幕太小
        }
        
        labelToTopConstaint.constant = (screenH - screenW) * 16 / 25 + 10
        self.view.layoutIfNeeded()
        
        lockView = QHunlockView(frame: CGRectMake(0, (screenH - screenW) * 8.5 / 10, screenW, screenW), newPSWMode: newPSWMode!)
        self.lockView.delegate = self
        self.view.addSubview(lockView)
        
        label.textColor = UIColor.whiteColor()
        if newPSWMode!{
            lockView.newPSWMode = true
            label.text = "请输入新密码"
        }else{
            label.text = "请滑动输入密码"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func unlockViewPassWord(unlockView: QHunlockView, andPassWord password: String) -> Bool {
        if password == psw {
            label.text = "密码正确"
            label.textColor = UIColor.greenColor()
            afterDelay(1.0){
                if !self.newPSWMode!{
                    if let delegate = self.delegate{
                        delegate.gesturePasswordCorrect(self)
                    }else{
                        //手势登陆成功
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "gestureHasLogin")
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            }
            return true
        }else{
            self.pswErrorTime += 1
            label.textColor = UIColor.redColor()
            self.label.text = "密码错误"
            shake(labelToCenterConstraint, s: 10, duration: 0.03)
            if pswErrorTime == 3{
                let okHandler = { (action:UIAlertAction!) -> Void in
                    self.delegate?.dismissView(self)
                }
                alertView("提示", message: "手势密码已错误3次!", okActionTitle: "好的", okHandler: okHandler, viewController: self)
                return false
            }else{
                
                afterDelay(1.0){
                    self.label.text = "请输入密码"
                    self.label.textColor = UIColor.whiteColor()
                }
                return false
            }
        }
    }
    
    func unlockViewTouchedEnded(unlockView: QHunlockView, andPassWord password: String) -> Bool? {
        
        if password.characters.count < 4{
            label.text = "请连接至少4个点"
            label.textColor = UIColor.redColor()
            shake(labelToCenterConstraint, s: 10, duration: 0.03)
            afterDelay(1.0){
                self.label.text = "请滑动设置新密码"
                self.label.textColor = UIColor.whiteColor()
            }
            return false
        }else{
            if pswEnterTime == 0{
                psw1 = password
                label.text = "请再次滑动确认密码"
                label.textColor = UIColor.whiteColor()
                pswEnterTime += 1
                return true
            }else if pswEnterTime == 1{
                psw2 = password
                if psw1 == psw2 {
                    psw = psw2
                    NSUserDefaults.standardUserDefaults().setValue(psw!, forKey: "gesturePasswordFor\(shipNum)")
                    psw1 = ""
                    psw2 = ""
                    label.text = "密码设置成功"
                    label.textColor = UIColor.greenColor()
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "gestureHasLogin")
                    print("new psw = \(psw!)")
                    let okHandler = {(action: UIAlertAction!) -> Void in
                        self.delegate?.dismissView(self)
                    }
                    alertView("提示", message: "手势密码设置成功!", okActionTitle: "好的", okHandler: okHandler, viewController: self)
                    pswEnterTime = 0
                    return true
                }else{
                    psw1 = ""
                    psw2 = ""
                    label.text = "两次滑动不一致"
                    label.textColor = UIColor.redColor()
                    shake(labelToCenterConstraint, s: 10, duration: 0.03)
                    afterDelay(1.0){
                        self.label.text = "请滑动设置新密码"
                        self.label.textColor = UIColor.whiteColor()
                    }
                    pswEnterTime = 0
                    return false
                }
            }else{
                return false
            }

        }
        
    }
    
    func shake(object: NSLayoutConstraint, s: CGFloat, duration: NSTimeInterval){
        object.constant -= s
        UIView.animateWithDuration(duration, animations: {
            self.view.layoutIfNeeded()
            }, completion: { _ in
                object.constant += s * 2
                UIView.animateWithDuration(duration * 2, animations: {
                    self.view.layoutIfNeeded()
                    }, completion: { _ in
                        object.constant -= s * 2
                        UIView.animateWithDuration(duration * 2, animations: {
                            self.view.layoutIfNeeded()
                            }, completion: { _ in
                                object.constant += s * 2
                                UIView.animateWithDuration(duration * 2, animations: {
                                    self.view.layoutIfNeeded()
                                    }, completion: { _ in
                                        object.constant -= s
                                        UIView.animateWithDuration(duration, animations: {
                                            self.view.layoutIfNeeded()
                                            
                                            }, completion: nil)
                                        
                                })
                        })
                })
        })
    }
    
}

extension unlockViewController : UINavigationBarDelegate{
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}

