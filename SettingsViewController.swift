//
//  SettingsViewController.swift
//  HappyChat
//
//  Created by Dorothy Thurston on 9/17/15.
//  Copyright © 2015 Dorothy Thurston. All rights reserved.
//

import UIKit
import CoreGraphics

class SettingsViewController: UIViewController {
    @IBOutlet weak var headerName: UITextView!
    @IBOutlet weak var userReplyColor: UITextView!
    @IBOutlet weak var computerReplyColor: UITextView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var demoView: MessageBubbleView!
    
    let userNameKeyConstant = "userNameKey"
    let userReplyColorKeyConstant = "userReplyColorKey"
    let computerReplyColorKeyConstant = "computerReplyColorKey"
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var userColorIndex = 0
    var computerColorIndex = 0
    let maxColorIndex = 11
    
    // reduce extra saving
    var userColorModified = false
    var computerColorModified = false
    var headerNameModified = false
    
    let colorChoices = [
        UIColor(red: 85/255.0, green: 176/255.0, blue: 112/255.0, alpha: 1.0), // dull green color
        UIColor(red: 5/255.0, green: 248/255.0, blue: 2/255.0, alpha: 1.0), // bright green color
        UIColor(red: 255/255.0, green: 207/255.0, blue: 72/255.0, alpha: 1.0), // yellow color
        UIColor(red: 255/255.0, green: 136/255.0, blue: 2/255.0, alpha: 1.0), // orange color
        UIColor(red: 255/255.0, green: 114/255.0, blue: 110/255.0, alpha: 1.0), // salmon color
        UIColor(red: 255/255.0, green: 67/255.0, blue: 164/255.0, alpha: 1.0), // pink color
        UIColor(red: 255/255.0, green: 127/255.0, blue: 211/255.0, alpha: 1.0), // light pink color
        UIColor(red: 210/255.0, green: 120/255.0, blue: 255/255.0, alpha: 1.0), // lavender purple color
        UIColor(red: 137/255.0, green: 49/255.0, blue: 255/255.0, alpha: 1.0), // grape purple color
        UIColor(red: 0/255.0, green: 140/255.0, blue: 255/255.0, alpha: 1.0), // aqua blue color
        UIColor(red: 29/255.0, green: 172/255.0, blue: 214/255.0, alpha: 1.0), //sky blue color
        UIColor(red: 90/255.0, green: 187/255.0, blue: 181/255.0, alpha: 1.0) //teal color
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        syncNameLabel()
        
        // TO BE DELETED
        demoView.layer.cornerRadius = 15.0
        userReplyColor.layer.cornerRadius = 15.0
        computerReplyColor.layer.cornerRadius = 15.0;
        
        if let color = defaults.colorForKey(userReplyColorKeyConstant) {
            userReplyColor.backgroundColor = color
        }
        if let color = defaults.colorForKey(computerReplyColorKeyConstant) {
            computerReplyColor.backgroundColor = color
        }
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGrayColor().CGColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressCancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didPressSave(sender: UIStoryboardSegue) {
        if userColorModified {
            saveUserColor(colorChoices[userColorIndex])
        }
        if computerColorModified {
            saveComputerColor(colorChoices[computerColorIndex])
        }
        if headerNameModified {
            saveName(headerName.text!)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didPressNotificationsSettings(sender: AnyObject) {
     UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    @IBAction func didPressPickNewName(sender: UIButton) {
        pickNewName()
    }
    
    @IBAction func didPressChangeUserReplyColor(sender: UIButton) {
        if userColorIndex == maxColorIndex {
            userColorIndex = 0
        }
        else {
            userColorIndex++
        }
        userReplyColor.backgroundColor = colorChoices[userColorIndex]
        self.userColorModified = true
    }
    
    @IBAction func didPressChangeComputerResponseColor(sender: UIButton) {
        if computerColorIndex == maxColorIndex {
            computerColorIndex = 0
        }
        else {
            computerColorIndex++
        }
        computerReplyColor.backgroundColor = colorChoices[computerColorIndex]
        self.computerColorModified = true
    }

    
    func pickNewName() {
        let alert = UIAlertController(title: "Enter Name", message: "Pick a nice name", preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = self.headerName.text
        })
        
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            let textField = alert.textFields![0] as UITextField
            if (textField.text!.characters.count <= 20) {
                let newName = textField.text!
                self.headerName.text = newName
                self.headerNameModified = true
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func saveName(newName: String) {
        defaults.setObject(newName, forKey: self.userNameKeyConstant)
        
    }
    
    func syncNameLabel() {
        if let name = defaults.stringForKey(userNameKeyConstant)
        {
            headerName.text = name
        }
    }
    
    func saveUserColor(color: UIColor) {
        defaults.setColor(color, forKey: self.userReplyColorKeyConstant)
    }
    
    func saveComputerColor(color: UIColor) {
        defaults.setColor(color, forKey: self.computerReplyColorKeyConstant)
    }
    
    @IBAction func didPressAddCircle(sender: UIButton) {
        let circleLayer1 = CircleView(xValue: 12.0, yValue: 14.0)
        let circleLayer2 = CircleView(xValue: 24.0, yValue: 14.0)
        let circleLayer3 = CircleView(xValue: 36.0, yValue: 14.0)
        demoView.addCircleView(circleLayer1)
        demoView.addCircleView(circleLayer2)
        demoView.addCircleView(circleLayer3)
    }
}

extension NSUserDefaults {
    func colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = dataForKey(key) {
            color = NSKeyedUnarchiver.unarchiveObjectWithData(colorData) as? UIColor
        }
        return color
    }
    
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedDataWithRootObject(color)
        }
        setObject(colorData, forKey: key)
    }
    
}