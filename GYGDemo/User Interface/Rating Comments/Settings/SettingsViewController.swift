//
//  SettingsViewController.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Outlets
    
    // MARK: - Public properties
    var viewModel: SettingsViewModel? {
        didSet {
            oldValue?.delegate = nil
            viewModel?.delegate = self
        }
    }
}

extension SettingsViewController: SettingsViewModelDelegate {
    
}
