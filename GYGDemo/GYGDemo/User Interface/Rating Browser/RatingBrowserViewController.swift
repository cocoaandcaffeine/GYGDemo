//
//  RatingBrowserViewController.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation
import UIKit

class RatingBrowserViewController: UIViewController {
    
    var viewModel: RatingBrowserViewModel? {
        didSet { updateUI() }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ratings"
    }
    
    // MARK: - Update UI
    private func updateUI() {
        guard isViewLoaded else { return }
    }
}
