//
//  ViewController.swift
//  OnIt-Operator
//
//  Created by ExpDev on 9/16/16.
//  Copyright © 2016 2Create360. All rights reserved.
//

import UIKit
import CoreLocation

import GoogleMaps
import DropDown

class HomeViewController: UIViewController {

    let locationManager = CLLocationManager()
    
    let marker = GMSMarker()
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var buttonRoute: UIButton!
    @IBOutlet var labelDateTime: UILabel!
    @IBOutlet var labelRoute: UILabel!

    let selectRoute = DropDown()
    var curRouteNames:[String] = []
    var curRouteList:[String] = []
    var curRoute:Dictionary<String, NSObject>!
    
    let ROUTES = [
        ["name":"Route 501", "pos_a":"Turner Valley", "pos_b":"Okotoks", "price":2.0, "month_price":99 ],
        ["name":"Route 502", "pos_a":"Turner Valley", "pos_b":"Calgary", "price":8.0, "month_price":99 ],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        buttonRoute.backgroundColor = UIColor.clearColor()
        buttonRoute.layer.cornerRadius = 2
        buttonRoute.layer.borderWidth = 1
        buttonRoute.layer.borderColor = UIColor.blackColor().CGColor
        buttonRoute.contentEdgeInsets = UIEdgeInsetsMake(8,16,8,16)
        
        selectRoute.dismissMode = .OnTap
        selectRoute.direction = .Any
        selectRoute.anchorView = buttonRoute
        selectRoute.topOffset = CGPoint(x:0, y:-buttonRoute.bounds.height - 8)
        selectRoute.bottomOffset = CGPoint(x: 0, y: buttonRoute.bounds.height + 8)
        selectRoute.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.buttonRoute.setTitle(item, forState: .Normal)
            for route in self.ROUTES
            {
                if route["name"] == self.curRouteNames[index]
                {
                    self.curRoute = route
                    let pos_a = route["pos_a"]!
                    let pos_b = route["pos_b"]!
                    self.labelRoute.text = "Location : \(pos_a) : \(pos_b)"
                }
            }
        }
        
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        self.labelDateTime.text = dateFormatter.stringFromDate(currentDate)
        self.labelRoute.text = "Select route"
        
//        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
//            locationManager.startMonitoringSignificantLocationChanges()
//        }
        
        
        print("location service status = \(CLLocationManager.authorizationStatus().rawValue)")
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedWhenInUse, .AuthorizedAlways:
            break
        case .NotDetermined:
            //locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        case .Restricted, .Denied:
            let alertController = UIAlertController(
                title: "Location Access Disabled",
                message: "In order to use this application, please open this app's settings and set location access to 'Always'.",
                preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertController.addAction(openAction)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        
        setRouteList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        print("appear")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onNotifyLocation(_:)), name:"current_location", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("disappear")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @IBAction func onClickSelectRoute(sender: AnyObject) {
        selectRoute.show()
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool
    {
        if let ident = identifier {
            if ident == "startRoute" && self.curRoute == nil {
                SweetAlert().showAlert("Please select a route", subTitle: "", style: AlertStyle.Warning)
                return false
            }
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startRoute"
        {
            let targetVC:MainViewController = segue.destinationViewController as! MainViewController
            targetVC.curRoute = curRoute
        }
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {}

    func setRouteList() {
        self.curRouteNames = []
        self.curRouteList = []
        for route in ROUTES {
            let name:String = route["name"] as! String
            let pos_a = route["pos_a"]!
            let pos_b = route["pos_b"]!
            curRouteNames += [name]
            curRouteList += ["\(name) (\(pos_a) -> \(pos_b))"]
        }
        //selectRoute.dataSource = ["Car", "Motorcycle", "Truck"]
        selectRoute.dataSource = curRouteList
    }
    
    func onNotifyLocation(notification: NSNotification)
    {
        if let location:CLLocation = notification.object as? CLLocation
        {
            print("notified location = \(location)");
            
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 18, bearing: 0, viewingAngle: 0)
            //marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
            marker.position = location.coordinate
            marker.title = "Me"
            marker.snippet = ""
            marker.map = mapView
        }
    }
}


