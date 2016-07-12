//
//  QHunLockView.swift
//  shoushiDemo
//
//  Created by 裘鸿 on 1/4/16.
//  Copyright © 2016 裘鸿. All rights reserved.
//

import UIKit

protocol QHunlockViewDelegate: NSObjectProtocol{
    func unlockViewPassWord(unlockView: QHunlockView, andPassWord password: String) -> Bool
    func unlockViewTouchedEnded(unlockView: QHunlockView, andPassWord password: String) -> Bool?
}

class QHunlockView: UIView {
    var selectedButtons = [UIButton]()
    lazy var buttons: [UIButton] = {
        var arrM = [UIButton]()
        for i in 0 ... 8{
            let btn = UIButton()
            btn.tag = i
            btn.userInteractionEnabled = false
            btn.setBackgroundImage(UIImage(named: "gesture_node_normal"), forState: .Normal)
            btn.setBackgroundImage(UIImage(named: "gesture_node_highlighted"), forState: .Selected)
            btn.setBackgroundImage(UIImage(named: "gesture_node_error"), forState: .Disabled)
            self.addSubview(btn)
            arrM.append(btn)
        }
        return arrM
    }()
    var linColor: UIColor = UIColor(red: 0, green: 149/255, blue: 255/255, alpha: 1.0)
    var current_point: CGPoint?
    var delegate: QHunlockViewDelegate?
    var newPSWMode : Bool?
    
    init(frame: CGRect, newPSWMode mode: Bool ) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        newPSWMode = mode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        if (self.selectedButtons.count == 0) {
            return
        }
        
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetAllowsAntialiasing(context, true)
        
        CGContextSetLineWidth(context, 2)
        for i in 0 ... self.selectedButtons.count - 1{
            let button = self.selectedButtons[i]
            if (i == 0){
                CGContextMoveToPoint(context, button.center.x, button.center.y)
            }else{
                CGContextAddLineToPoint(context, button.center.x, button.center.y)
            }
        }
        if let _ = current_point{
            CGContextAddLineToPoint(context, current_point!.x, current_point!.y)
        }
        self.linColor.set()
        CGContextStrokePath(context)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonW: CGFloat = 74.0
        let buttonH: CGFloat = buttonW
        
        //列数
        let col:CGFloat = 3
        
        //间距
//        let magin: CGFloat = (self.bounds.size.width - col * buttonW) / (col - 1)
//        
//        for i in 0 ... self.buttons.count - 1 {
//            let button = self.buttons[i] as UIButton
//            let row_idx = Int(i / 3)
//            let col_idx = Int(i % 3)
//            let buttonX: CGFloat = CGFloat(col_idx) * (magin + buttonW)
//            let buttonY: CGFloat = CGFloat(row_idx) * (magin + buttonH)
//            
//            //设置frame
//            button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH)
//        }

        let magin: CGFloat = (self.bounds.size.width - col * buttonW) / (col + 1)

        for i in 0 ... self.buttons.count - 1 {
            let button = self.buttons[i] as UIButton
            let row_idx = Int(i / 3)
            let col_idx = Int(i % 3)
            let buttonX: CGFloat = CGFloat(col_idx) * (magin + buttonW) + magin
            let buttonY: CGFloat = CGFloat(row_idx) * (magin + buttonH) + magin

            //设置frame
            button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH)
        }
    }
    
    func clearLockView(){
        for button in self.selectedButtons{
            button.selected = false
            button.enabled = true
        }
        self.linColor = UIColor(red: 0, green: 149/255, blue: 255/255, alpha: 1.0)
        self.selectedButtons.removeAll()
        self.setNeedsDisplay()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = (touches as NSSet).anyObject() as! UITouch
        let loc: CGPoint = touch.locationInView(touch.view)
        for button in self.buttons{
            if CGRectContainsPoint(button.frame, loc) && !button.selected {
                self.selectedButtons.append(button)
                button.selected = true
                break
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = (touches as NSSet).anyObject() as! UITouch
        let loc: CGPoint = touch.locationInView(touch.view)
        self.current_point = loc
        for button in self.buttons{
            if CGRectContainsPoint(button.frame, loc) && !button.selected {
                self.selectedButtons.append(button)
                button.selected = true
                break
            }
        }
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.current_point = self.selectedButtons.last?.center
        var password: String = ""
        for button in self.selectedButtons{
            password += "\(button.tag)"
        }
        if password != ""{
            var isOk = true
            if newPSWMode!{
                if let _ = delegate{
                    if let bool = self.delegate?.unlockViewTouchedEnded(self, andPassWord: password){
                        isOk = bool
                    }
                }                
            }else{
                if let _ = delegate{
                    isOk = (self.delegate?.unlockViewPassWord(self, andPassWord: password))!
                }
            }
            pswOK(correct: isOk)
        }
    }
    
    func pswOK(correct correct: Bool){
        if correct{
            self.linColor = UIColor.greenColor()
            
            self.userInteractionEnabled = false
            
            self.setNeedsDisplay()
            
            afterDelay(1.0){
                self.clearLockView()
                self.userInteractionEnabled = true
            }
        }else{
            self.linColor = UIColor.redColor()
            
            self.userInteractionEnabled = false
            for button in self.selectedButtons{
                button.selected = false
                button.enabled = false
            }
            
            self.setNeedsDisplay()
            
            afterDelay(1.0){
                self.clearLockView()
                self.userInteractionEnabled = true
            }
        }
    }
    

}
