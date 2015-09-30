import UIKit
import CoreGraphics

class SettingsViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var headerName: UITextField!
    @IBOutlet weak var computerReplyColor: UIButton!
    @IBOutlet weak var userReplyColor: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    private let userNameKeyConstant = "userNameKey"
    private let userReplyColorKeyConstant = "userReplyColorKey"
    private let computerReplyColorKeyConstant = "computerReplyColorKey"
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    private var userColorIndex = 0
    private var computerColorIndex = 0
    private let maxColorIndex = 11
    
    // reduce extra saving
    private var userColorModified = false
    private var computerColorModified = false
    private var headerNameModified = false
    
    private let colorChoices = [
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
        
        headerName.delegate = self
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
    
    private func saveName(newName: String) {
        defaults.setObject(newName, forKey: self.userNameKeyConstant)
        
    }
    
    private func syncNameLabel() {
        if let name = defaults.stringForKey(userNameKeyConstant)
        {
            headerName.text = name
        }
    }
    
    private func saveUserColor(color: UIColor) {
        defaults.setColor(color, forKey: self.userReplyColorKeyConstant)
    }
    
    private func saveComputerColor(color: UIColor) {
        defaults.setColor(color, forKey: self.computerReplyColorKeyConstant)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        headerNameModified = true
    }
}

