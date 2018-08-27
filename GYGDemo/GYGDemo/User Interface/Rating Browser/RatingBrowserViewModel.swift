//
//  RatingBrowserViewModel.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation
import UIKit

class RatingBrowserViewModel: ViewModel {
    
    // MARK: - Public properties
    let applicationContext: ApplicationContext
    
    // MARK: - Private properties

    // MARK: - Lifecycle
    init(applicationContext: ApplicationContext) {
        self.applicationContext = applicationContext
    }
}

extension RatingBrowserViewModel: ViewControllerProviding {
    
    func provideViewController() -> UIViewController {
        let viewController = RatingBrowserViewController.instantiateFromStoryboard()
        viewController.viewModel = self
        return viewController
    }
}
