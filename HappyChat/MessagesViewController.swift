//
//  MessagesViewController.swift
//  HappyChat
//
//  Created by Dorothy Thurston on 9/17/15.
//  Copyright © 2015 Dorothy Thurston. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate  {
   
    //MARK: - Properties
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var newMessageField: UITextView!

    
    var messages = [Message]()
    let defaults = NSUserDefaults.standardUserDefaults()

    var userReplyColor = UIColor(red: 137/255.0, green: 49/255.0, blue: 255/255.0, alpha: 1.0)
    var computerReplyColor = UIColor(red: 0/255.0, green: 140/255.0, blue: 255/255.0, alpha: 1.0)
    
    let maxResponseTime: UInt32 = 12
    let minResponseTime: UInt32 = 6
    
    
    var timer = NSTimer()
    var timedNotifications = 0
    
    let placeHolderText = "What's good?"
    let placeHolderColor = UIColor.lightGrayColor()
    let typingColor = UIColor.blackColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        if let savedMessages = defaults.objectForKey("messages") as? NSData {
            messages = NSKeyedUnarchiver.unarchiveObjectWithData(savedMessages) as! [Message]
        }
        
        messageTableView.estimatedRowHeight = 68.0
        messageTableView.rowHeight = UITableViewAutomaticDimension
        newMessageField.delegate = self
        newMessageField.text = placeHolderText
        newMessageField.textColor = placeHolderColor
        newMessageField.layer.cornerRadius = 10.0
    }
    
    override func viewWillAppear(animated: Bool) {
        if let color = defaults.colorForKey("userReplyColorKey") {
            userReplyColor = color
        }
        if let color = defaults.colorForKey("computerReplyColorKey") {
            computerReplyColor = color
        }
        subscribeToKeyboardNotifications()
        messageTableView.reloadData()
        resetBadgeNumbers()
        syncHeaderText()
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IB Actions
    @IBAction func didPressSendMessage() {
        if let newMessageText = newMessageField.text {
         let newMessage = Message(text: newMessageText, incoming: false)
            insertMessage(newMessage)
            newMessageField.text = ""
            self.save()
            initiateComputerResponse()
        }
    }

    //MARK: - Table View Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
 
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.deleteItem(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.save()
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let message = messages[indexPath.item]
        
        if message.incoming == true {
            let cell = tableView.dequeueReusableCellWithIdentifier("incomingMessageCell", forIndexPath: indexPath) as! incomingMessageCell
            cell.messageField.text = message.text
            cell.messageField.layer.cornerRadius = 15.0;
            cell.messageTimeStamp.text = message.timeDateFormat()
            cell.messageField.layer.backgroundColor = computerReplyColor.CGColor
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("outgoingMessageCell", forIndexPath: indexPath) as! outgoingMessageCell
            cell.messageField.text = message.text
            cell.messageField.layer.cornerRadius = 15.0;
            cell.messageTimeStamp.text = message.timeDateFormat()
            cell.messageField.layer.backgroundColor = userReplyColor.CGColor
            
            return cell
        }
    }

        
    // MARK: - TableView UI Actions
    func deleteItem(indexPath: Int) {
        messages.removeAtIndex(indexPath)
    }
    
    func insertMessage(newMessage: Message) {
        let newIndexPath = NSIndexPath(forRow: messages.count, inSection: 0)
        messages.append(newMessage)
        messageTableView.reloadData()
        messageTableView.scrollToRowAtIndexPath(newIndexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
    }
    
    
    // MARK: - Generated Message Related Runctions
    func initiateComputerResponse() {
        let responseTime = pickRandomResponseTime()
        setTimedResponse(responseTime)
        setTimedNotification(responseTime)
    }
    
    func pickRandomResponseTime() -> Double {
        return Double(arc4random_uniform(maxResponseTime - minResponseTime) + minResponseTime)
    }
    
    func setTimedResponse(responseTime: Double) {
        timer = NSTimer.scheduledTimerWithTimeInterval(responseTime, target:self, selector: Selector("addNewComputerMessage"), userInfo: nil, repeats: false)
    }
    
    // MARK: - Notifications
    
    func setTimedNotification(responseTime: Double) {
        let application = UIApplication.sharedApplication()
        guard let settings = application.currentUserNotificationSettings() else { return }
        
        if settings.types != .None {
            let notification = UILocalNotification()
            notification.fireDate = NSDate(timeIntervalSinceNow: responseTime)
            notification.alertBody = "You have a New Message!"
            notification.alertAction = "view"
            notification.timeZone = NSTimeZone.defaultTimeZone()
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.applicationIconBadgeNumber = timedNotifications + 1
            application.scheduleLocalNotification(notification)
            timedNotifications += 1
        }
    }
    
    func addNewComputerMessage() {
        let randomThought = pickRandomComputerThought()
        let newComputerMessage = Message(text: randomThought, incoming: true)
        insertMessage(newComputerMessage)
        self.save()
    }
    
    func pickRandomComputerThought() -> String {
        let thoughts = ComputerThoughts()
        let randomIndex = Int(arc4random_uniform(UInt32(thoughts.choices.count)))
        let randomThought = (thoughts.choices[randomIndex])
        return randomThought
    }
    
    func resetBadgeNumbers() {
        let application = UIApplication.sharedApplication()
        application.applicationIconBadgeNumber = 0
        timedNotifications = 0
    }
    
    func syncHeaderText() {
        let userNameKeyConstant = "userNameKey"
        let defaults = NSUserDefaults.standardUserDefaults()
        if let name = defaults.stringForKey(userNameKeyConstant)
        {
            navigationItem.title = name
        }
    }
    
    // MARK: - Data Storage
    
    func save() {
        let savedData = NSKeyedArchiver.archivedDataWithRootObject(messages)
        defaults.setObject(savedData, forKey: "messages")
    }
    
    // MARK: - Keyboard
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
                self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    // MARK: - TextView
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == placeHolderColor {
            textView.text = nil
            textView.textColor = typingColor
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolderText
            textView.textColor = placeHolderColor
        }
    }
}

