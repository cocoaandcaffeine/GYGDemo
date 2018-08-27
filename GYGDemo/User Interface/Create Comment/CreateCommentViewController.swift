//
//  CreateCommentViewController.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation
import UIKit

class CreateCommentViewController: UIViewController {
    
    // MARK: - Public properties
    var viewModel: CreateCommentViewModel? {
        didSet {
            
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Write Review"
        
        setupBarButtonItems()
    }
    
    // MARK: - Helper
    private func setupBarButtonItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(createComment(_:)))
    }
    
    // MARK: - Actions
    @objc private func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func createComment(_ sender: UIBarButtonItem) {
        
    }
}
