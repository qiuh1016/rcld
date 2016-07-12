//
//  CurrencyViewController.swift
//  huilvchaxun
//
//  Created by qiuhong on 11/16/15.
//  Copyright © 2015 qiuhhong. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON
import CoreLocation

class myShipViewController: UIViewController , QHMenuDelegate ,CLLocationManagerDelegate, MKMapViewDelegate{
    
    @IBOutlet weak var shipNameLabel: UILabel!
    @IBOutlet weak var shipNumLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTotopConstaint: NSLayoutConstraint!
    @IBOutlet weak var mapToRightConstaint: NSLayoutConstraint!
    @IBOutlet weak var mapToBottomConstaint: NSLayoutConstraint!
    @IBOutlet weak var mapToLeftConstaint: NSLayoutConstraint!
    
    @IBOutlet weak var lockButton: UIButton!
    
    @IBOutlet weak var drawLineButton: UIButton!
    
    @IBOutlet weak var showMyLocationButton: UIButton!
    @IBOutlet weak var showShipLocationButton: UIButton!
    
    @IBOutlet weak var fullScreenButton: UIButton!
    
    @IBOutlet weak var fullScreenPopTip: UIButton!
    
    @IBAction func fullScreenPopTipTapped() {
        
        self.fullScreenPopTip.hidden = true
        let okHandler = {(action:UIAlertAction!) -> Void in
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "fullScreenPopTipNeverShow")
        }
        alertView("提示", message: "不再显示提示?", okActionTitle: "是的", cancleActionTitle: "取消", okHandler: okHandler, viewController: self)

    }
    
    @IBAction func lockButtonTapped() {
        
        if isLocked{
            
            let okHandler = {(action:UIAlertAction!) -> Void in
                let hudView = HudView.hudInView(self.view, animated: false)
                hudView.text = "关闭中"
                
                afterDelay(1.0){
                    hudView.hideAnimated(self.view, animated: false)
                    alertView("提示", message: "已关闭防盗!", okActionTitle: "好的", okHandler: nil, viewController: self)
                    self.lockButton.setTitle("开启防盗", forState: .Normal)
                    self.lockButton.backgroundColor = self.unlockColor
                    
                }
                self.isLocked = false
            }
            
            alertView("提示", message: "即将关闭防盗，是否继续?", okActionTitle: "是的", cancleActionTitle: "取消", okHandler: okHandler, viewController: self)
            
        }else{
            
            let hudView = HudView.hudInView(self.view, animated: false)
            hudView.text = "开启中"
            
            afterDelay(1.0){
                hudView.hideAnimated(self.view, animated: false)
                alertView("提示", message: "已开启防盗!", okActionTitle: "好的", okHandler: nil, viewController: self)
                self.lockButton.setTitle("关闭防盗", forState: .Normal)
                self.lockButton.backgroundColor = self.lockedColor
            }
            isLocked = true
           
        }
        
    }
    
//    @IBAction func lightButtonTapped() {
//        
//        let hudView = HudView.hudInView(self.view, animated: false)
//        hudView.text = "开启中"
//        
//        Alamofire.request(.GET, httpLight).responseData{
//            response in
//            switch response.result{
//            case .Success:
//                
//                if let value = response.result.value{
//                    
//                    let str = NSString(data: value, encoding: NSUTF8StringEncoding)
//                    let valueShuangyinhao = str!.stringByReplacingOccurrencesOfString("'", withString: "\"") as NSString
//                    let nsDatajson = valueShuangyinhao.dataUsingEncoding(NSUTF8StringEncoding)
//                    let json = JSON(data: nsDatajson!)
//                    
//                    if json["result"] == "1"{
//                        hudView.hideAnimated(self.view, animated: false)
//                        alertView("提示", message: "已开启灯光，稍后将自动熄灭!", okActionTitle: "好的", okHandler: nil, viewController: self)
//                    }else{
//                        hudView.hideAnimated(self.view, animated: false)
//                        alertView("提示", message: "开灯失败，请稍后再试!", okActionTitle: "好的", okHandler: nil, viewController: self)
//                    }
//                    
//                }
//                
//            case .Failure:
//                hudView.hideAnimated(self.view, animated: false)
//                alertView("提示", message: "通信故障，无法开启灯光!", okActionTitle: "好的", okHandler: nil, viewController: self)
//            }
//        }
//    }
    
    @IBAction func drawLineToShip() {
        if mapView.userLocation.coordinate.latitude != 0 && mapView.userLocation.coordinate.longitude != 0{
            if let _ = line{
                mapView.removeOverlay(line!)
                line = nil
            }else{
                if mapView.userLocation.coordinate.latitude != 0 && mapView.userLocation.coordinate.longitude != 0{
                    let mineAndShipLocation = [mapView.userLocation.coordinate , shipLocation]
                    loadLinesOnMap(mineAndShipLocation)
                }
            }
        }else{
            let hudView = HudView.hudInView(self.view, animated: true)
            hudView.text = "定位中"
            afterDelay(0.5){
                hudView.hideAnimated(self.view, animated: true)
            }
        }
    }
    
    @IBAction func showShipLocation() {
        self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(self.shipLocation, 1000, 1000), animated: true)
    }
    
    @IBAction func showMyLocation() {
        
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .NotDetermined{
            locationManager.requestWhenInUseAuthorization()
        }else if authStatus == .Denied || authStatus == .Restricted{
            showLocationServiceDeniedAlert()
        }else{
            if mapView.userLocation.coordinate.latitude != 0 && mapView.userLocation.coordinate.longitude != 0{
                let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
                mapView.setRegion(mapView.regionThatFits(region), animated: true)
                
            }else{
                let hudView = HudView.hudInView(self.view, animated: true)
                hudView.text = "定位中"
                afterDelay(0.5){
                    hudView.hideAnimated(self.view, animated: true)
                }
            }
        }
    }
    
    @IBAction func FullScreen() {
        
        if isFullScreen{
            fullScreenButton.setImage(UIImage(named: "fullScreen"), forState: .Normal)
            mapTotopConstaint.constant = lockButton.superview!.frame.maxY + 5
            mapToBottomConstaint.constant = 20
            mapToLeftConstaint.constant = 0
            mapToRightConstaint.constant = 0
            UIView.animateWithDuration(0.3, animations: {
                self.view.layoutIfNeeded()
                
                self.shipNameLabel.alpha = 1
                self.shipNumLabel.alpha = 1
                self.drawLineButton.alpha = 0
                self.lockButton.alpha = 1
//                self.locationButton.alpha = 0
                self.showMyLocationButton.alpha = 0
                self.showShipLocationButton.alpha = 0
            })
            isFullScreen = false
            
            view.bringSubviewToFront(shipNameLabel)
            view.bringSubviewToFront(view)
            
        }else{
            fullScreenButton.setImage(UIImage(named: "unfullScreen"), forState: .Normal)
            mapTotopConstaint.constant = 0
            mapToBottomConstaint.constant = 0
            mapToLeftConstaint.constant = -20
            mapToRightConstaint.constant = -20
            UIView.animateWithDuration(0.3, animations: {
                self.view.layoutIfNeeded()
                
                self.shipNameLabel.alpha = 0
                self.shipNumLabel.alpha = 0
                
                self.lockButton.alpha = 0
                
                self.drawLineButton.alpha = 1
//                self.locationButton.alpha = 1
                self.showMyLocationButton.alpha = 1
                self.showShipLocationButton.alpha = 1
            })
            isFullScreen = true
            
            view.bringSubviewToFront(mapView)
            view.bringSubviewToFront(fullScreenButton)
            view.bringSubviewToFront(showShipLocationButton)
            view.bringSubviewToFront(showMyLocationButton)
            view.bringSubviewToFront(drawLineButton)
            
        }
    }
    
    let unlockColor = UIColor(red: 75/255, green: 194/255, blue: 112/255, alpha: 1)
    let lockedColor = UIColor(red: 249/255, green: 24/255, blue: 109/255, alpha: 1)
    var isFullScreen = false
    var isLocked = false
    var line:MKPolyline?
    
    let locationManager  = CLLocationManager()
    var location: CLLocation?
    var updatingLocation = false

    var menu:QHMenu?
    var shipLocation:CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lockButton.backgroundColor = unlockColor
        mapView.delegate = self
        
        
        
        //设置内容
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let shipName     = defaults.objectForKey("shipName")! as! String
        //let shipNo       = defaults.objectForKey("shipNo")! as! String
        let ownerName    = defaults.objectForKey("ownerName")! as! String
        let ownerTelNo   = defaults.objectForKey("ownerTelNo")! as! String
        let deviceNo     = defaults.objectForKey("deviceNo")! as! String
        let offlineFlag  = defaults.boolForKey("offlineFlag") ? "是" : "否"
        let cfsStartDate = defaults.objectForKey("cfsStartDate")! as! String
        let cfsEndDate   = defaults.objectForKey("cfsEndDate")! as! String
        var isInFence    = false
        if let fenceNo = defaults.objectForKey("fenceNo") {
            if fenceNo as! String != "" {
                isInFence = true
            }
        }
        
        
        
        self.shipNameLabel.text = "  船名：\(shipName)"
        let shipNumLabelText = "船东：\(ownerName)\n" +
            "电话：\(ownerTelNo)\n" +
            "终端序号：\(deviceNo)\n" +
            "是否在线：\(offlineFlag)\n" +
            "是否在港：\(isInFence ? "是" : "否")\n" +
            "伏休期起始日期：\(cfsStartDate)\n" +
            "伏休期结束日期：\(cfsEndDate)"
        
        let attrubutedString = NSMutableAttributedString(string: shipNumLabelText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        attrubutedString.addAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, attrubutedString.length))
        self.shipNumLabel.attributedText = attrubutedString

        
        self.shipLocation.latitude = defaults.doubleForKey("latitude")
        self.shipLocation.longitude = defaults.doubleForKey("longitude")
        
        
        
        //纠偏
        shipLocation = realLocation(shipLocation)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = self.shipLocation
        annotation.title = "\(defaults.objectForKey("shipName")!)"
        annotation.subtitle = "终端序号：\(defaults.objectForKey("deviceNo")!)"
        self.mapView.addAnnotation(annotation)
        self.mapView.selectAnnotation(annotation, animated: true)
        showShipLocation()
        
        //设置右导航按钮
        self.navigationController?.navigationBar.translucent = false
        let rightItemButton = UIBarButtonItem.init(image: UIImage(named: "barItemButton"), style: .Plain, target: self, action: #selector(myShipViewController.showCustomMenu(_:)))
        self.navigationItem.rightBarButtonItem = rightItemButton
        
        //get user authorization
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .NotDetermined{
            locationManager.requestWhenInUseAuthorization()
        }else if authStatus == .Denied || authStatus == .Restricted{
            afterDelay(0.5){
                self.showLocationServiceDeniedAlert()
            }
        }
        
        //全屏提示
        let fullScreenPopTipNeverShow = NSUserDefaults.standardUserDefaults().boolForKey("fullScreenPopTipNeverShow")
        if !fullScreenPopTipNeverShow{
            self.fullScreenPopTip.hidden = false
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.view.layoutIfNeeded()
        if isFullScreen{
            self.drawLineButton.alpha = 1
            self.showMyLocationButton.alpha = 1
            self.showShipLocationButton.alpha = 1
        }else{
            self.drawLineButton.alpha = 0
            self.showMyLocationButton.alpha = 0
            self.showShipLocationButton.alpha = 0
        }
        
        //地图约束
        mapTotopConstaint.constant = lockButton.superview!.frame.maxY + 5
        self.view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //小菜单
    func showCustomMenu(barButtonItem: UIBarButtonItem){
        weak var weakSelf = self
        if let menu = menu{
            menu.dismissWithCompletion({
             Void in
                weakSelf?.menu = nil
            })
        }else{
            self.menu = QHMenu.init(dataArr: ["信息修改", "出海确认", "回港确认", "出海记录", "返回首页"], origin: CGPointMake(self.view.bounds.width - 150 , 0), width: 125, rowHeight: 44)
            menu!.delegate = self
            menu!.dismiss =  { [weak self] in
                   self?.menu = nil
            }
            menu!.arrImgName = ["item_school.png", "item_chat.png", "item_chat.png", "item_list.png","item_share.png"]
            self.view.addSubview(menu!)
        }
    }
    
    var iofFlag = Int()  //  1 出海  2 回港
    
    func qhMenu(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch (indexPath.row){
        case 0:
            //print("qhMenu")
            performSegueWithIdentifier("changeInfoSegue", sender: nil)
        case 1:
            iofFlag = 1
            performSegueWithIdentifier("showStaffSegue", sender: nil)
        case 2:
            iofFlag = 2
            performSegueWithIdentifier("showStaffSegue", sender: nil)
        case 3:
            performSegueWithIdentifier("showStaffHistorySegue", sender: nil)
        case 4:
            self.navigationController?.popToRootViewControllerAnimated(true)
        default:
            break
        }
        
    }
    
    func showLocationServiceDeniedAlert(){
        alertView("定位服务没有打开", message: "请在设置－隐私－定位中打开软件的定位服务！", okActionTitle: "好的", okHandler: nil, viewController: self)
    }

    func loadLinesOnMap (LocationsArray:[CLLocationCoordinate2D] ){
        
        var coordinate2dS = LocationsArray.map({
        (location:CLLocationCoordinate2D) -> CLLocationCoordinate2D in return location
        })  //change cllocation to coordinate
        line  = MKPolyline(coordinates: &coordinate2dS, count: LocationsArray.count)

        mapView.addOverlay(line!)
        
    }
    
    //mapView delegate
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
       
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.blueColor()
        polylineRenderer.lineWidth = 2.0
        return polylineRenderer
 
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showStaffSegue"{
            let vc = segue.destinationViewController as! punchViewController
            vc.iofFlag = iofFlag
        }
    }
    
}










