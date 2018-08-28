//
//  TourRatingEndpointDescriptor.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation

enum RatingType: Int, Codable {
    case all
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

enum SortDirectionType: String {
    case ascending = "ASC"
    case descending = "DESC"
}

enum RatingCommentsEndpointDescriptor: EndpointDescriptor {

    case standard(path: String, count: Int, page: Int, rating: RatingType?, sortBy: SortByType?, direction: SortDirectionType? )
    
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
