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
    var exampleMessages = ["Hello!", "I am happy you exist"]
    var storedChoice = "sent a message"
    
    //MARK: - Properties

    @IBOutlet weak var myMessage: UIButton!
    @IBOutlet weak var messageTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.delegate = self
        messageTableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Interface Actions
    @IBAction func didPressNewMessage(sender: AnyObject) {
    }
    
    @IBAction func didPressSendMessage(sender: UIBarButtonItem) {
        exampleMessages.append(storedChoice)
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
    let textCellIdentifier = "messageCell"
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
 
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exampleMessages.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = exampleMessages[row]
        
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print(exampleMessages[row])
    }
    
}

extension MessagesViewController: UIPickerViewControllerDelegate {
    func newMessageChoiceMade(choice: String) {
      myMessage.setTitle(choice, forState: UIControlState.Normal)
        storedChoice = choice
   }
}

