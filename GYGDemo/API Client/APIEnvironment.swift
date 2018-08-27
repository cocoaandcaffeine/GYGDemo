//
//  APIEnvironment.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation

class APIEnvironment {
    
    // MARK: - Public properties
    let host: String
    private(set) lazy var sessionConfiguration: URLSessionConfiguration = setupSessionConfiguration()
    
    // MARK: - Standard Environment
    public static let standard: APIEnvironment = APIEnvironment(host: "www.getyourguide.com")
    
    // MARK: - Lifecycle
    init(host: String) {
        self.host = host
    }
    
    private func setupSessionConfiguration() -> URLSessionConfiguration {
        let tmpSessionConfiguration = URLSessionConfiguration.default
        
        // Use a shorter timeout
        tmpSessionConfiguration.timeoutIntervalForRequest = 20.0
        
        // Ignore cookies
        tmpSessionConfiguration.httpCookieAcceptPolicy = .never
        tmpSessionConfiguration.httpShouldSetCookies = false
        tmpSessionConfiguration.httpCookieStorage = nil
        
        return tmpSessionConfiguration
    }
}
