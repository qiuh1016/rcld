//
//  guijixianshiViewController.swift
//  huilvchaxun
//
//  Created by qiuhong on 11/24/15.
//  Copyright © 2015 qiuhhong. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class routeDisplayViewController: UIViewController ,MKMapViewDelegate{
    
    
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var fullScreenButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBAction func setRegion() {
        mapView.setRegion(lineRegion(cllocation), animated: true)
    }
    
    @IBAction func mapTypeChange() {
        if segment.selectedSegmentIndex == 0{
            mapView.mapType = .Standard
        }else{
            mapView.mapType = .Satellite
        }
    }

    var timeText1 = ""
    var timeText2 = ""
    var weizhi:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 30.591819, longitude: 121.15448)
    var cllocation = [CLLocationCoordinate2D]()
    var showMiddleAnnotation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        label1.text = timeText1
        label2.text = timeText2
        
        //显示海里
        let s = NSString(format: "%.2f", self.getnmiDistance(self.cllocation))
        self.distanceLabel.text = "\(s)nm   共\(self.cllocation.count)个点"
        self.fullScreenButton.hidden = false
        //显示轨迹
        self.loadLinesOnMap(self.cllocation)
        
        //显示大头钉📍
        afterDelay(1.2){
            self.showAnnotation()
        }

        //地图范围
        afterDelay(0.5){
            self.setRegion()
        }
        
    }
    
    func loadLinesOnMap (LocationsArray:[CLLocationCoordinate2D] ){
        var coordinate2dS = LocationsArray.map({
            (location:CLLocationCoordinate2D) -> CLLocationCoordinate2D in return location
        })  //change cllocation to coordinate
        let line:MKPolyline = MKPolyline(coordinates: &coordinate2dS, count: LocationsArray.count)
        mapView.addOverlay(line)
    }
    
    //mapView delegate
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.blueColor()
        polylineRenderer.lineWidth = 2.0
        return polylineRenderer
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let ak: MKAnnotationView = MKAnnotationView.init()
        if annotation.title! == "终点"{
            ak.image = UIImage(named: "routeEndPoint")
        }else if annotation.title! == "起点"{
            ak.image = UIImage(named: "routeStartPoint")
        }else{
            ak.image = UIImage(named: "routeMediaPoint")
        }
        return ak
    }
    
    func lineRegion(coor2ds:Array<CLLocationCoordinate2D>)->MKCoordinateRegion{
        let latitudes=coor2ds.map({
            (co:CLLocationCoordinate2D) -> Double in return co.latitude
        })
        let longtitudes = coor2ds.map({
            (co:CLLocationCoordinate2D)->Double in return co.longitude
        })
        let latitudeMaxMin = maxAndMin(latitudes)
        let longitudeMaxMin = maxAndMin(longtitudes)
        let latitudeSpan = (latitudeMaxMin.max - latitudeMaxMin.min) * 1.5 //顶着边不好看，所以乘了0.2
        let longtideSpan = (longitudeMaxMin.max - longitudeMaxMin.min) * 1.5
        let span :MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: (latitudeSpan), longitudeDelta: (longtideSpan))
        let centerCoor:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (latitudeMaxMin.max + latitudeMaxMin.min)/2, longitude: (longitudeMaxMin.max+longitudeMaxMin.min)/2)
        let region :MKCoordinateRegion = MKCoordinateRegion(center: centerCoor, span: span)
        return region
    }
    
    func maxAndMin( ones:[Double]) -> (max:Double,min:Double){
        var max = ones[0]
        var min = ones[0]
        for o in ones {
            if o > max {
                max = o
            }
            if o < min {
                min = o
            }
        }
        return (max,min)
    }

    //取得两点间的距离
    func getDistance(point1: CLLocationCoordinate2D, point2: CLLocationCoordinate2D) -> Double{
        if point1.latitude == point2.latitude && point1.longitude == point2.longitude{
            return 0
        }else{
            let a = rad(point1.latitude) - rad(point2.latitude)
            let b = rad(point1.longitude) - rad(point2.longitude)
            var s = 2 * asin(sqrt(pow(sin(a / 2), 2) + cos(rad(point1.latitude)) * cos(rad(point2.latitude)) * pow(sin(b / 2),2)))
            s = s * EARTH_RADIUS
            return abs(s)
        }
    }
    
    func rad(d: Double) -> Double{
        return d * PI / 180.0
    }
    
    //取一个数组的总里程，以海里为单位
    func getnmiDistance(location : [CLLocationCoordinate2D]) -> Double{
        var i = 0
        let num = location.count
        var distance :Double = 0
        while i < num - 1{
            let s = getDistance(location[i], point2: location[i + 1])
            distance += s
            i += 1
        }
        return distance / 1.85101
    }
    
    func showAnnotation(){
        //增加中间点大头针
        if showMiddleAnnotation{
            for i in 1 ... cllocation.count - 2{
                let annotation3 = MKPointAnnotation()
                annotation3.title = "中间点"
                annotation3.coordinate = cllocation[i]
                mapView.addAnnotation(annotation3)
            }
        }
        
        afterDelay(0.2){
            let annotation1 = MKPointAnnotation()
            annotation1.coordinate = self.cllocation[0]
            annotation1.title = "起点"
            //annotation1.subtitle = timeText1
            
            let annotation2 = MKPointAnnotation()
            annotation2.coordinate = self.cllocation[self.cllocation.count - 1]
            annotation2.title = "终点"
            //annotation2.subtitle = timeText2
            self.mapView.addAnnotations([annotation1, annotation2])
        }
        
        //self.mapView.selectAnnotation(annotation2, animated: true)
    }
    
}











