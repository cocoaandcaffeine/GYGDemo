//
//  RatingComment.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation

struct RatingComment: Decodable {
    
    enum TravelerType: String, Decodable {
        case couple = "couple"
        case friends = "friends"
        case familyOld = "family_old"
        case solo = "solo"
    }
    
    let author: String
    let dateString: String
    let isForeignLanguage: Bool
    let languageCode: String
    let message: String
    let rating: String
    let identifier: Int
    let reviewerCountry: String
    let reviewerName: String
    let title: String?
    let travelerType: TravelerType?
    
    
    
    private enum CodingKeys: String, CodingKey {
        case author = "author"
        case dateString = "date"
        case isForeignLanguage = "foreignLanguage"
        case languageCode = "languageCode"
        case message = "message"
        case rating = "rating"
        case identifier = "review_id"
        case reviewerCountry = "reviewerCountry"
        case reviewerName = "reviewerName"
        case title = "title"
        case travelerType = "traveler_type"
    }
}
