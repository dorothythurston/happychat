//
//  MessagesViewController.swift
//  HappyChat
//
//  Created by Dorothy Thurston on 9/17/15.
//  Copyright © 2015 Dorothy Thurston. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate  {
   
    //MARK: - Properties
    @IBOutlet weak var myMessage: UIButton!
    @IBOutlet weak var messageTableView: UITableView!
    
    var messages = [Message]()
    // defaults set
    var userReplyChoice = "😊 i sent this message. i could choose a different one by clicking on New Message to the left of the send button"
    var userReplyChoices = ["i am happy. yay!", "", "😊", "🌟", "today is a good day", ":-P"]
    
    let maxResponseTime: UInt32 = 20
    let minResponseTime: UInt32 = 6
    let userReplyChoiceAmmount = 5
    var timer = NSTimer()
    
    
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
    
    // MARK: - IB Actions
    @IBAction func didPressNewMessage(sender: AnyObject) {
    }
    
    @IBAction func didPressSendMessage(sender: UIBarButtonItem) {
        let newMessage = Message(text: userReplyChoice, incoming: false)
        insertMessage(newMessage)
        self.save()
        setTimedResponse()
        resetReplies()
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
        messageTableView.reloadData()
        messageTableView.scrollToRowAtIndexPath(newIndexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
    }
    
    // MARK: Generated Message related functions
    
    func addNewComputerMessage() {
        let randomThought = pickRandomComputerThought()
        let newComputerMessage = Message(text: randomThought, incoming: true)
        insertMessage(newComputerMessage)
        self.save()
    }
    
    func setTimedResponse() {
        let responseTime = pickRandomResponseTime()
        timer = NSTimer.scheduledTimerWithTimeInterval(responseTime, target:self, selector: Selector("addNewComputerMessage"), userInfo: nil, repeats: false)
    }
    
    func pickRandomResponseTime() -> Double {
        return Double(arc4random_uniform(maxResponseTime - minResponseTime) + minResponseTime)
    }
    
    func pickRandomComputerThought() -> String {
        let thoughts = ComputerThoughts()
        let randomIndex = Int(arc4random_uniform(UInt32(thoughts.choices.count)))
        let randomThought = (thoughts.choices[randomIndex])
        return randomThought
    }
    
    func resetReplies() {
        myMessage.setTitle("New Message", forState: UIControlState.Normal)
        pickNewUserReplyChoices()
    }
    
    func pickNewUserReplyChoices() {
        userReplyChoices = chooseThreeRandomShortReplies()
    }
    
    func chooseThreeRandomShortReplies() -> Array<String> {
        let shortReplies = ShortReplies()
        var chosenReplies = [String]()
        var chosenIndexes = [Int]()
        while (chosenIndexes.count < userReplyChoiceAmmount) {
            let randomIndex = Int(arc4random_uniform(UInt32(shortReplies.choices.count)))
            if (chosenIndexes.contains(randomIndex) == false) {
                chosenIndexes.append(randomIndex)
            }
        }
        for randomIndex in chosenIndexes {
            let randomReply = (shortReplies.choices[randomIndex])
            chosenReplies.append(randomReply)
        }
        
        return chosenReplies
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
        userReplyChoice = choice
   }
}

