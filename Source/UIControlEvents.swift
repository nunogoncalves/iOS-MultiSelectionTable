//
//  UIControlEvents.swift
//  Pods
//
//  Created by Nuno Gonçalves on 15/12/16.
//
//

public extension UIControl.Event {
    
    static var itemSelected: UIControl.Event {
        return UIControl.Event(rawValue: 1 << 30)
    }
    
    static var itemUnselected: UIControl.Event {
        return UIControl.Event(rawValue: 1 << 31)
    }
    
    static var scrollReachingEnd: UIControl.Event {
        return UIControl.Event(rawValue: 1 << 29)
    }
    
}
