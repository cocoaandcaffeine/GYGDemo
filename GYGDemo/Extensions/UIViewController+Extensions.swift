//
//  UIViewController+Extensions.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//
import Foundation
import UIKit

extension UIViewController {
    
    public class func instantiateFromStoryboard() -> Self {
        return instantiateFromStoryboardForType(self)
    }
    
    fileprivate class func instantiateFromStoryboardForType<T: UIViewController>(_ type: T.Type) -> T {
        let className = String(describing: type)
        let bundle = Bundle(for: type)
        
        guard let storyboard = UIStoryboard(name: className, bundle: bundle).instantiateInitialViewController() as? T else {
            fatalError("Instantiated view controller isn't type of \(T.self)")
        }
        
        return storyboard
    }
}
