//
//  DetailViewController.swift
//  renchuanliandong
//
//  Created by qiuh1016 on 12/14/15.
//  Copyright © 2015 qiuhhong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var userPicImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var reasonHeadLabel: UILabel!
    
    var detailViewReasonHeadLabelText: String!
    
    var punch = Punch()
    
    @IBAction func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .Custom
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        popupView.layer.cornerRadius = 15

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.close))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        
        
        updateUI()
        
        print("***********")
        print("船员姓名：" + punch.sailorName)
        print("船员身份证：" + punch.sailorIdNo)
        print("出入港标志：\(punch.iofFlag)")
        print("打卡时间：" + punch.punchTime)
        print("数据类型：\(punch.dataType)")
        if let reason = punch.reason {
            print("添加／删除原因：" + reason)
        }
        

    }
    
    func updateUI(){
        
        reasonHeadLabel.text = detailViewReasonHeadLabelText

        var staffName = punch.sailorName
        staffName = staffName.stringByReplacingOccurrencesOfString(" ", withString: "")
        self.nameLabel.text = staffName
        
        let genderString = (punch.sailorIdNo as NSString).substringWithRange(NSMakeRange(16, 1))
        let genderNumber = Int(genderString)
        if let genderNumber = genderNumber {
            if genderNumber % 2 == 0{
                self.genderLabel.text = "女"
                self.userPicImageView.image = UIImage(named: "user63")
            }else{
                self.genderLabel.text = "男"
                self.userPicImageView.image = UIImage(named: "user62")
            }
        }else{
            self.genderLabel.text = "未知"
            self.userPicImageView.image = UIImage(named: "user62")
        }
        
        let id = punch.sailorIdNo
        if id.characters.count == 18{
            self.birthdayLabel.text = id[6 ..< 10] + "/" + id[10 ..< 12] + "/" + id[12 ..< 14]
        }else{
            self.birthdayLabel.text = "0000/00/00"
        }
        
        if punch.punchTime != "" {
            self.checkInDateLabel.text = punch.punchTime
        } else {
            self.checkInDateLabel.text = "手动添加"
        }
        
        if let reason = punch.reason {
            reasonLabel.text = reason
        }
        
    }
    
}

extension DetailViewController: UIViewControllerTransitioningDelegate{
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BounceAnimationController()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideOutAnimationController()
    }
}

extension DetailViewController:UIGestureRecognizerDelegate{
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}