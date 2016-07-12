//
//  changeInfoViewController.swift
//  huilvchaxun
//
//  Created by qiuhong on 11/26/15.
//  Copyright © 2015 qiuhhong. All rights reserved.
//

import UIKit
import Alamofire
import Just
import SwiftyJSON

class changeInfoViewController: UIViewController {
    
    @IBOutlet weak var owerTelNo: UITextField!
    @IBOutlet weak var picName: UITextField!
    @IBOutlet weak var picTelNo: UITextField!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var viewToTopConstraint: NSLayoutConstraint!
    
    @IBAction func editingDidBegin(sender: AnyObject) {
        viewToTopConstraint.constant = 5
        UIView.animateWithDuration(0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func editingDisEnd(sender: AnyObject) {
        viewToTopConstraint.constant = 66
        UIView.animateWithDuration(0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func changeButtonTapped() {
        
        closeKeyboard()
        let okHandler = {(action:UIAlertAction!) -> Void in
            let hudView = HudView.hudInView(self.view, animated: false)
            hudView.text = "修改中"
            afterDelay(1.0){
                hudView.hideAnimated(self.view, animated: false)
                let okHandler = {(action:UIAlertAction!) -> Void in
                    let count = self.navigationController?.viewControllers.count
                    self.navigationController?.popToViewController((self.navigationController?.viewControllers[count! - 2])!, animated: true)
                }
                alertView("提示", message: "信息修改成功!(功能待开发)", okActionTitle: "好的", okHandler: okHandler, viewController: self)
            }
        }
        alertView("提示", message: "确认修改信息?", okActionTitle: "是的", cancleActionTitle: "取消", okHandler: okHandler, viewController: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeInfoViewController.closeKeyboard))
        self.view.addGestureRecognizer(tap)
        let defaults = NSUserDefaults.standardUserDefaults()
        self.owerTelNo.text = "\(defaults.objectForKey("shipName")!)"
        self.picName.text = "\(defaults.objectForKey("ownerName")!)"
        self.picTelNo.text = "\(defaults.objectForKey("ownerTelNo")!)"
        picName.delegate = self
        owerTelNo.delegate = self
        picTelNo.delegate = self
        
        
        
        //test
        let userName = NSUserDefaults.standardUserDefaults().valueForKey("userName")
        let password = NSUserDefaults.standardUserDefaults().valueForKey("password")
        
        //change ship info
        
        Alamofire.request(.PUT, httpBodyURL + httpUpdataShipInfoURL, parameters: ["userName": userName!, "password": password!, "owerTelNo": "123456789000","picName": "qhhhhhTest", "picTelNo": "123456789900009"],  encoding: .URLEncodedInURL).responseString(encoding: NSUTF8StringEncoding) { response in
            debugPrint(response)
        }
        
//        Just.put(httpBodyURL + httpUpdataShipInfoURL, params: ["userName": userName!, "password": password!, "owerTelNo": "123456789000","picName": "TestJustModel", "picTelNo": "1234567890"]){
//            result in
//            print(JSON(data: result.content!))
//            
//        }
        
        
    }
    
    func closeKeyboard(){
        picName.resignFirstResponder()
        owerTelNo.resignFirstResponder()
        picTelNo.resignFirstResponder()
    }
    
}

extension changeInfoViewController: UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        if textField == owerTelNo{
            picName.becomeFirstResponder()
            print("1")
        }else if textField == picName{
            picTelNo.becomeFirstResponder()
            print("2")
        }else if textField == picTelNo{
            changeButtonTapped()
            print("3")
        }
        return true
    }
}
