//
//  aboutViewController.swift
//  renchuanliandong
//
//  Created by qiuhong on 1/8/16.
//  Copyright © 2016 qiuhhong. All rights reserved.
//

import UIKit

class aboutViewController: UIViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    let version = "1.2.2 Demo"
    let content = "1.增加手势解锁功能\n2.增加打卡记录刷新开关及刷新动画\n3.增加清除所有数据功能\n4.修改轨迹显示界面轨迹点图片\n5.船员电子签证演示"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconImageView.layer.cornerRadius = 30
        iconImageView.layer.masksToBounds = true
        versionLabel.text = "系统版本:" + version
        contentLabel.text = "更新内容:\n" + content
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
