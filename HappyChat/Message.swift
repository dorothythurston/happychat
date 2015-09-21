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
    
    init(text: String, incoming: Bool) {
        self.text = text
        self.incoming = incoming
    }
    
    required init(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObjectForKey("text") as! String
        incoming = aDecoder.decodeObjectForKey("incoming") as! Bool
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "text")
        aCoder.encodeObject(incoming, forKey: "incoming")
    }
}