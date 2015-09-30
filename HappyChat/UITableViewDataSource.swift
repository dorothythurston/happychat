import UIKit

extension MessagesViewController: UITableViewDataSource {
    var userReplyColor: UIColor {
        return defaults.colorForKey("userReplyColorKey") ?? UIColor.happyChatGrape()
    }
    var computerReplyColor: UIColor {
        return defaults.colorForKey("computerReplyColorKey") ?? UIColor.happyChatAqua()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
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
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteItem(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            save()
        }
    }
    
    private func deleteItem(indexPath: Int) {
        messages.removeAtIndex(indexPath)
    }

}
