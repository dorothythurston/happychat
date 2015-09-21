//
//  MessagesViewController.swift
//  HappyChat
//
//  Created by Dorothy Thurston on 9/17/15.
//  Copyright © 2015 Dorothy Thurston. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate  {
    //MARK: - Variables that will be deleted later
    var messages = [Message]()
    var storedChoice = "sent a message"
    
    //MARK: - Properties
    @IBOutlet weak var myMessage: UIButton!
    @IBOutlet weak var messageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.delegate = self
        messageTableView.dataSource = self
        // Do any additional setup after loading the view.
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let savedMessages = defaults.objectForKey("messages") as? NSData {
            messages = NSKeyedUnarchiver.unarchiveObjectWithData(savedMessages) as! [Message]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Interface Actions
    @IBAction func didPressNewMessage(sender: AnyObject) {
    }
    
    @IBAction func didPressSendMessage(sender: UIBarButtonItem) {
        let newMessage = Message(text:storedChoice, incoming: false)
        messages.append(newMessage)
        self.save()
        messageTableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NewMessageSegue" {
            let nav = segue.destinationViewController as! UINavigationController
            let uiPickerViewController = nav.topViewController as! UIPickerViewController
            uiPickerViewController.delegate = self
        }
    }
    
    //MARK: - Table View Functions and related properties
    // Set these later let textCellIdentifier = "messageCell"
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
 
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let message = messages[indexPath.item]
        if message.incoming == true {
            let cell = tableView.dequeueReusableCellWithIdentifier("incomingMessageCell", forIndexPath: indexPath) as! incomingMessageCell
            cell.messageLabel.text = message.text
            cell.messageImageView.layer.masksToBounds = true
            cell.messageImageView.layer.cornerRadius = 10
            cell.messageImageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).CGColor
            cell.messageImageView.layer.borderWidth = 2
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("outgoingMessageCell", forIndexPath: indexPath) as! outgoingMessageCell
            cell.messageLabel.text = message.text
            cell.messageImageView.layer.masksToBounds = true
            cell.messageImageView.layer.cornerRadius = 10
            cell.messageImageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).CGColor
            cell.messageImageView.layer.borderWidth = 2
            
            return cell
        }
    }
    
    // MARK: Data Storage
    
    func save() {
        let savedData = NSKeyedArchiver.archivedDataWithRootObject(messages)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(savedData, forKey: "messages")
    }
}

extension MessagesViewController: UIPickerViewControllerDelegate {
    func newMessageChoiceMade(choice: String) {
      myMessage.setTitle(choice, forState: UIControlState.Normal)
        storedChoice = choice
   }
}

