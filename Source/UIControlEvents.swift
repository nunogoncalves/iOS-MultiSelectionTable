//
//  UIControlEvents.swift
//  Pods
//
//  Created by Nuno Gonçalves on 15/12/16.
//
//

public extension UIControlEvents {
    
    static var itemSelected: UIControlEvents {
        return UIControlEvents(rawValue: 1 << 30)
    }
    
    static var itemUnselected: UIControlEvents {
        return UIControlEvents(rawValue: 1 << 31)
    }
    
}
