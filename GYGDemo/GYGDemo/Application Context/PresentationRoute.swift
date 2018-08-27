//
//  PresentationRoute.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation
import UIKit

struct PresentationRoute {
    
    enum Destination {
        
    }
    
    enum PresentationStyle {
        case push
        case modal
    }
    
    let destination: Destination
    
    let preferredPresentationStyle: PresentationStyle
    let prefersAnimatedPresentation: Bool
    let transitioningDelegate: UIViewControllerTransitioningDelegate?
    
    init(destination: Destination,
         preferredPresentationStyle: PresentationStyle = .push,
         prefersAnimatedPresentation: Bool = true,
         transitioningDelegate: UIViewControllerTransitioningDelegate? = nil) {
        
        self.destination = destination
        self.preferredPresentationStyle = preferredPresentationStyle
        self.prefersAnimatedPresentation = prefersAnimatedPresentation
        self.transitioningDelegate = transitioningDelegate
    }
}
