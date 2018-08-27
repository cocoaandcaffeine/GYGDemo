//
//  RatingCommentTableViewCell.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation
import UIKit
import HCSStarRatingView

class RatingCommentTableViewCell: UITableViewCell, ReusableCellProviding {
 
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    
    // MARK: - Public properties
    var viewModel: RatingCommentTableViewCellModel? {
        didSet { updateUI() }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }
    
    // MARK: - Update UI
    private func updateUI() {
        
        guard let comment = viewModel?.comment else {
            titleLabel.text = nil
            messageLabel.text = nil
            ratingView.value = 0.0
            infoLabel.text = nil
            return
        }
        titleLabel.text = comment.title ?? "Review comment"
        messageLabel.text = comment.message
        ratingView.value = CGFloat.init(comment.rating)
        infoLabel.text = "\(comment.author)・\(comment.dateString)"
    }
    
    // MARK: - Overrides
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
}
