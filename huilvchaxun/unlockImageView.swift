//
//  unlockImageView.swift
//  renchuanliandong
//
//  Created by 裘鸿 on 1/5/16.
//  Copyright © 2016 qiuhhong. All rights reserved.
//

import UIKit

class unlockImageView: UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetAllowsAntialiasing(context, true)
        
        let D: CGFloat = self.bounds.size.width * 13 / 50
        let littleSpace = self.bounds.size.width * 4 / 50
        let magin = (self.bounds.size.width - 3 * D - 1.2 * littleSpace) / 2
        
        
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
        
        for i in 0 ... 8{
            let rowIndex = Int(i / 3)
            let colIndex = Int(i % 3)
            let circleX = CGFloat(colIndex) * (magin + D) + littleSpace
            let circleY = CGFloat(rowIndex) * (magin + D) + littleSpace
            CGContextAddEllipseInRect(context, CGRectMake(circleX, circleY, D, D))
            
        }
        
        CGContextStrokePath(context)
    }
}
