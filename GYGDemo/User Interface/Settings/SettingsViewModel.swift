//
//  SettingsViewModel.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation
import UIKit

protocol SettingsViewModelDelegate: class {
    func settingsViewModelSettingsDidChange(_ viewModel: SettingsViewModel)
    func settingsViewModelSettingsDidDisappear(_ viewModel: SettingsViewModel)
}

class SettingsViewModel: ViewModel {
    
    // MARK: - Public properties
    let applicationContext: ApplicationContext
    weak var delegate: SettingsViewModelDelegate?
    
    private (set) lazy var settings: Settings = {
        return Settings.load()
    }()
    
    // MARK: - Lifecycle
    init(applicationContext: ApplicationContext) {
        self.applicationContext = applicationContext
    }
    
    // MARK: - Change handling
    
    func handleSettingsDidChange() {
        settings.save()
        delegate?.settingsViewModelSettingsDidChange(self)
    }
    
    func handleSettingsDidDisappear() {
        delegate?.settingsViewModelSettingsDidDisappear(self)
    }
}

extension SettingsViewModel: ViewControllerProviding {
    
    func provideViewController() -> UIViewController {
        let viewController = SettingsViewController.instantiateFromStoryboard()
        viewController.viewModel = self
        return viewController
    }
}
