//
//  APIClient.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation

enum APIClientError: Error {
    case generalError(String)
    case responseError(Error?)
    case responseDecodeError(Error)
}

class APIClient {
    
    let environment: APIEnvironment
    
    private lazy var session: URLSession = {
        return URLSession(configuration: environment.sessionConfiguration)
    }()
    
    init(environment: APIEnvironment) {
        self.environment = environment
    }
    
    func perform<T: Decodable>(for descriptor: EndpointDescriptor, resultType: T.Type, completion: @escaping((T?, APIClientError?) -> Void)) {
        
        var components = URLComponents()
        components.host = environment.host
        components.path = descriptor.path
        components.scheme = "https"
        components.queryItems = descriptor.queryItems(for: environment)
        
        guard let url = components.url else {
            DispatchQueue.main.async {
                let generalError = APIClientError.generalError("Could not create url for request.")
                completion(nil, generalError)
            }
            return
        }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = descriptor.httpMethod.rawValue
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard let data = data else {
                let responseError = APIClientError.responseError(error)
                return DispatchQueue.main.async { completion(nil, responseError) }
            }
            
            let decoder = JSONDecoder()
            
            do {
                let decodable = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async { completion(decodable, nil) }
            } catch {
                let responseError = APIClientError.responseDecodeError(error)
                DispatchQueue.main.async { completion(nil, responseError) }
            }
        }
        task.resume()
    }
}
