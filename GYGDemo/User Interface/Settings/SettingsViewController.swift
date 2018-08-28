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
        didSet { updateUI() }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel?.handleSettingsDidDisappear()
    }
    
    // MARK: - Actions
    @IBAction func filterRatingSwitchAction(_ sender: Any) {
        ratingView.isEnabled = filterRatingSwitch.isOn
        viewModel?.settings.isRatingFilterEnabled = filterRatingSwitch.isOn
        viewModel?.handleSettingsDidChange()
    }
    
    @IBAction func ratingViewAction(_ sender: Any) {
        guard let rating = RatingType(rawValue: Int(ratingView.value)) else { return }
        viewModel?.settings.ratingFilterValue = rating
        viewModel?.handleSettingsDidChange()
    }
    
    // MARK: - Helper
    private func updateUI() {
        guard isViewLoaded, let settings = viewModel?.settings else { return }
        filterRatingSwitch.isOn = settings.isRatingFilterEnabled
        ratingView.isEnabled = settings.isRatingFilterEnabled
        ratingView.value = CGFloat(settings.ratingFilterValue.rawValue)
    }
    
}
