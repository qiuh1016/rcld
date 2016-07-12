//
//  sailDetailViewController.swift
//  renchuanliandong
//
//  Created by 裘鸿 on 1/15/16.
//  Copyright © 2016 qiuhhong. All rights reserved.
//

import UIKit

class sailDetailViewController: UITableViewController {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        alertView("提示", message: "船员姓名：船员3\n删除原因：xxxxxx", okActionTitle: "好的", okHandler: nil, viewController: self)
    }
    
}
