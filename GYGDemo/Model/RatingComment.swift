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
        case familyYoung = "family_young"
        case familyOld = "family_old"
        case solo = "solo"
    }
    
    let author: String
    let dateString: String
    let isForeignLanguage: Bool
    let languageCode: String
    let message: String
    let rating: Double
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
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.author = try container.decode(String.self, forKey: .author)
        self.dateString = try container.decode(String.self, forKey: .dateString)
        self.isForeignLanguage = try container.decode(Bool.self, forKey: .isForeignLanguage)
        self.languageCode = try container.decode(String.self, forKey: .languageCode)
        
        let htmlString = try container.decode(String.self, forKey: .message)
        guard let htmlData = htmlString.data(using: .utf16) else {
            throw DecodingError.dataCorruptedError(in: try decoder.unkeyedContainer(), debugDescription: "Invalid message string: \(htmlString)")
        }
        let attributedString = try NSAttributedString(data: htmlData, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        message = attributedString.string
        
        self.rating = Double(try container.decode(String.self, forKey: .rating)) ?? 0.0
        self.identifier = try container.decode(Int.self, forKey: .identifier)
        self.reviewerCountry = try container.decode(String.self, forKey: .reviewerCountry)
        self.reviewerName = try container.decode(String.self, forKey: .reviewerName)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.travelerType = try container.decodeIfPresent(TravelerType.self, forKey: .travelerType)
        
    }
}
