//
//  RatingCommentsViewController.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation
import UIKit

class RatingCommentsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Public properties
    var viewModel: RatingCommentsViewModel? {
        didSet {
            oldValue?.delegate = nil
            viewModel?.delegate = self
        }
    }
    
    // MARK: - Private properties
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Rating Comments"
        
        setupBarButtonItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        registerCells()
        
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 10.0))
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        loadMoreIfNecessary()
    }
    
    // MARK: - Refresh
    @objc private func reloadData() {
        compactCellSizeCache()
        viewModel?.reloadData()
    }
    
    // MARK: - Helper
    private func registerCells() {
        tableView.register(RatingCommentTableViewCell.nib, forCellReuseIdentifier: RatingCommentTableViewCell.reuseIdentifier)
    }
    
    private func loadMoreIfNecessary() {
        guard let viewModel = viewModel, viewModel.commentViewModels.count == 0 else { return }
        viewModel.loadMore()
    }
    
    private func setupBarButtonItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(showSettings(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "create"), style: .plain, target: self, action: #selector(createComment(_:)))
    }
    
    // MARK: - Actions
    @objc private func showSettings(_ sender: Any) {
        guard let applicationContext = viewModel?.applicationContext else { return }
        let settingsViewModel = SettingsViewModel(applicationContext: applicationContext)
        let viewController = settingsViewModel.provideViewController()
        viewController.modalPresentationStyle = .popover

        let controller = viewController.popoverPresentationController
        controller?.permittedArrowDirections = .up
        controller?.sourceView = sender as? UIView
        controller?.barButtonItem = navigationItem.leftBarButtonItem
        controller?.delegate = self
 
        present(viewController, animated: true, completion: nil)
    }
    
    @objc private func createComment(_ sender: Any) {
        
    }
    
    // MARK: - Maintain Cell Size Cache
    private var cachedCellSizes: [String: CGSize] = [:]
    private func cachedCellSizeForRowAtIndexPath(_ indexPath: IndexPath) -> CGSize? {
        
        guard let commentViewModel = viewModel?.commentViewModels[indexPath.row],
        let cachedSize = cachedCellSizes[commentViewModel.cachingIdentifier] else { return nil }
        
        // Ensure correct cached width
        guard abs(cachedSize.width - tableView.frame.width) < .ulpOfOne else {
            cachedCellSizes.removeValue(forKey: commentViewModel.cachingIdentifier)
            return nil
        }
        return cachedSize
    }
    
    private func cacheSize(_ size: CGSize, forRowAt indexPath: IndexPath) {
        
        guard let commentViewModel = viewModel?.commentViewModels[indexPath.row] else { return }
        cachedCellSizes[commentViewModel.cachingIdentifier] = size
    }
    
    private func compactCellSizeCache() {
        cachedCellSizes.removeAll()
    }
}

extension RatingCommentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.commentViewModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel?.provideCell(tableView, cellForRowAt: indexPath) ?? UITableViewCell()
    }
}

extension RatingCommentsViewController: UITableViewDataSourcePrefetching {
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        guard let viewModel = viewModel else { return }
        let itemIndices = Set(indexPaths.map { $0.item })
        guard itemIndices.contains( viewModel.commentViewModels.count - 1) else { return }
        viewModel.loadMore()
    }
}

extension RatingCommentsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge >= scrollView.contentSize.height)
        {
            viewModel?.loadMore()
        }
    }
}

extension RatingCommentsViewController: UITableViewDelegate {
    
    // MARK: - Cell height caching
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cachedCellSizeForRowAtIndexPath(indexPath)?.height ?? UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cacheSize(cell.bounds.size, forRowAt: indexPath)
    }
}

extension RatingCommentsViewController: RatingCommentsViewModelDelegate {
    
    func ratingCommentsViewModel(_ ratingCommentsViewModel: RatingCommentsViewModel, added addedIndexPaths: [IndexPath], deleted deletedIndexPaths: [IndexPath]?) {
        guard isViewLoaded else { return }
        
        tableView.performBatchUpdates({
            tableView.insertRows(at: addedIndexPaths, with: .none)
            if let deletedIndexPaths = deletedIndexPaths {
                tableView.deleteRows(at: deletedIndexPaths, with: .none)
            }
        }, completion: { [weak self] (Bool) in
            guard let refreshControl = self?.refreshControl, refreshControl.isRefreshing else { return }
            refreshControl.endRefreshing()
        })
    }
    
    func ratingCommentsViewModel(_ ratingCommentsViewModel: RatingCommentsViewModel, show message: String, completion: @escaping(() -> Void)) {
        
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] (Action) in
            if let refreshControl = self?.refreshControl, refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
            completion()
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func ratingCommentsViewModelPageLoadingUnsuccessful(_ ratingCommentsViewModel: RatingCommentsViewModel) {
        guard refreshControl.isRefreshing else { return }
        refreshControl.endRefreshing()
    }
}

extension RatingCommentsViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
