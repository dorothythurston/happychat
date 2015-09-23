//
//  ComputerMessage.swift
//  HappyChat
//
//  Created by Dorothy Thurston on 9/22/15.
//  Copyright © 2015 Dorothy Thurston. All rights reserved.
//

import UIKit

class ComputerMessage {
    var text : String
    var replies: Array<String>
    
    init(text: String, replies: Array<String>) {
        self.text = text
        self.replies = replies
    }
}
