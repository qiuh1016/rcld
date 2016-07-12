//
//  ChangePasswordViewController.swift
//  renchuanliandong
//
//  Created by 裘鸿 on 12/28/15.
//  Copyright © 2015 qiuhhong. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ChangePasswordViewController: UIViewController {
    

    @IBOutlet weak var textField_2: UITextField!
    @IBOutlet weak var textField_3: UITextField!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewConstaint: NSLayoutConstraint!
    
    var keyboardHeight: CGFloat!
    var contentViewDidMoveUp = false
    
    @IBAction func okButtonTapped() {
    
        closeKeyboard()
        let newPSW1 = textField_2.text!
        let newPSW2 = textField_3.text!
        
        if newPSW1 == newPSW2 {
            
            if newPSW1 == "" {
                alertView("提示", message: "密码不能为空", okActionTitle: "好的", okHandler: nil, viewController: self)
                clearAllTextField()
                return
            }
            
            let userName = NSUserDefaults.standardUserDefaults().valueForKey("userName")
            let password = NSUserDefaults.standardUserDefaults().valueForKey("password")
            let newPSW_b64 = b64_md5(newPSW1)
            print("newPSW \(newPSW_b64), \(newPSW1)")
            
            self.view.makeToastActivity(message: "提交中")
            
            Alamofire.request(.POST, httpBodyURL + httpChangePSWURL, parameters: ["userName": userName!, "password": password!, "newPassword": newPSW_b64]).responseJSON { response in
                
                afterDelay(2.0) {
                    
                    self.view.hideToastActivity()
                    
                    switch response.result {
                    case .Success:
                        let result = JSON(response.result.value!)
                        print(result)
                        if result["code"] == 0 {
                            NSUserDefaults.standardUserDefaults().setObject("\(newPSW_b64)", forKey: "password")
                            
                            let okHandler = { (action:UIAlertAction!) in
                                let count = self.navigationController?.viewControllers.count
                                self.navigationController?.popToViewController((self.navigationController?.viewControllers[count! - 2])!, animated: true)
                            }
                            alertView("提示", message: "密码修改成功!", okActionTitle: "好的", okHandler: okHandler, viewController: self)
                        } else {
                            alertView("提示", message: "遇到错误!", okActionTitle: "好的", okHandler: nil, viewController: self)
                        }
                        
                    case .Failure(let error):
                        print(error)
                        alertView("提示", message: "通信故障，请稍后再试!", okActionTitle: "好的", okHandler: nil, viewController: self)
                    }

                }
            }
            
        }else{
            alertView("提示", message: "两次密码输入不一致!", okActionTitle: "好的", okHandler: nil, viewController: self)
            clearAllTextField()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField_2.delegate = self
        textField_3.delegate = self
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChangePasswordViewController.closeKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChangePasswordViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChangePasswordViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    

    
    func keyboardWillAppear(notification: NSNotification){
        
        let keyboardInfo = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]
        keyboardHeight = keyboardInfo?.CGRectValue.size.height
        
        let contentViewHeight = contentView.frame.height
        let viewHeight = view.frame.height
        var movePoint = (contentViewHeight / 2 - (viewHeight / 2 - keyboardHeight)) + 20
        
        if contentViewHeight / 2 + movePoint + 20 > viewHeight / 2{
            movePoint = viewHeight / 2 - contentViewHeight / 2 - 20
        }
        
        contentViewConstaint.constant = -movePoint
        UIView.animateWithDuration(0.5, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    
    func keyboardWillHide(notification: NSNotification){
        contentViewConstaint.constant = -20
        UIView.animateWithDuration(0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func closeKeyboard(){
        textField_2.resignFirstResponder()
        textField_3.resignFirstResponder()
    }
    
    func clearAllTextField(){
        self.textField_2.text = ""
        self.textField_3.text = ""
    }
    
}

extension ChangePasswordViewController: UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        if textField == textField_2{
            textField_3.becomeFirstResponder()
        }else if textField == textField_3{
            okButtonTapped()
        }
        return true
    }
}
