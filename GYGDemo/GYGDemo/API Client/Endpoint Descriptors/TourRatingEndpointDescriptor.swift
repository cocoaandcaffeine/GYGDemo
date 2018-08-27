//
//  TourRatingEndpointDescriptor.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation

enum TourRatingEndpointDescriptor: EndpointDescriptor {
    
    enum RatingType: Int {
        case zero
        case one
        case two
        case three
        case four
        case five
    }
    
    enum SortByType: String {
        case dateOfReview = "date_of_review"
        case rating = "rating"
    }
    
    enum DirectionType: String {
        case ascending = "ASC"
        case descending = "DESC"
    }
    
    case standard(path: String, count: Int, page: Int, rating: RatingType?, sortBy: SortByType?, direction: DirectionType? )
    
    public var path: String {
        switch self {
        case .standard(path: let path, _, _, _, _, _): return path
        }
    }
    
    public var parameters: [String: Any?]? {
        switch self {
        case .standard(_, let count, let page, let rating, let sortBy, let direction):
            return ["count": count, "page": page, "rating": rating?.rawValue, "sortBy": sortBy?.rawValue, "direction": direction?.rawValue]
        }
    }
    
    public var httpMethod: HTTPMethod {
        return .get
    }
}
