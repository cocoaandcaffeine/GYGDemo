//
//  RatingCommentsPage.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation

struct RatingCommentsPage: Decodable {
    
    let comments: [RatingComment]
    let successful: Bool
    let totalReviewComments: Int
    
    private enum CodingKeys: String, CodingKey {
        case comments = "data"
        case successful = "status"
        case totalReviewComments = "total_reviews_comments"
    }
}
