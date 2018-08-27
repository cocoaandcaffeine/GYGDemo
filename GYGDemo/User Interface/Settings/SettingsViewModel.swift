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
    
}

class SettingsViewModel: ViewModel {
    
    // MARK: - Public properties
    let applicationContext: ApplicationContext
    weak var delegate: SettingsViewModelDelegate?
    
    // MARK: - Lifecycle
    init(applicationContext: ApplicationContext) {
        self.applicationContext = applicationContext
    }
}

extension SettingsViewModel: ViewControllerProviding {
    
    func provideViewController() -> UIViewController {
        let viewController = SettingsViewController.instantiateFromStoryboard()
        viewController.viewModel = self
        return viewController
    }
}
