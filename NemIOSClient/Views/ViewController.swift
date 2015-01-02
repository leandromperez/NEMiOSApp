//
//  ViewController.swift
//  NemIOSClient
//
//  Created by Dominik Lyubomyr on 11.12.14.
//  Copyright (c) 2014 Artygeek. All rights reserved.
//

import UIKit

var SegueToServerVC : String =  "Servers"
var SegueToRegistrationVC : String =  "Registration"
var SegueToLoginVC : String =  "Accounts"
var SegueToServerTable : String =  "serverTable"
var SegueToServerCustom : String =  "serverCustom"
var SegueToMainVC : String =  "Main"
var SegueToMainMenu : String =  "Menu"
var SegueToDashboard : String =  "Dashboard"
var SegueToPasswordValidation : String =  "Password"
var SegueToMessageVC : String =  "Message"
var SegueToQRCode : String =  "QR Code"
//var SegueToValidatePin : String =  "validatePin"
//var SegueToPinConfige : String =  "toPinConfige"

class ViewController: UIViewController
{
    let deviceData : plistFileManager = plistFileManager()
    let dataManager :CoreDataManager = CoreDataManager()
//    var pin : String = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        dataManager.getUsers()

    }
    
    override func viewDidAppear(animated: Bool)
    {
        
//        var pin : String = dataManager.userPin()
//        var nullStr : String = String()
//        var state = dataManager.userPinState()
//        
//        if(pin != nullStr && state == "0")
//        {
//            self.performSegueWithIdentifier(SegueToValidatePin, sender: self)
//        }
//        else
//        {
            self.performSegueWithIdentifier(SegueToMainVC, sender: self)
//        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

}
