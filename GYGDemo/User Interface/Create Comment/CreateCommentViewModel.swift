//
//  CreateCommentViewModel.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation
import UIKit

class CreateCommentViewModel: ViewModel {
    
    // MARK: - Public properties
    let applicationContext: ApplicationContext
    
    // MARK: - Lifecycle
    init(applicationContext: ApplicationContext) {
        self.applicationContext = applicationContext
    }
}

extension CreateCommentViewModel: ViewControllerProviding {
    
    func provideViewController() -> UIViewController {
        let viewController = CreateCommentViewController.instantiateFromStoryboard()
        viewController.viewModel = self
        return viewController
    }
}
