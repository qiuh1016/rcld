//
//  bangzhuViewController.swift
//  huilvchaxun
//
//  Created by qiuhong on 11/24/15.
//  Copyright © 2015 qiuhhong. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import MessageUI

class helpViewController: UIViewController,MKMapViewDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let comLocation : MapPin = MapPin.init(coordinate: CLLocationCoordinate2D.init(latitude: 29.884530, longitude: 121.638971), title: "gongsi", subtitle: "dizhi")
    let yuyejuLocation:  MapPin = MapPin.init(coordinate: CLLocationCoordinate2D.init(latitude: 30.272755, longitude: 120.149085), title: "gongsi", subtitle: "dizhi")
    
    @IBAction func tapped(sender: AnyObject) {
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(yuyejuLocation.coordinate, 3000, 3000), animated: true)
    }
   
    @IBAction func sendEMail() {
        if MFMailComposeViewController.canSendMail(){
            
            let controller = MFMailComposeViewController()
            //设置代理
            controller.mailComposeDelegate = self
            //设置主题
            controller.setSubject("")
            //设置收件人
            controller.setToRecipients(["system@zjoaf.gov.cn"])
            //设置抄送人
            //controller.setCcRecipients(["b1@hangge.com","b2@hangge.com"])
            //设置密送人
            //controller.setBccRecipients(["c1@hangge.com","c2@hangge.com"])
            
            //添加图片附件
            //let path = NSBundle.mainBundle().pathForResource("hangge.png", ofType: "")
            //let myData = NSData(contentsOfFile: path!)
            //controller.addAttachmentData(myData!, mimeType: "image/png", fileName: "swift.png")
            
            //设置邮件正文内容（支持html）
            controller.setMessageBody("", isHTML: false)
            
            //打开界面
            self.presentViewController(controller, animated: true, completion: nil)
        }else{
            print("本设备不能发送邮件")
        }
    }
    
    @IBAction func tel(sender: AnyObject) {
        let okHandler = {(action:UIAlertAction!) -> Void in
            let url = NSURL(string: "tel://0571-88007090")
            UIApplication.sharedApplication().openURL(url!)
        }
        alertView("提示", message: "即将拨打电话，是否继续?", okActionTitle: "拨打", cancleActionTitle: "取消", okHandler: okHandler, viewController: self)
    }
    
    @IBAction func openURL(sender: AnyObject) {
        let okHandler = {(action:UIAlertAction!) -> Void in
            let url = NSURL(string: "http://www.zjoaf.gov.cn")
            UIApplication.sharedApplication().openURL(url!)
        }
        alertView("提示", message: "即将打开官网，是否继续?", okActionTitle: "打开", cancleActionTitle: "取消", okHandler: okHandler, viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(yuyejuLocation.coordinate, 3000, 3000), animated: true)
        
        let annotation = MKPointAnnotation()
 //       annotation.coordinate = comLocation.coordinate
//        annotation.title = "海洋电子研究院"
//        annotation.subtitle = "宁波高新区扬帆路999弄研发园B区5号楼"
        annotation.coordinate = yuyejuLocation.coordinate
        annotation.title = "浙江省海洋与渔业局"
        annotation.subtitle = "杭州市天目山路102号"
        self.mapView.addAnnotation(annotation)
        self.mapView.selectAnnotation(annotation, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        switch result.rawValue{
        case MFMailComposeResultSent.rawValue:
            print("邮件已发送")
        case MFMailComposeResultCancelled.rawValue:
            print("邮件已取消")
        case MFMailComposeResultSaved.rawValue:
            print("邮件已保存")
        case MFMailComposeResultFailed.rawValue:
            print("邮件发送失败")
        default:
            print("邮件没有发送")
            break
        }
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
