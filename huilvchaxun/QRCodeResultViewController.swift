//
//  QRCodeResultViewController.swift
//  renchuanliandong
//
//  Created by qiuhong on 11/29/15.
//  Copyright © 2015 qiuhhong. All rights reserved.
//

import UIKit

class QRCodeResultViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func returnButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    var result = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        result = result.stringByReplacingOccurrencesOfString("Óæ´¬Éí·Ý±êÇ©;Óæ´¬±àÂë", withString: "渔船身份标签;渔船编号")
//        result = result.stringByReplacingOccurrencesOfString("´¬Ãû", withString: "船名")
//        result = result.stringByReplacingOccurrencesOfString("´¬³¤", withString: "船长")
//        result = result.stringByReplacingOccurrencesOfString("ÉÏ¼×°å³¤¶È", withString: "上甲板长度")
//        result = result.stringByReplacingOccurrencesOfString("´¬¿í", withString: "船宽")
//        result = result.stringByReplacingOccurrencesOfString("´¬Éî", withString: "船深")
//        result = result.stringByReplacingOccurrencesOfString("²ÄÖÊ", withString: "材质")
//        result = result.stringByReplacingOccurrencesOfString("½¨³ÉÈÕÆÚ", withString: "建成日期")
//        result = result.stringByReplacingOccurrencesOfString("ﾖﾆｿｨﾈﾕﾆﾚ", withString: "制卡日期")
//        
//        result = result.stringByReplacingOccurrencesOfString("Õã¼ÎÓæ", withString: "浙嘉渔")
//        result = result.stringByReplacingOccurrencesOfString("¸ÖË¿ÍøË®Äà", withString: "钢丝网水泥")
//        
//        self.result = converTo(result)
        
        resultLabel.text = result
        resultLabel.adjustsFontSizeToFitWidth = true
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
