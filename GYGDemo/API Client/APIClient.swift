//
//  APIClient.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation
import UIKit

enum APIClientError: Error {
    case generalError(String)
    case responseError(Error?)
    case responseDecodeError(Error)
}

class APIClient {
    
    // MARK: - Public properties
    let environment: APIEnvironment
    
    // MARK: - Private properties
    private let modelCreationQueue = DispatchQueue(label: "com.gert.andreas.GYGDemo.ModelCreationQueue", attributes: .concurrent)
    
    private lazy var session: URLSession = {
        return URLSession(configuration: environment.sessionConfiguration)
    }()
    private var requestCount: Int = 0 {
        didSet { UIApplication.shared.isNetworkActivityIndicatorVisible = requestCount > 0 }
    }
    
    init(environment: APIEnvironment) {
        self.environment = environment
    }
    
    func perform<T: Decodable>(for descriptor: EndpointDescriptor, resultType: T.Type, completion: @escaping((T?, APIClientError?) -> Void)) {
        
        requestCount += 1
        
        let handler = { [weak self] (result: T?, error: APIClientError?) -> Void in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.requestCount -= 1
                completion(result, error)
            }
        }
        
        var components = URLComponents()
        components.host = environment.host
        components.path = descriptor.path
        components.scheme = "https"
        components.queryItems = descriptor.queryItems(for: environment)
        
        guard let url = components.url else {
            let generalError = APIClientError.generalError("Could not create url for request.")
            handler(nil, generalError)
            return
        }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = descriptor.httpMethod.rawValue
        
        let task = session.dataTask(with: request as URLRequest) { [weak self] (data, response, error) in
            
            guard let data = data else {
                let responseError = APIClientError.responseError(error)
                return handler(nil, responseError)
            }
            
            let decoder = JSONDecoder()
            
            self?.modelCreationQueue.async {
                do {
                    let decodable = try decoder.decode(T.self, from: data)
                    handler(decodable, nil)
                } catch {
                    let responseError = APIClientError.responseDecodeError(error)
                    handler(nil, responseError)
                }
            }
        }
        task.resume()
    }
}
