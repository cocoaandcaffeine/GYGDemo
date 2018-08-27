//
//  SettingsViewController.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation
import UIKit
import HCSStarRatingView

class SettingsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var filterRatingSwitch: UISwitch!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    
    // MARK: - Public properties
    var viewModel: SettingsViewModel? {
        didSet {
            oldValue?.delegate = nil
            viewModel?.delegate = self
        }
    }
    
    // MARK: - Actions
    @IBAction func filterRatingSwitchAction(_ sender: Any) {
        print("switch")
        ratingView.isEnabled = filterRatingSwitch.isOn
    }
    
    @IBAction func ratingViewAction(_ sender: Any) {
        print("view")
    }
    
}

extension SettingsViewController: SettingsViewModelDelegate {
    
}
