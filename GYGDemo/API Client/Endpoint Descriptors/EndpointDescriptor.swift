//
//  EndpointDescriptor.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

protocol EndpointDescriptor {
    
    var path: String { get }
    var parameters: [String: Any?]? { get }
    var httpMethod: HTTPMethod { get }
}

extension EndpointDescriptor {
    
    func queryItems(for environment: APIEnvironment) -> [URLQueryItem]? {
        
        guard let filteredParameters = parameters?.filter({ $0.value != nil }).mapValues({ $0! }) else { return nil }
        
        var queryItems: [URLQueryItem] = []
        for (_, element) in filteredParameters.enumerated() {
            queryItems.append(URLQueryItem(name: element.key, value: "\(element.value)"))
        }
        return queryItems
    }
}
