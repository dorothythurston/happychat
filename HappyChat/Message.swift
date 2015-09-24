//
//  Message.swift
//  HappyChat
//
//  Created by Dorothy Thurston on 9/21/15.
//  Copyright © 2015 Dorothy Thurston. All rights reserved.
//

import UIKit

class Message: NSObject, NSCoding {
    var text: String
    var incoming: Bool
    var createdAt: NSDate
    
    init(text: String, incoming: Bool) {
        self.text = text
        self.incoming = incoming
        self.createdAt = NSDate()
    }
    
    required init(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObjectForKey("text") as! String
        incoming = aDecoder.decodeObjectForKey("incoming") as! Bool
        createdAt = aDecoder.decodeObjectForKey("createdAt") as! NSDate
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "text")
        aCoder.encodeObject(incoming, forKey: "incoming")
        aCoder.encodeObject(createdAt, forKey: "createdAt")

    }
    
    func timeDateFormat() -> String {
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        let stringValue = formatter.stringFromDate(self.createdAt)
        return stringValue
    }
}
