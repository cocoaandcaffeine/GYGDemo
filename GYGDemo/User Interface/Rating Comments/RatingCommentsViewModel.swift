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
    func ratingCommentsViewModel(_ ratingCommentsViewModel: RatingCommentsViewModel, show message: String, completion: @escaping(() -> Void))
}

class RatingCommentsViewModel: ViewModel {
    
    private static let InitialPageLoadCount = 1
    private static let PageSize = 10
    
    // MARK: - Public properties
    let applicationContext: ApplicationContext
    
    weak var delegate: RatingCommentsViewModelDelegate?
    
    // MARK: - Private properties
    private var isLoading: Bool = false
    private var pages: [RatingCommentsPage] = []
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
        let descriptor = RatingCommentsEndpointDescriptor.standard(path: "/berlin-l17/tempelhof-2-hour-airport-history-tour-berlin-airlift-more-t23776/reviews.json", count: RatingCommentsViewModel.PageSize, page: pageIndex, rating: nil, sortBy: nil, direction: nil)
        
        applicationContext.apiClient.perform(for: descriptor, resultType: RatingCommentsPage.self, completion: { [weak self] (result, error) in
            
            guard let page = result, var newPages = self?.pages, var newCommentViewModels = self?.commentViewModels, let applicationContext = self?.applicationContext else {
                self?.handleErrorMessage("Something went wrong. Please try again.")
                return print("Page loading error: \(String(describing: error))")
            }
            
            guard page.successful else {
                self?.handleErrorMessage("Something went wrong. Please try again.")
                return print("Page loading was unsuccessful.")
            }
            
            var startIndex = newCommentViewModels.count
            var endIndex = startIndex + page.comments.count
            var deletedIndexPaths: [IndexPath] = []
            if isReload {
                startIndex = 0
                endIndex = page.comments.count
                for index in 0..<newCommentViewModels.count {
                    deletedIndexPaths.append(IndexPath(item: index, section: 0))
                }
                newPages.removeAll()
                newCommentViewModels.removeAll()
            }
            
            newPages.append(page)
            newCommentViewModels.append(contentsOf: page.comments.map({ RatingCommentTableViewCellModel(comment: $0, applicationContext: applicationContext)}))
            
            self?.pages = newPages
            self?.commentViewModels = newCommentViewModels
            
            var indexPaths: [IndexPath] = []
            for index in startIndex..<endIndex {
                indexPaths.append(IndexPath(item: index, section: 0))
            }
            
            self?.delegate?.ratingCommentsViewModel(self!, added: indexPaths, deleted: deletedIndexPaths.isEmpty ? nil : deletedIndexPaths)
            self?.isLoading = false
            
            if newPages.count < RatingCommentsViewModel.InitialPageLoadCount, newCommentViewModels.count < page.totalReviewComments { self?.loadMore() }
        })
    }
    
    // MARK: - Helper
    private func handleErrorMessage(_ message: String) {
        guard let delegate = delegate else {
            isLoading = false
            return
        }
        
        delegate.ratingCommentsViewModel(self, show: message) { [weak self] in
            self?.isLoading = false
        }
    }
    
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
