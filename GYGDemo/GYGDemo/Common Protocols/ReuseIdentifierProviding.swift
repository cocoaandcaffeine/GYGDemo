//
//  ReuseIdentifierProviding.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation

protocol ReuseIdentifierProviding {}

extension ReuseIdentifierProviding {
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
