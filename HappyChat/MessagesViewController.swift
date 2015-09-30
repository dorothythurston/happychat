import UIKit

class MessagesViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate {
   
    // MARK: - Properties
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var newMessageField: UITextView!

    var messages: [Message] = []
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    private let maxResponseTime: UInt32 = 12
    private let minResponseTime: UInt32 = 6
    
    private var timer = NSTimer()
    private var timedNotifications = 0
    
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
        subscribeToKeyboardNotifications()
        messageTableView.reloadData()
        resetBadgeNumbers()
        syncHeaderText()
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotifications()
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
        
    // MARK: - TableView UI Actions
    
    private func insertMessage(newMessage: Message) {
        let newIndexPath = NSIndexPath(forRow: messages.count, inSection: 0)
        messages.append(newMessage)
        messageTableView.reloadData()
        messageTableView.scrollToRowAtIndexPath(newIndexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
    }
    
    func save() {
        let savedData = NSKeyedArchiver.archivedDataWithRootObject(messages)
        defaults.setObject(savedData, forKey: "messages")
    }
    
    // MARK: - Generated Message Related Runctions
    private func initiateComputerResponse() {
        let responseTime = pickRandomResponseTime()
        setTimedResponse(responseTime)
        setTimedNotification(responseTime)
    }
    
    private func pickRandomResponseTime() -> Double {
        return Double(arc4random_uniform(maxResponseTime - minResponseTime) + minResponseTime)
    }
    
    private func setTimedResponse(responseTime: Double) {
        timer = NSTimer.scheduledTimerWithTimeInterval(responseTime, target:self, selector: Selector("addNewComputerMessage"), userInfo: nil, repeats: false)
    }
    
    // MARK: - Notifications
    
    private func setTimedNotification(responseTime: Double) {
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
    
    private func addNewComputerMessage() {
        let randomThought = pickRandomComputerThought()
        let newComputerMessage = Message(text: randomThought, incoming: true)
        insertMessage(newComputerMessage)
        self.save()
    }
    
    private func pickRandomComputerThought() -> String {
        let thoughts = ComputerThoughts()
        let randomIndex = Int(arc4random_uniform(UInt32(thoughts.choices.count)))
        let randomThought = (thoughts.choices[randomIndex])
        return randomThought
    }
    
    private func resetBadgeNumbers() {
        let application = UIApplication.sharedApplication()
        application.applicationIconBadgeNumber = 0
        timedNotifications = 0
    }
    
    private func syncHeaderText() {
        let userNameKeyConstant = "userNameKey"
        let defaults = NSUserDefaults.standardUserDefaults()
        if let name = defaults.stringForKey(userNameKeyConstant) {
            navigationItem.title = name
        }
    }
}

