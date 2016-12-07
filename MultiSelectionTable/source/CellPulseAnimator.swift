//
//  CellPulseAnimator.swift
//  Pods
//
//  Created by Nuno Gonçalves on 07/12/16.
//
//

class CellPulseAnimator : CellAnimator {
    
    private let pathLayer = CAShapeLayer()
    let pathAnimation = CABasicAnimation(keyPath: "path")
    let opacityAnimation = CABasicAnimation(keyPath: "opacity")
    
    let pulseColor: UIColor
    
    internal init(pulseColor: UIColor) {
        self.pulseColor = pulseColor
    }
    
    public func animate(_ cell: UITableViewCell,
                        startingAt origin: CGPoint?,
                        finish: (() -> ())?) {
        
        let startingPoint = origin ?? cell.contentView.center
        
        let smallCircle = UIBezierPath(ovalIn: CGRect(x: startingPoint.x - 1,
                                                      y: startingPoint.y - 1,
                                                      width: 2,
                                                      height: 2))
        
        let maxRadius = maxDistance(between: startingPoint, andCornersIn: cell.contentView.frame)
        
        let bigCircle = UIBezierPath(arcCenter: startingPoint,
                                     radius: maxRadius,
                                     startAngle: CGFloat(0),
                                     endAngle: CGFloat(2 * CGFloat.pi),
                                     clockwise: true)
        
        pathLayer.lineWidth = 0
        cell.contentView.layer.masksToBounds = true
        pathLayer.fillColor = pulseColor.cgColor
        cell.contentView.layer.addSublayer(pathLayer)
        
        CATransaction.begin()
        
        pathAnimation.fromValue = smallCircle.cgPath
        pathAnimation.toValue = bigCircle.cgPath
        
        CATransaction.setCompletionBlock {
            finish?()
        }
        
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0.3
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 0.3
        animationGroup.animations = [pathAnimation, opacityAnimation]
        
        pathLayer.add(animationGroup, forKey: "animation")
        
        CATransaction.commit()
    }
    
    func maxDistance(between point: CGPoint, andCornersIn rect: CGRect) -> CGFloat {
        let px = point.x
        let py = point.y
        
        let corners = [
            CGPoint(x: rect.origin.x, y: rect.origin.y),
            CGPoint(x: rect.width, y: rect.origin.y),
            CGPoint(x: rect.origin.x, y: rect.height),
            CGPoint(x: rect.width, y: rect.height)
        ]
        
        var maxDistance: CGFloat = 0
        
        for corner in corners {
            let dx = abs(px - corner.x)
            let dy = abs(py - corner.y)
            let length = sqrt(dx * dx + dy * dy)
            maxDistance = max(length, maxDistance)
        }
        return maxDistance
    }
}
