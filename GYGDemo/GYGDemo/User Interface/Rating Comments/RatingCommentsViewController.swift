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
    
    var viewModel: RatingCommentsViewModel? {
        didSet { updateUI() }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Rating Comments"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let descriptor = TourRatingEndpointDescriptor.standard(path: "/berlin-l17/tempelhof-2-hour-airport-history-tour-berlin-airlift-more-t23776/reviews.json", count: 5, page: 0, rating: nil, sortBy: nil, direction: nil)
        viewModel?.applicationContext.apiClient.perform(for: descriptor, resultType: RatingCommentsPage.self, completion: { (resultPage, error) in
            
            if let resultPage = resultPage {
                print("\(resultPage)")
            } else if let error = error {
                print("\(error)")
            }
        })
    }
    
    // MARK: - Update UI
    private func updateUI() {
        guard isViewLoaded else { return }
    }
}
