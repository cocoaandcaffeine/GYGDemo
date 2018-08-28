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
    var ratingFilterValue: RatingType = .five
    
    private enum CodingKeys: String, CodingKey {
        case isRatingFilterEnabled = "isRatingFilterEnabled"
        case ratingFilterValue = "ratingFilterValue"
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isRatingFilterEnabled = try container.decode(Bool.self, forKey: .isRatingFilterEnabled)
        self.ratingFilterValue = try container.decode(RatingType.self, forKey: .ratingFilterValue)
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
