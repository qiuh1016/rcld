//
//  JHMenu.swift
//  renchuanliandong
//
//  Created by qiuh1016 on 12/10/15.
//  Copyright © 2015 qiuhhong. All rights reserved.
//

import UIKit

let TopToView: CGFloat = 10.0
let LeftToView: CGFloat  = 10.0
let CellLineEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10)
let kScreenWidth = UIScreen.mainScreen().bounds.size.width
let kScreenHeight = UIScreen.mainScreen().bounds.size.height

protocol QHMenuDelegate: NSObjectProtocol{
    func qhMenu(tableview: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
}

class QHMenu: UIView,UITableViewDataSource, UITableViewDelegate{
    var origin: CGPoint = CGPoint(x: 0, y: 0)
    var rowHeight: CGFloat = 0
    var arrData: NSArray = [String]()
    var arrImgName: NSArray = [String]()
    var tableView: UITableView = UITableView()
    var dismiss: ((Void) -> Void)?
    var delegate:QHMenuDelegate?
    
    init(dataArr: NSArray, origin: CGPoint, width: CGFloat, rowHeight rouHeight: CGFloat){
        
        super.init(frame: CGRectMake(0, 0, kScreenWidth, kScreenHeight))
        
        if rowHeight <= 0{
            rowHeight = 44
        }
        self.backgroundColor = UIColor.clearColor()
        self.origin = origin
        rowHeight = rouHeight
        arrData = dataArr.copy() as! NSArray
        tableView = UITableView.init(frame: CGRectMake(origin.x + LeftToView, origin.y + TopToView, width, CGFloat(Int(rowHeight) * dataArr.count)), style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        self.addSubview(tableView)
        tableView.backgroundColor = UIColor(white: 0.2, alpha: 0.7)
        tableView.layer.cornerRadius = 2
        tableView.bounces = false
        tableView.separatorColor = UIColor(white: 0.3, alpha: 0.7)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "JHMenu")
        if tableView.respondsToSelector(Selector("setSeparatorInset:")){
            tableView.separatorInset = CellLineEdgeInsets
        }
        if tableView.respondsToSelector(Selector("setLayoutMargins:")){
            tableView.layoutMargins = CellLineEdgeInsets
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("JHMenu")! as UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont.systemFontOfSize(15)
        cell.textLabel?.text = self.arrData[indexPath.row] as? String
        cell.imageView?.image = UIImage(named: arrImgName[indexPath.row] as! String)
        cell.selectedBackgroundView = UIView.init(frame: cell.frame)
        cell.selectedBackgroundView?.backgroundColor = UIColor.blackColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //if let _ = self.delegate?.respondsToSelector("qhMenu:didSelectRowAtIndexPath:"){
            self.delegate?.qhMenu(tableView, didSelectRowAtIndexPath: indexPath)
        //}
        
        self.dismissWithCompletion(nil)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector(Selector("setSeparatorInset:")){
            cell.separatorInset = CellLineEdgeInsets
        }
        if cell.respondsToSelector(Selector("setLayoutMargins:")){
            cell.layoutMargins = CellLineEdgeInsets
        }
    }
    
    func dismissWithCompletion(completion: ((object:QHMenu?) -> Void)?){
        weak var weakSelf = self
        UIView.animateWithDuration(0.1, delay: 0.07, options: .CurveLinear, animations: {
            weakSelf?.alpha = 0
        }, completion: nil)
        UIView.animateWithDuration(0.2, animations: {
            weakSelf!.tableView.frame = CGRectMake(kScreenWidth - LeftToView * 2, weakSelf!.origin.y + TopToView, 0, 0)
        }, completion: {
            finished in
            weakSelf?.removeFromSuperview()
            if let _ = completion{
                completion!(object: weakSelf)
            }
            if let _ = weakSelf!.dismiss{
                weakSelf?.dismiss!()
            }
        })
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: UITouch in touches{
            if touch.view != self.tableView{
                self.dismissWithCompletion(nil)
            }else{
                self.dismissWithCompletion(nil)
            }
        }
        
    }
    
    override func drawRect(rect: CGRect) {
        let context :CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextBeginPath(context)
        CGContextSetLineWidth(context, 0)
        CGContextMoveToPoint(context, kScreenWidth - LeftToView * 2.5, TopToView * 0.5)
        CGContextAddLineToPoint(context, kScreenWidth - LeftToView * 2, TopToView)
        CGContextAddLineToPoint(context, kScreenWidth - LeftToView * 3, TopToView)
        CGContextClosePath(context)
        self.tableView.backgroundColor?.setFill()
        CGContextDrawPath(context, CGPathDrawingMode.FillStroke)
    }
}








