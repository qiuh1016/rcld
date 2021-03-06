//
//  AccountViewController.swift
//  renchuanliandong
//
//  Created by qiuh1016 on 12/15/15.
//  Copyright © 2015 qiuhhong. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .Custom
        transitioningDelegate = self
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var constant:CGFloat = 0
    var accounts = ["412999911", "412999902", "412999903"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.bounces = false
        tableViewHeightConstraint.constant = CGFloat((accounts.count + 1) * 44) + 10
        view.layoutIfNeeded()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AccountViewController.close))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.frame.origin.y += tableViewHeightConstraint.constant
        UIView.animateWithDuration(0.2, animations: {
            self.tableView.frame.origin.y -= self.tableViewHeightConstraint.constant
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animateWithDuration(0.2, animations: {
            self.tableView.frame.origin.y += self.tableViewHeightConstraint.constant
        })
    }
    
    func close(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func clear(){
        close()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == accounts.count{
            let cell = tableView.dequeueReusableCellWithIdentifier("commandCell")
            let clearButton = cell?.viewWithTag(1000) as! UIButton
            let cancleButton = cell?.viewWithTag(1001) as! UIButton
            clearButton.addTarget(self, action: #selector(AccountViewController.clear), forControlEvents: .TouchUpInside)
            cancleButton.addTarget(self, action: #selector(AccountViewController.close), forControlEvents: .TouchUpInside)
            return cell!
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("accountCell")
            let label = cell?.viewWithTag(1000) as! UILabel
            label.text = accounts[indexPath.row]
            return cell!
        }
            
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row != accounts.count{
            close()
        }
    }
    
}

extension AccountViewController: UIViewControllerTransitioningDelegate{
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
}

extension AccountViewController:UIGestureRecognizerDelegate{
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}


