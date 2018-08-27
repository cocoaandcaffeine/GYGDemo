//
//  ApplicationContext.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation

protocol ApplicationContext {
    var apiClient: APIClient { get }
    var applicationCoordinator: ApplicationCoordinator { get }
}

class DefaultApplicationContext: ApplicationContext {
    
    private(set) lazy var apiClient: APIClient = {
        return APIClient(environment: .standard)
    }()
    
    private (set) lazy var applicationCoordinator: ApplicationCoordinator = {
        return ApplicationCoordinator(applicationContext: self)
    }()
}
