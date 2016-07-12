//
//  Functions.swift
//  huilvchaxun
//
//  Created by qiuhong on 11/24/15.
//  Copyright © 2015 qiuhhong. All rights reserved.
//

import Foundation
import Dispatch
import UIKit
import CoreLocation
import AVFoundation

//实际位置需加上dCoordinate
let dCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: -0.00193 , longitude: 0.00416)

let PI = 3.14159265358979323846
let EARTH_RADIUS = 6378.137

let screenW = UIScreen.mainScreen().bounds.width
let screenH = UIScreen.mainScreen().bounds.height

let UserDefaults = NSUserDefaults.standardUserDefaults()

func afterDelay(seconds: Double, closure: () -> ()) {
    let when = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
    dispatch_after(when, dispatch_get_main_queue(), closure)
}

func alertView(title: String, message: String, okActionTitle: String, cancleActionTitle: String, okHandler: ((action: UIAlertAction!) -> Void)?, viewController: UIViewController){
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    let cancelAction = UIAlertAction(title: cancleActionTitle, style: UIAlertActionStyle.Cancel, handler: nil)
    let okAction = UIAlertAction(title: okActionTitle, style: UIAlertActionStyle.Destructive, handler: okHandler)
    alert.addAction(cancelAction)
    alert.addAction(okAction)
    viewController.presentViewController(alert, animated: true, completion: nil)
}

func alertView(title: String, message: String, okActionTitle: String, okHandler: ((action: UIAlertAction!) -> Void)?, viewController: UIViewController){
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    let okAction = UIAlertAction(title: okActionTitle, style: UIAlertActionStyle.Default, handler: okHandler)
    alert.addAction(okAction)
    viewController.presentViewController(alert, animated: true, completion: nil)
}

func realLocation(locations: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D]{
    var realLocations = [CLLocationCoordinate2D]()
    for location in locations{
        let realLocation: CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: location.latitude + dCoordinate.latitude, longitude: location.longitude + dCoordinate.longitude)
        realLocations.append(realLocation)
    }
    return realLocations
}

func realLocation(location: CLLocationCoordinate2D) -> CLLocationCoordinate2D{
    let realLocation: CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: location.latitude + dCoordinate.latitude, longitude: location.longitude + dCoordinate.longitude)
    return realLocation
}

func playSystemSound(){
    var soundID:SystemSoundID = 0
    let path = NSBundle.mainBundle().pathForResource("noticeMusic", ofType: "wav")
    let baseURL = NSURL(fileURLWithPath: path!)
    AudioServicesCreateSystemSoundID(baseURL, &soundID)
    AudioServicesPlaySystemSound(soundID)
}

func showDate() -> String {
    let timeFormatter = NSDateFormatter()
    timeFormatter.dateFormat = "YYYY-MM-dd" //"YYYY-MM-dd HH:mm"
    let date = timeFormatter.stringFromDate(NSDate())
    return date
}

func isTelNumber(num: NSString) -> Bool {
    let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
    let CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
    let CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
    let CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
    let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
    let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
    let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
    let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
    if ((regextestmobile.evaluateWithObject(num) == true)
        || (regextestcm.evaluateWithObject(num)  == true)
        || (regextestct.evaluateWithObject(num) == true)
        || (regextestcu.evaluateWithObject(num) == true)) {
        return true
    } else {
        return false
    }
}

extension UIColor {
    
    class func colorFromRGB(rgbValue: UInt, alpha: CGFloat) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    class func RGBColor(red red: Double, green: Double, blue: Double, alpha: Double) -> UIColor {
        return UIColor(red: CGFloat(red / 255), green: CGFloat(green / 255), blue: CGFloat(blue / 255), alpha: CGFloat(alpha))
    }
}

extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex = self.startIndex.advancedBy(r.endIndex)
            
            return self[startIndex ..< endIndex]
        }
    }
}