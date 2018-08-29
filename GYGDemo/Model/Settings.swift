//
//  Settings.swift
//  GYGDemo
//
//  Created by Gert Andreas on 28.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation

class Settings: Codable {
    
    private static let UserDefaultsSettingsKey = "UserDefaultsSettingsKey"
    
    var isRatingFilterEnabled: Bool = false
    var isLanguageFilterEnabled: Bool = false
    var ratingFilterValue: RatingType = .five
    var sortBy: SortByType = .dateOfReview
    var sortDirection: SortDirectionType = .descending
    
    private enum CodingKeys: String, CodingKey {
        case isRatingFilterEnabled = "isRatingFilterEnabled"
        case isLanguageFilterEnabled = "isLanguageFilterEnabled"
        case ratingFilterValue = "ratingFilterValue"
        case sortBy = "sortBy"
        case sortDirection = "sortDirection"
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isRatingFilterEnabled = try container.decode(Bool.self, forKey: .isRatingFilterEnabled)
        self.isLanguageFilterEnabled = try container.decode(Bool.self, forKey: .isLanguageFilterEnabled)
        self.ratingFilterValue = try container.decode(RatingType.self, forKey: .ratingFilterValue)
        self.sortBy = try container.decode(SortByType.self, forKey: .sortBy)
        self.sortDirection = try container.decode(SortDirectionType.self, forKey: .sortDirection)
    }
    
    static func load() -> Settings {
        guard
            let settingsData = UserDefaults.standard.data(forKey: Settings.UserDefaultsSettingsKey),
            let settingsObject = try? JSONDecoder().decode(Settings.self, from: settingsData) else { return Settings() }
        return settingsObject
    }
    
    func save() {
        do {
            let settingsData = try JSONEncoder().encode(self)
            let defaults = UserDefaults.standard
            defaults.set(settingsData, forKey: Settings.UserDefaultsSettingsKey)
            defaults.synchronize()
        } catch {
            print("Error saving settings: \(error)")
        }
    }
}
