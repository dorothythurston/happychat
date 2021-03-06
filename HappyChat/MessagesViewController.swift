import UIKit
import AudioToolbox

class MessagesViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate {
   
    // MARK: - Properties
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var newMessageField: UITextView!

    var messages: [Message] = []
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let application = UIApplication.sharedApplication()
    
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
        if (newMessageField.text.isEmpty || newMessageField.text == placeHolderText)  {
            highlightNewMessageField()
        }
        else if let newMessageText = newMessageField.text {
         let newMessage = Message(text: newMessageText, incoming: false)
            insertMessage(newMessage)
            newMessageField.text = ""
            initiateComputerResponse()
            self.save()
        }
    }
        
    // MARK: - TableView UI Actions
    
    private func highlightNewMessageField() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        var upRect: NSValue {
            return NSValue(CGPoint: CGPointMake(newMessageField.center.x - 10, newMessageField.center.y))
        }
        
        var downRect: NSValue {
            return NSValue(CGPoint: CGPointMake(newMessageField.center.x + 10, newMessageField.center.y))
        }
        animation.fromValue = upRect
        animation.toValue = downRect
        newMessageField.layer.addAnimation(animation, forKey: "position")
    }
    
    private func insertMessage(newMessage: Message) {
        dispatch_async(dispatch_get_main_queue() ) {
            let newIndexPath = NSIndexPath(forRow: self.messages.count, inSection: 0)
            self.messages.append(newMessage)
            self.messageTableView.reloadData()
            self.messageTableView.scrollToRowAtIndexPath(newIndexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            if newMessage.incoming == true  {
                self.playNewComputerMessageSound()
            } else {
                self.playNewUserMessageSound()
            }
        }
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
        timer = NSTimer.scheduledTimerWithTimeInterval(responseTime, target:self, selector: #selector(MessagesViewController.addNewComputerMessage), userInfo: nil, repeats: false)
    }
    
    func addNewComputerMessage() {
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
    
    // MARK: - Notifications
    
    private func setTimedNotification(responseTime: Double) {
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
    
    // MARK: - In App Sounds
    private func playNewComputerMessageSound() {
        let state = application.applicationState
        if (state == UIApplicationState.Active) {
            AudioServicesPlaySystemSound(1003)
        }
    }
    
    private func playNewUserMessageSound() {
        AudioServicesPlaySystemSound(1004)
    }
    
}

