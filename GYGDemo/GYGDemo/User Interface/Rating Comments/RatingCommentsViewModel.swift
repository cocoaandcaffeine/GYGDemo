//
//  RatingBrowserViewModel.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation
import UIKit

protocol RatingCommentsViewModelDelegate: class {
    func ratingCommentsViewModel(_ ratingCommentsViewModel: RatingCommentsViewModel, added addedIndexPaths: [IndexPath], deleted deletedIndexPaths: [IndexPath]?)
}

class RatingCommentsViewModel: ViewModel {
    
    // MARK: - Public properties
    let applicationContext: ApplicationContext
    
    weak var delegate: RatingCommentsViewModelDelegate?
    
    // MARK: - Private properties
    private var isLoading: Bool = false
    private var pages: [RatingCommentsPage] = [] {
        didSet { commentViewModels = pages.flatMap { $0.comments }.map({ RatingCommentTableViewCellModel(comment: $0, applicationContext: applicationContext)})}
    }
    private (set) var commentViewModels: [RatingCommentTableViewCellModel] = []
    
    // MARK: - Lifecycle
    init(applicationContext: ApplicationContext) {
        self.applicationContext = applicationContext
    }
    
    // MARK: - Loading
    func reloadData() {
        loadMore(isReload: true)
    }
    
    func loadMore() {
        loadMore(isReload: false)
    }
    
    private func loadMore(isReload: Bool) {
        guard !isLoading else { return }
        isLoading = true
        
        let pageIndex = isReload ? 0 : pages.count
        let descriptor = RatingCommentsEndpointDescriptor.standard(path: "/berlin-l17/tempelhof-2-hour-airport-history-tour-berlin-airlift-more-t23776/reviews.json", count: 5, page: pageIndex, rating: nil, sortBy: nil, direction: nil)
        
        applicationContext.apiClient.perform(for: descriptor, resultType: RatingCommentsPage.self, completion: { [weak self] (result, error) in
            
            guard let page = result, var newPages = self?.pages, let commentViewModels = self?.commentViewModels else {
                self?.isLoading = false
                return print("Page loading error: \(String(describing: error))")
            }
            
            guard page.successful else {
                self?.isLoading = false
                return print("Page loading was unsuccessful.")
            }
            
            var startIndex = commentViewModels.count
            var endIndex = startIndex + page.comments.count
            var deletedIndexPaths: [IndexPath] = []
            if isReload {
                startIndex = 0
                endIndex = page.comments.count
                for index in 0..<commentViewModels.count {
                    deletedIndexPaths.append(IndexPath(item: index, section: 0))
                }
                newPages.removeAll()
            }
            
            newPages.append(page)
            self?.pages = newPages
            
            var indexPaths: [IndexPath] = []
            for index in startIndex..<endIndex {
                indexPaths.append(IndexPath(item: index, section: 0))
            }
            
            self?.delegate?.ratingCommentsViewModel(self!, added: indexPaths, deleted: deletedIndexPaths.isEmpty ? nil : deletedIndexPaths)
            self?.isLoading = false
        })
    }
    
    // MARK: - Helper

    
}

extension RatingCommentsViewModel: TableViewCellProviding {
    func provideCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return commentViewModels[indexPath.row].provideCell(tableView, cellForRowAt: indexPath)
    }
}

extension RatingCommentsViewModel: ViewControllerProviding {
    
    func provideViewController() -> UIViewController {
        let viewController = RatingCommentsViewController.instantiateFromStoryboard()
        viewController.viewModel = self
        return viewController
    }
}
