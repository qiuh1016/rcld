//
//  reasonViewController.swift
//  renchuanliandong
//
//  Created by 裘鸿 on 1/15/16.
//  Copyright © 2016 qiuhhong. All rights reserved.
//

import UIKit

protocol reasonViewControllerDelegate: NSObjectProtocol{
    func punchHasConfirmToAdd (punchAdded: Punch, viewController: UIViewController)
    func punchHasConfirmToDelete (deleteReason: String, viewController: UIViewController)
}

class reasonViewController: UIViewController {

    @IBOutlet weak var reasonButton_1: UIButton!
    @IBOutlet weak var reasonButton_2: UIButton!
    @IBOutlet weak var reasonButton_3: UIButton!
    @IBOutlet weak var reasonButton_4: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var reasonTextField: UITextField!
    
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var contentViw: UIView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var contentViewToTopConstraint: NSLayoutConstraint!
    
    var delegate: reasonViewControllerDelegate?
    var punchToDelete: Punch?
    
    var punchAdded = Punch()
    var punchs = [Punch]()
    
    let addReason: [String] = ["添加原因1", "添加原因2", "添加原因3", "添加原因4"]
    let deleteReason: [String] = ["删除原因1", "删除原因2", "删除原因3", "删除原因4"]
    
    @IBAction func close(sender: AnyObject) {
        nameTextField.endEditing(true)
        idTextField.endEditing(true)
        reasonTextField.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func upLoadButtonTapped() {
        nameTextField.endEditing(true)
        idTextField.endEditing(true)
        reasonTextField.endEditing(true)
        
        if let _ = punchToDelete {
            //删除
            if let reason = reasonTextField.text where reason != "" {
                let okHandler = { (action: UIAlertAction!) -> Void in
                    self.delegate?.punchHasConfirmToDelete(reason, viewController: self)
                }
                alertView("确认提交？", message: "删除原因：\(reason)", okActionTitle: "提交", cancleActionTitle: "取消", okHandler: okHandler, viewController: self)
            } else {
                alertView("错误", message: "请填写删除原因!", okActionTitle: "好的", okHandler: nil, viewController: self)
            }
        } else {
            //增加
            let sailorName = nameTextField.text!
            var sailorIdNo = idTextField.text!
            let reason     = reasonTextField.text!
            
            if sailorName != "" && sailorIdNo != "" && reason != "" {
                
                sailorIdNo = sailorIdNo.stringByReplacingOccurrencesOfString("x", withString: "X")
                sailorIdNo = sailorIdNo.stringByReplacingOccurrencesOfString(" ", withString: "")
                
                if !verifyIDCardNumber(sailorIdNo) {
                    alertView("错误", message: "身份证号码填写错误", okActionTitle: "好的", okHandler: nil, viewController: self)
                    
                } else {
                    punchAdded.sailorName = sailorName
                    punchAdded.sailorIdNo = sailorIdNo
                    punchAdded.dataType = 1
                    punchAdded.reason = reason
                    
                    for punch in punchs {
                        if punchAdded.sailorIdNo == punch.sailorIdNo {
                            alertView("错误", message: "该位船员已在名单中", okActionTitle: "好的", okHandler: nil, viewController: self)
                            return
                        }
                    }
                    
                    let okHandler = { (action: UIAlertAction!) -> Void in
                        self.delegate?.punchHasConfirmToAdd(self.punchAdded, viewController: self)
                    }
                    let alert = UIAlertController(title: "确认提交？", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                    let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
                    let okAction = UIAlertAction(title: "提交", style: UIAlertActionStyle.Destructive, handler: okHandler)
                    alert.addAction(cancelAction)
                    alert.addAction(okAction)
                    alert.addTextFieldWithConfigurationHandler{ (textField) in
                        textField.text = "姓名：\(sailorName)"
                        textField.enabled = false
                    }
                    alert.addTextFieldWithConfigurationHandler{ (textField) in
                        textField.text = "身份证：\(sailorIdNo)"
                        textField.enabled = false
                    }
                    alert.addTextFieldWithConfigurationHandler{ (textField) in
                        textField.text = "添加原因：\(reason)"
                        textField.enabled = false
                    }
                    self.presentViewController(alert, animated: true, completion: nil)

//                    alertView("确认提交？", message: "姓名：\(sailorName)\n身份证：\(sailorIdNo)\n增加原因：\(reason)", okActionTitle: "提交", cancleActionTitle: "取消", okHandler: okHandler, viewController: self)
                    
                }
                
            } else {
                alertView("错误", message: "请填写完整!", okActionTitle: "好的", okHandler: nil, viewController: self)
            }
        }
        
        
    }
    
    
    override func viewDidLoad() {
        var deleteMode = false
        if let _ = punchToDelete {
            deleteMode = true
        }
        
        let reasonButtonArray = [reasonButton_1, reasonButton_2, reasonButton_3, reasonButton_4]
        for i in 0 ..< reasonButtonArray.count {
            reasonButtonArray[i].layer.cornerRadius = reasonButtonArray[i].bounds.size.height / 4
            reasonButtonArray[i].layer.masksToBounds = true
            
            let title = deleteMode ? deleteReason[i] : addReason[i]
            reasonButtonArray[i].setTitle(title, forState: .Normal)
            
            reasonButtonArray[i].addTarget(self, action: #selector(reasonViewController.addReason(_:)), forControlEvents: .TouchUpInside)
        }
        
        nameTextField.delegate = self
        idTextField.delegate = self
        reasonTextField.delegate = self
        
        navigationBar.delegate = self
        
        if (screenH - contentViw.frame.size.height) / 2 - 32 < 44 {
            contentViewToTopConstraint.constant = 44
        } else {
            contentViewToTopConstraint.constant = (screenH - contentViw.frame.size.height) / 2 - 32
        }
        
        
        self.view.layoutIfNeeded();
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(reasonViewController.closeKeyboard))
        self.view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reasonViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reasonViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        if let punch = punchToDelete {
            nameTextField.enabled = false
            idTextField.enabled = false
            nameTextField.text = punch.sailorName
            idTextField.text = punch.sailorIdNo
            reasonLabel.text = "删除原因"
            confirmButton.setTitle("删除", forState: .Normal)
            
        }
        //TODO: 正式版把填充文字去掉
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func addReason(button: UIButton) {
        reasonTextField.text = button.titleForState(.Normal)
    }
    
    func closeKeyboard(){
        nameTextField.resignFirstResponder()
        idTextField.resignFirstResponder()
        reasonTextField.resignFirstResponder()
    }
    
    func keyboardWillAppear(notification: NSNotification){
        let originalContraint = (screenH - contentViw.frame.size.height) / 2 - 32
        
        if originalContraint > 44 {
            contentViewToTopConstraint.constant = 44
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification){
        let originalContraint = (screenH - contentViw.frame.size.height) / 2 - 32
        contentViewToTopConstraint.constant = originalContraint
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

    
}

extension reasonViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == nameTextField {
            idTextField.becomeFirstResponder()
        } else if textField == idTextField {
            reasonTextField.becomeFirstResponder()
        } else if textField ==  reasonTextField {
            upLoadButtonTapped()
        }
        return true
    }
}

extension reasonViewController: UINavigationBarDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}

//extension reasonViewController: UIAlertViewDelegate {
//    func willPresentAlertView(alertView: UIAlertView) {
//        for view in alertView.subviews {
//            if view.isKindOfClass(UILabel.layerClass()) {
//                let label = view as! UILabel
//                label.textAlignment = .Left
//            }
//        }
//    }
//}
