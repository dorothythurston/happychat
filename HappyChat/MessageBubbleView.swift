//
//  MessageBubbleView.swift
//  HappyChat
//
//  Created by Dorothy Thurston on 9/27/15.
//  Copyright © 2015 Dorothy Thurston. All rights reserved.
//

import Foundation
import UIKit

class MessageBubbleView: UIView {
    let circleLayer = CircleView(xValue: 3.0, yValue: 16.0)
    
    override init(frame: CGRect) {
            super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addCircleView(circleLayer: CircleView) {
        layer.addSublayer(circleLayer)
        circleLayer.wobble()
    }
}