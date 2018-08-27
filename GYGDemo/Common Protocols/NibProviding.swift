//
//  NibProviding.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation
import UIKit

protocol NibProviding {}

extension NibProviding {
    
    static var nib: UINib {
        let nib = UINib(nibName: String(describing: Self.self), bundle: nil)
        return nib
    }
}
