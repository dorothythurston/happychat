//
//  CircleView.swift
//  HappyChat
//
//  Created by Dorothy Thurston on 9/27/15.
//  Copyright © 2015 Dorothy Thurston. All rights reserved.
//

import UIKit

class CircleView: CAShapeLayer {
    let animationDuration: CFTimeInterval = 1.0
    let x: CGFloat
    let y: CGFloat
    
    init(xValue: CGFloat, yValue: CGFloat) {
        x = xValue
        y = yValue
        super.init()
        fillColor = UIColor.whiteColor().CGColor
        path = circlePathSmall.CGPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var circlePathSmall: UIBezierPath {
        return UIBezierPath(ovalInRect: CGRect(x: x, y: x, width: 0.0, height: 0.0))
    }
    
    var circlePathLarge: UIBezierPath {
        return UIBezierPath(ovalInRect: CGRect(x: (x + 0), y: (y), width: 10.0, height: 10.0))
    }
    
    var circlePathSquishVertical: UIBezierPath {
        return UIBezierPath(ovalInRect: CGRect(x: (x - 0.5), y: (y + 2.5), width: 10.0, height: 8.0))
    }
    
    var circlePathSquishHorizontal: UIBezierPath {
        return UIBezierPath(ovalInRect: CGRect(x: x, y: (y + 4.0), width: 10.0, height: 10.0))
    }
    
    func wobble() {
        let wobbleAnimation1: CABasicAnimation = CABasicAnimation(keyPath: "path")
        wobbleAnimation1.fromValue = circlePathLarge.CGPath
        wobbleAnimation1.toValue = circlePathSquishVertical.CGPath
        wobbleAnimation1.beginTime = 0.0
        wobbleAnimation1.duration = animationDuration
        
        let wobbleAnimation2: CABasicAnimation = CABasicAnimation(keyPath: "path")
        wobbleAnimation2.fromValue = circlePathSquishVertical.CGPath
        wobbleAnimation2.toValue = circlePathSquishHorizontal.CGPath
        wobbleAnimation2.beginTime = wobbleAnimation1.beginTime + wobbleAnimation1.duration
        wobbleAnimation2.duration = animationDuration
        
        let wobbleAnimation3: CABasicAnimation = CABasicAnimation(keyPath: "path")
        wobbleAnimation3.fromValue = circlePathSquishHorizontal.CGPath
        wobbleAnimation3.toValue = circlePathSquishVertical.CGPath
        wobbleAnimation3.beginTime = wobbleAnimation2.beginTime + wobbleAnimation2.duration
        wobbleAnimation3.duration = animationDuration
        
        let wobbleAnimation4: CABasicAnimation = CABasicAnimation(keyPath: "path")
        wobbleAnimation4.fromValue = circlePathSquishVertical.CGPath
        wobbleAnimation4.toValue = circlePathLarge.CGPath
        wobbleAnimation4.beginTime = wobbleAnimation3.beginTime + wobbleAnimation3.duration
        wobbleAnimation4.duration = animationDuration
        
        let wobbleAnimationGroup: CAAnimationGroup = CAAnimationGroup()
        wobbleAnimationGroup.animations = [wobbleAnimation1, wobbleAnimation2, wobbleAnimation3,
            wobbleAnimation4]
        wobbleAnimationGroup.duration = wobbleAnimation4.beginTime + wobbleAnimation4.duration
        wobbleAnimationGroup.repeatCount = 2
        addAnimation(wobbleAnimationGroup, forKey: nil)
    }
}