//
//  RatingCommentTableViewModel.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation
import UIKit

class RatingCommentTableViewCellModel: ViewModel, CachingIdentifierProviding {
    
    // MARK: Public properties
    let comment: RatingComment
    let applicationContext: ApplicationContext
    
    var cachingIdentifier: String = UUID().uuidString
    
    // MARK: Private properties
    private var taskIdentifier: Int?
    
    // MARK: - Lifecycle
    init(comment: RatingComment, applicationContext: ApplicationContext) {
        self.comment = comment
        self.applicationContext = applicationContext
    }
}

extension RatingCommentTableViewCellModel: TableViewCellProviding {
    
    func provideCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RatingCommentTableViewCell.reuseIdentifier, for: indexPath) as? RatingCommentTableViewCell else { return UITableViewCell() }
        cell.viewModel = self
        cell.selectionStyle = .none
        cell.titleLabel.text = comment.title ?? "Review comment"
        cell.messageLabel.text = comment.message
        return cell
    }
}
