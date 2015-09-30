import UIKit
import CoreGraphics

class SettingsViewController: UIViewController {
    @IBOutlet weak var headerName: UITextView!
    @IBOutlet weak var userReplyColor: UITextView!
    @IBOutlet weak var computerReplyColor: UITextView!
    @IBOutlet weak var containerView: UIView!
    
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
        UIColor.happyChatDullGreen(), // dull green color
        UIColor.happyChatBrightGreen(), // bright green color
        UIColor.happyChatYellow(), // yellow color
        UIColor.happyChatOrange(), // orange color
        UIColor.happyChatSalmon(), // salmon color
        UIColor.happyChatPink(), // pink color
        UIColor.happyChatLightPink(), // light pink color
        UIColor.happyChatLavender(), // lavender purple color
        UIColor.happyChatGrape(), // grape purple color
        UIColor.happyChatAqua(), // aqua blue color
        UIColor.happyChatSkyBlue(), //sky blue color
        UIColor.happyChatTeal() //teal color
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        syncNameLabel()
        
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
}

