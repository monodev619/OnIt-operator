//
//  MainViewController.swift
//  OnIt-Operator
//
//  Created by ExpDev on 9/18/16.
//  Copyright © 2016 2Create360. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var labelBusStop: UILabel!
    @IBOutlet var editTicketId: UITextField!
    @IBOutlet var imageCheckResult: UIImageView!
    @IBOutlet var labelTotalCount: UILabel!
    @IBOutlet var labelMaleCount: UILabel!
    @IBOutlet var labelFemaleCount: UILabel!
    @IBOutlet var labelCurrentLocation: UILabel!
    
    var curRoute:Dictionary<String, NSObject>!
    
    var maleCounter = [Int](count:6, repeatedValue:0)
    var femaleCounter = [Int](count:6, repeatedValue:0)
    var totalCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.curRoute == nil
        {
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("backToHome", sender: self)
            }
            return
        }
        else
        {
//            for (key, value) in self.curRoute
//            {
//                print("\(key) - \(value)")
//            }
        }
        
        let paddingView:UIView = UIView(frame:CGRectMake(0, 0, 8, 1))
        self.editTicketId.leftView = paddingView;
        self.editTicketId.leftViewMode = UITextFieldViewMode.Always
    }
    
    @IBAction func onClickPeople(sender: AnyObject) {
        let btnId:Int! = sender.tag
        if btnId >= 10
        {
            if btnId - 10 < 5
            {
                self.maleCounter[btnId - 10] += 1
                self.maleCounter[5] += 1
                self.labelMaleCount.text = "\(self.maleCounter[5])"
            }
            else
            {
                return
            }
        }
        else
        {
            if btnId < 5
            {
                self.femaleCounter[btnId] += 1
                self.femaleCounter[5] += 1
                self.labelFemaleCount.text = "\(self.femaleCounter[5])"
            }
            else
            {
                return
            }
        }
        
        self.totalCount += 1
        self.labelTotalCount.text = "\(self.totalCount)"
    }
    
    @IBAction func onClickSignOut(sender: AnyObject) {
        self.performSegueWithIdentifier("backToHome", sender: self)
    }
    
    @IBAction func onClickValidateTicket(sender: AnyObject) {
    }
    
}