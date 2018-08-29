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
    @IBOutlet weak var sortByControl: UISegmentedControl!
    @IBOutlet weak var sortDirectionControl: UISegmentedControl!
    @IBOutlet weak var filterLanguagesSwitch: UISwitch!
    
    // MARK: - Public properties
    var viewModel: SettingsViewModel? {
        didSet { updateUI() }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = CGSize(width: 300.0, height: 310.0)
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
    
    @IBAction func sortByAction(_ sender: Any) {
        let sortBy: SortByType = sortByControl.selectedSegmentIndex == 0 ? .dateOfReview : .rating
        viewModel?.settings.sortBy = sortBy
        viewModel?.handleSettingsDidChange()
    }
    
    @IBAction func sortDirectionAction(_ sender: Any) {
        let sortDirection: SortDirectionType  = sortDirectionControl.selectedSegmentIndex == 0 ? .descending : .ascending
        viewModel?.settings.sortDirection = sortDirection
        viewModel?.handleSettingsDidChange()
    }
    
    @IBAction func filterForeignLanguagesSwitchAction(_ sender: Any) {
        viewModel?.settings.isLanguageFilterEnabled = filterLanguagesSwitch.isOn
        viewModel?.handleSettingsDidChange()
    }
    
    // MARK: - Helper
    private func updateUI() {
        guard isViewLoaded, let settings = viewModel?.settings else { return }
        filterRatingSwitch.isOn = settings.isRatingFilterEnabled
        filterLanguagesSwitch.isOn = settings.isLanguageFilterEnabled
        ratingView.isEnabled = settings.isRatingFilterEnabled
        ratingView.value = CGFloat(settings.ratingFilterValue.rawValue)
        sortByControl.selectedSegmentIndex = settings.sortBy == .dateOfReview ? 0 : 1
        sortDirectionControl.selectedSegmentIndex = settings.sortDirection == .descending ? 0 : 1
    }
    
}
