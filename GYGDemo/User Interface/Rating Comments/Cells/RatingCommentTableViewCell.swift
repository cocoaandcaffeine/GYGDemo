//
//  RatingCommentTableViewCell.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation
import UIKit

class RatingCommentTableViewCell: UITableViewCell, ReusableCellProviding {
 
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: - Public properties
    var viewModel: RatingCommentTableViewCellModel? {
        didSet { updateUI() }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Update UI
    private func updateUI() {

    }
    
    // MARK: - Overrides
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
}
