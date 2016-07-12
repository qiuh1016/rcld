//
//  QRCodeViewController.swift
//  renchuanliandong
//
//  Created by qiuhong on 11/27/15.
//  Copyright © 2015 qiuhhong. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    let screenSize = UIScreen.mainScreen().bounds.size
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHight = UIScreen.mainScreen().bounds.size.height
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    var shadowView: UIView!
    var line: UIImageView!
    var lineMovePoint: CGFloat = 0.0
    
    //用于判断二维码大小
    var blueViewSize: CGFloat = 0.0
    var blueViewX: CGFloat = 0.0
    var blueViewY: CGFloat = 0.0
    
    let device: AVCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    var isLghtOn: Bool = false
    var hasDrawShadowAndButton: Bool = false
    
    var result = ""
    
    var lightButton: UIButton!
    
    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func fromAlbum(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .PhotoLibrary
            self.presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //先清除内容
        result = ""
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        print(UIImagePNGRepresentation(image)?.length)
        let ciImage:CIImage = CIImage(image: image)!
        let context = CIContext(options: nil)
        let detector:CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
        let features = detector.featuresInImage(ciImage)
        for feature in features as! [CIQRCodeFeature]{
            print(feature.messageString)
            result = feature.messageString
            
//            result = result.stringByReplacingOccurrencesOfString("ﾖﾆｿｨﾈﾕﾆﾚ", withString: "制卡日期")
//            result = converTo(result)
        }
        
        dismissViewControllerAnimated(false, completion: nil)
        
        if !result.isEmpty{
            let hudView = HudView.hudInView(self.view, animated: true)
            hudView.text = "扫描中"
            afterDelay(0.7){
                self.playSystemSound()
                hudView.hideAnimated(self.view, animated: false)
                if self.result.hasPrefix("http://") || self.result.hasPrefix("https://"){
                    let url = NSURL(string: self.result)
                    UIApplication.sharedApplication().openURL(url!)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }else{
                    self.performSegueWithIdentifier("ShowQRCodeResultSegue", sender: nil)
                }
            }
        }else{
            let okView = OKView.hudInView(self.view, animated: true)
            okView.text = "无内容"
            okView.imagename = "error"
            afterDelay(0.7){
                okView.hideAnimated(self.view, animated: false)
            }
        }
        
    }
    
    func lightButtonTapped() {
        
        if isLghtOn {
            isLghtOn=false
            turnoffLed()
            lightButton!.setImage(UIImage(named: "lightSelect"), forState: .Normal)
        } else {
            isLghtOn=true
            turnOnLed()
            lightButton!.setImage(UIImage(named: "lightNormal"), forState: .Normal)
        }
        
    }
    
    func turnOnLed(){
        do{
            try device.lockForConfiguration()
            device.torchMode = AVCaptureTorchMode.On
            device.unlockForConfiguration()
        }catch{
            
        }
    }
    
    func turnoffLed(){
        do{
            try device.lockForConfiguration()
            device.torchMode = AVCaptureTorchMode.Off
            device.unlockForConfiguration()
        }catch{
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

        let hudView = HudView.hudInView(self.view, animated: true)
        hudView.text = "启动中"
        
        afterDelay(0.3){
            
            hudView.hideAnimated(self.view, animated: false)
            self.captureSession?.startRunning()
            if !self.hasDrawShadowAndButton{
                self.setupScanView()
                self.shadowView = self.makeScanShadowView(innerRect: self.makeScanReaderRect())
                self.view.addSubview(self.shadowView!)
                self.drawLightButton()
                self.hasDrawShadowAndButton = true
                
            }
            self.drawLine()
            UIView.animateWithDuration(2.5, delay: 0.5, options: [.Repeat, .CurveLinear], animations: {
                self.line.center.y += self.lineMovePoint
                }, completion: nil)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.line.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
//            let hudView = HudView.hudInView(self.view, animated: true)
//            hudView.text = "启动中"
//            afterDelay(0.3){
//                hudView.hideAnimated(self.view, animated: false)
//                self.captureSession?.startRunning()
//            }
            
            // Move the message label to the top view
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                //为了不显示边框 把透明度调为0
                //qrCodeFrameView.layer.borderColor = UIColor.greenColor().CGColor
                qrCodeFrameView.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0).CGColor
                
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
            }
            
        } catch {
            alertView("摄像头打开失败", message: "请在设置－隐私－相机中打开软件的许可!", okActionTitle: "好的", okHandler: nil, viewController: self)
            return
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func playSystemSound(){
        var soundID:SystemSoundID = 0
        let path = NSBundle.mainBundle().pathForResource("noticeMusic", ofType: "wav")
        let baseURL = NSURL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(baseURL, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    
    // MARK: - draw
    func makeScanReaderRect() -> CGRect{
        let scanSize = (min(screenWidth, screenHight) * 3) / 5
        var scanRect = CGRect(x: 0, y: 0, width: scanSize, height: scanSize)
        scanRect.origin.x += (screenWidth - scanRect.size.width) / 2
        scanRect.origin.y += (screenHight - scanRect.size.height) / 2 //- 64
        
        //用于控制二维码扫描的大小
        blueViewSize = scanSize
        blueViewX = scanRect.origin.x
        blueViewY = scanRect.origin.y
        return scanRect
    }
    
    func setupScanView(){
        let rect = makeScanReaderRect()
        var imageSize: CGFloat = 20.0
        let imageX = rect.origin.x
        let imageY = rect.origin.y
        let width = rect.size.width
        let height = rect.size.height
        
        //四个角
        let imageViewTL = UIImageView(frame: CGRectMake(imageX, imageY, imageSize, imageSize))
        imageViewTL.image = UIImage(named: "scan_tl")
        imageSize = (imageViewTL.image?.size.width)!
        self.view.addSubview(imageViewTL)
        
        let imageViewTR = UIImageView(frame: CGRectMake(imageX + width - imageSize, imageY, imageSize, imageSize))
        imageViewTR.image = UIImage(named: "scan_tr")
        self.view.addSubview(imageViewTR)
        
        let imageViewBL = UIImageView(frame: CGRectMake(imageX, imageY + height - imageSize, imageSize, imageSize))
        imageViewBL.image = UIImage(named: "scan_bl")
        self.view.addSubview(imageViewBL)
        
        let imageViewBR = UIImageView(frame: CGRectMake(imageX + width - imageSize, imageY + height - imageSize, imageSize, imageSize))
        imageViewBR.image = UIImage(named: "scan_br")
        self.view.addSubview(imageViewBR)
        
    }
    
    func drawLine(){
        let rect = makeScanReaderRect()
        line = UIImageView(frame: CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 2))
        line!.image = UIImage(named: "scan_line")
        self.view.addSubview(line!)
        lineMovePoint = rect.size.width - CGFloat(2.0)
    }
    
    func makeScanShadowView(innerRect innerRect: CGRect) -> UIView{
        let referenceImage = UIImageView(frame: self.view.bounds)
        UIGraphicsBeginImageContext(referenceImage.frame.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetRGBFillColor(context, 0, 0, 0, 0.5)
        var drawRect = CGRectMake(0, 0, screenWidth, screenHight)
        CGContextFillRect(context, drawRect)
        drawRect = CGRectMake(innerRect.origin.x - referenceImage.frame.origin.x, innerRect.origin.y - referenceImage.frame.origin.y, innerRect.size.width, innerRect.size.height)
        CGContextClearRect(context, drawRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        referenceImage.image = image
        return referenceImage
    }
    
    func drawLightButton(){
        if device.hasTorch  //判断设备有没有闪光灯
        {
            let remaindSpaceHeight = (screenHight - (screenWidth * 3) / 5 - 40.0) / 2
            let buttonSize = remaindSpaceHeight / 4
            let buttonX = screenWidth / 2 - buttonSize / 2
            let buttonY = screenHight - (remaindSpaceHeight * 3.5) / 5 //- 64
            lightButton = UIButton(frame: CGRectMake(buttonX, buttonY, buttonSize, buttonSize))
            lightButton.setImage(UIImage(named: "lightSelect"), forState: .Normal)
            lightButton.addTarget(self, action: #selector(QRCodeViewController.lightButtonTapped), forControlEvents: .TouchUpInside)
            view.addSubview(lightButton)
            view.bringSubviewToFront(lightButton)
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowQRCodeResultSegue"{
            let viewController = segue.destinationViewController as! QRCodeResultViewController
            viewController.result = result
        }
    }
    
    // MARK: - delegate
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        
        //let str = NSString(data: metadataObj, encoding: NSUTF8StringEncoding)
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            let qrcodeX = qrCodeFrameView?.frame.origin.x
            let qrcodeY = qrCodeFrameView?.frame.origin.y
            let qrcodeHight = qrCodeFrameView?.frame.size.height
            let qrcodeWidth = qrCodeFrameView?.frame.size.width
          

            //二维码 在指定区域内的时候 且 高度大于blueVeiw的1/3
            if  qrcodeX >= blueViewX && qrcodeX! + qrcodeWidth! <= blueViewX + blueViewSize && qrcodeY >= blueViewY && qrcodeY! + qrcodeHight! <= blueViewY + blueViewSize && qrcodeHight >= blueViewSize / 3{

                if metadataObj.stringValue != nil {
                    
                    self.result = metadataObj.stringValue
                    
                    self.result = converTo(result)

                    
                    
                    print("result: \(self.result)")

                    
                    //播放声音
                    self.playSystemSound()
                    
                    //暂停
                    self.captureSession?.stopRunning()
                    
                    //去掉绿框
                    self.qrCodeFrameView?.frame = CGRectZero
                    
                    if result.hasPrefix("http://") || result.hasPrefix("https://"){
                        let url = NSURL(string: result)
                        UIApplication.sharedApplication().openURL(url!)
                        dismissViewControllerAnimated(true, completion: nil)
                    }else{
                        self.performSegueWithIdentifier("ShowQRCodeResultSegue", sender: nil)
                    }
                }
            }
        }
    }
    
    
}
