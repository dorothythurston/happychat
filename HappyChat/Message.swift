//
//  Message.swift
//  HappyChat
//
//  Created by Dorothy Thurston on 9/18/15.
//  Copyright © 2015 Dorothy Thurston. All rights reserved.
//

import UIKit

class Message {
    var text: String
    var incoming: Bool
    
    init(text: String, incoming: Bool) {
        self.text = text
        self.incoming = incoming
    }
}
