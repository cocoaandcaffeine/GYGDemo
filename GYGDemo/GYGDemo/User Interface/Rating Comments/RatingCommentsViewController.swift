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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        registerCells()
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 10.0))
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.delegate = self
        
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        loadMoreIfNecessary()
    }
    
    // MARK: - Refresh
    @objc private func reloadData() {
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

extension RatingCommentsViewController: UITableViewDelegate {

}

extension RatingCommentsViewController: RatingCommentsViewModelDelegate {
    
    func ratingCommentsViewModel(_ ratingCommentsViewModel: RatingCommentsViewModel, added addedIndexPaths: [IndexPath], deleted deletedIndexPaths: [IndexPath]?) {
        guard isViewLoaded else { return }
        
        tableView.performBatchUpdates({
            tableView.insertRows(at: addedIndexPaths, with: .fade)
            if let deletedIndexPaths = deletedIndexPaths {
                tableView.deleteRows(at: deletedIndexPaths, with: .fade)
            }
        }, completion: { [weak self] (Bool) in
            self?.refreshControl.endRefreshing()
        })
    }
}
