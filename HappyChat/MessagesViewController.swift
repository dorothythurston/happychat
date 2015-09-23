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
    var userReplyChoices = ["<3", "wow"]
    
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
        messageTableView.estimatedRowHeight = 68.0
        messageTableView.rowHeight = UITableViewAutomaticDimension
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
        insertMessage(newMessage)
        self.save()
    }
    
    // TODO: - To be deleted after full implementation
    @IBAction func didPressNewComputerMessage(sender: UIBarButtonItem) {
        let newComputerMessage = ComputerMessage(text: "i am writing you a very long message to let you know i think that you are great!", replies: [":)","yay!","great!"])
        userReplyChoices = newComputerMessage.replies
        let newMessage = Message(text: newComputerMessage.text, incoming: true)
        insertMessage(newMessage)
        self.save()
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NewMessageSegue" {
            let nav = segue.destinationViewController as! UINavigationController
            let uiPickerViewController = nav.topViewController as! UIPickerViewController
            uiPickerViewController.delegate = self
            uiPickerViewController.pickerData = userReplyChoices
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
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("outgoingMessageCell", forIndexPath: indexPath) as! outgoingMessageCell
            cell.messageField.text = message.text
            cell.messageField.layer.cornerRadius = 15.0;
            
            return cell
        }
    }
    
    // MARK: TableView UI Actions
    func deleteItem(indexPath: Int) {
        messages.removeAtIndex(indexPath)
    }
    
    func insertMessage(newMessage: Message) {
        let newIndexPath = NSIndexPath(forRow: messages.count, inSection: 0)
        messages.append(newMessage)
        messageTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation:.Fade)
        messageTableView.scrollToRowAtIndexPath(newIndexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
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

